import 'package:flutter/foundation.dart';
import '../models/capture_metadata_model.dart';
import '../models/disease_result_model.dart';
import '../models/verification_model.dart';
import '../services/disease_service.dart';
import '../services/mock_data_service.dart';
import '../services/polygon_service.dart';

enum DiseaseFlowStep {
  upload,
  analyzing,
  result,
  metadataReview,
  assigning,
  verificationComplete,
}

/// State controller for the disease identification + polygon assignment flow
class DiseaseController extends ChangeNotifier {
  DiseaseFlowStep _step = DiseaseFlowStep.upload;
  DiseaseFlowStep get step => _step;

  String? _imagePath;
  String? get imagePath => _imagePath;

  String? _selectedCropType;
  String? get selectedCropType => _selectedCropType;

  DiseaseResult? _result;
  DiseaseResult? get result => _result;

  CaptureMetadata? _captureMetadata;
  CaptureMetadata? get captureMetadata => _captureMetadata;

  VerificationRecord? _verificationRecord;
  VerificationRecord? get verificationRecord => _verificationRecord;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // ─── Set Image ────────────────────────────────────────────────
  void setImage(String imagePath, {String? cropType}) {
    _imagePath = imagePath;
    _selectedCropType = cropType;
    notifyListeners();
  }

  void setCropType(String cropType) {
    _selectedCropType = cropType;
    notifyListeners();
  }

  void setMetadata(CaptureMetadata metadata) {
    _captureMetadata = metadata;
    notifyListeners();
  }

  // ─── Analyze Disease ──────────────────────────────────────────
  Future<void> analyzeDisease() async {
    if (_imagePath == null) return;

    _step = DiseaseFlowStep.analyzing;
    _error = null;
    _isLoading = true;
    notifyListeners();

    try {
      _result = await DiseaseService.instance.analyzeImage(
        imagePath: _imagePath!,
        cropType: _selectedCropType ?? 'unknown',
      );
      _step = DiseaseFlowStep.result;
    } catch (e) {
      _error = 'Disease analysis failed. Please try again.';
      _step = DiseaseFlowStep.upload;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Proceed to Metadata Review ───────────────────────────────
  void proceedToMetadata(CaptureMetadata metadata) {
    _captureMetadata = metadata;
    _step = DiseaseFlowStep.metadataReview;
    notifyListeners();
  }

  // ─── Assign Polygon ───────────────────────────────────────────
  Future<void> assignPolygon() async {
    if (_captureMetadata == null) return;

    _step = DiseaseFlowStep.assigning;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final assignResult = await DiseaseService.instance.assignPolygon(
        _captureMetadata!,
      );

      if (assignResult.success && assignResult.polygonId != null) {
        final matchedField =
            await PolygonService.instance.fetchPolygonById(
              assignResult.polygonId!,
            ) ??
            MockDataService.fields.firstWhere(
              (f) => f.polygonId == assignResult.polygonId,
              orElse: () => MockDataService.fields.first,
            );
        if (_result != null) {
          await PolygonService.instance.markGroundTruth(
            polygonId: assignResult.polygonId!,
            cropType: _result!.cropType,
            confidence: _result!.confidenceScore,
          );
        }
        _verificationRecord = VerificationRecord(
          id: 'ver_${DateTime.now().millisecondsSinceEpoch}',
          userId: 'farmer_001',
          metadata: _captureMetadata!,
          status: VerificationStatus.matched,
          matchedPolygonId: assignResult.polygonId,
          matchConfidence: assignResult.confidence,
          matchedField: matchedField,
          diseaseResultId: _result?.id,
          createdAt: DateTime.now(),
        );
      } else {
        _verificationRecord = VerificationRecord(
          id: 'ver_${DateTime.now().millisecondsSinceEpoch}',
          userId: 'farmer_001',
          metadata: _captureMetadata!,
          status: VerificationStatus.failed,
          createdAt: DateTime.now(),
          notes: assignResult.message,
        );
      }
      _step = DiseaseFlowStep.verificationComplete;
    } catch (e) {
      _error = 'Polygon assignment failed. Please try again.';
      _step = DiseaseFlowStep.metadataReview;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _step = DiseaseFlowStep.upload;
    _imagePath = null;
    _selectedCropType = null;
    _result = null;
    _captureMetadata = null;
    _verificationRecord = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void goBackToResult() {
    _step = DiseaseFlowStep.result;
    notifyListeners();
  }
}
