import 'package:flutter/foundation.dart';
import '../models/capture_metadata_model.dart';
import '../services/camera_service.dart';
import '../services/location_service.dart';

enum CaptureStep { camera, preview, cropSelection, done }

/// State controller for the 3-step image capture flow
class CaptureController extends ChangeNotifier {
  CaptureStep _step = CaptureStep.camera;
  CaptureStep get step => _step;

  String? _capturedImagePath;
  String? get capturedImagePath => _capturedImagePath;

  CaptureMetadata? _metadata;
  CaptureMetadata? get metadata => _metadata;

  String? _selectedCropType;
  String? get selectedCropType => _selectedCropType;

  bool _isLoadingLocation = false;
  bool get isLoadingLocation => _isLoadingLocation;

  String? _locationError;
  String? get locationError => _locationError;

  double? _currentLat;
  double? _currentLng;
  double? _gpsAccuracy;
  double? get currentLat => _currentLat;
  double? get currentLng => _currentLng;
  double? get gpsAccuracy => _gpsAccuracy;

  // ─── Location Fetch ────────────────────────────────────────────
  Future<void> fetchCurrentLocation() async {
    _isLoadingLocation = true;
    _locationError = null;
    notifyListeners();

    final result = await LocationService.instance.getCurrentLocation();
    if (result.isSuccess && result.position != null) {
      _currentLat = result.position!.latitude;
      _currentLng = result.position!.longitude;
      _gpsAccuracy = result.position!.accuracy;
    } else {
      _locationError = result.errorMessage;
      // Use fallback mock location for Phase 1
      _currentLat = 15.4589;
      _currentLng = 75.0078;
      _gpsAccuracy = 8.5;
    }

    _isLoadingLocation = false;
    notifyListeners();
  }

  // ─── Camera Capture ────────────────────────────────────────────
  Future<void> captureImage() async {
    final result = await CameraService.instance.captureFromCamera();
    if (result.isSuccess && result.imagePath != null) {
      _capturedImagePath = result.imagePath;
      await fetchCurrentLocation();
      _step = CaptureStep.preview;
      notifyListeners();
    }
  }

  Future<void> pickFromGallery() async {
    final result = await CameraService.instance.pickFromGallery();
    if (result.isSuccess && result.imagePath != null) {
      _capturedImagePath = result.imagePath;
      await fetchCurrentLocation();
      _step = CaptureStep.preview;
      notifyListeners();
    }
  }

  // ─── Step Navigation ──────────────────────────────────────────
  void confirmPreview() {
    _step = CaptureStep.cropSelection;
    notifyListeners();
  }

  void retake() {
    _capturedImagePath = null;
    _step = CaptureStep.camera;
    notifyListeners();
  }

  void selectCrop(String cropType) {
    _selectedCropType = cropType;
    notifyListeners();
  }

  CaptureMetadata? buildMetadata(double compassDeg) {
    if (_currentLat == null || _currentLng == null || _selectedCropType == null) {
      return null;
    }
    _metadata = CaptureMetadata(
      userLat: _currentLat!,
      userLng: _currentLng!,
      gpsScore: _gpsAccuracy ?? 10.0,
      compassDeg: compassDeg,
      inputCropType: _selectedCropType!,
      capturedAt: DateTime.now(),
      imagePath: _capturedImagePath,
    );
    return _metadata;
  }

  void confirmCrop(double compassDeg) {
    buildMetadata(compassDeg);
    _step = CaptureStep.done;
    notifyListeners();
  }

  void reset() {
    _step = CaptureStep.camera;
    _capturedImagePath = null;
    _metadata = null;
    _selectedCropType = null;
    _locationError = null;
    _currentLat = null;
    _currentLng = null;
    _gpsAccuracy = null;
    notifyListeners();
  }
}
