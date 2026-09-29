import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/capture_metadata_model.dart';
import '../models/disease_result_model.dart';
import '../models/verification_model.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

/// Service for disease identification and polygon assignment.
/// ============================================================
/// INTEGRATION POINT (Phase 2)
/// 1. Disease model: POST to AppConfig.diseaseModelEndpoint
/// 2. Polygon assignment: POST to AppConfig.polygonAssignEndpoint
///    Payload: { user_lat, user_lng, gps_score, compass_deg, input_crop_type }
/// ============================================================
class DiseaseService {
  DiseaseService._();
  static final DiseaseService instance = DiseaseService._();

  /// Analyze an image for plant disease
  Future<DiseaseResult> analyzeImage({
    required String imagePath,
    required String cropType,
  }) async {
    if (AppConfig.enableDiseaseModel) {
      // ============================================================
      // INTEGRATION POINT (Phase 2)
      // Real ML model API call:
      // POST AppConfig.diseaseModelEndpoint
      // Body: multipart/form-data with image file + crop_type
      // ============================================================
      return _callDiseaseModel(imagePath: imagePath, cropType: cropType);
    }

    // Phase 1: Simulate analysis delay and return mock result
    await Future.delayed(const Duration(seconds: 3));
    final results = MockDataService.diseaseResults;
    // Return a result matching the crop type, or default to first
    return results.firstWhere(
      (r) => r.cropType.toLowerCase() == cropType.toLowerCase(),
      orElse: () => results.first,
    );
  }

  /// Submit capture metadata to the polygon assignment API
  Future<PolygonAssignmentResult> assignPolygon(
    CaptureMetadata metadata,
  ) async {
    if (AppConfig.enablePolygonAssignment) {
      // ============================================================
      // INTEGRATION POINT (Phase 2)
      // POST AppConfig.polygonAssignEndpoint
      // Exact documented payload:
      // {
      //   "user_lat": metadata.userLat,
      //   "user_lng": metadata.userLng,
      //   "gps_score": metadata.gpsScore,
      //   "compass_deg": metadata.compassDeg,
      //   "input_crop_type": metadata.inputCropType
      // }
      // ============================================================
      return _callPolygonAssignApi(metadata);
    }

    // Phase 1: Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    final mockVerifications = MockDataService.verificationHistory;
    final matched = mockVerifications.firstWhere(
      (v) => v.status == VerificationStatus.matched,
      orElse: () => mockVerifications.first,
    );
    return PolygonAssignmentResult(
      success: true,
      polygonId: matched.matchedPolygonId,
      confidence: matched.matchConfidence ?? 0.85,
      message: 'Polygon matched successfully',
    );
  }

  // ============================================================
  // INTEGRATION POINT (Phase 2) — real implementations below
  // ============================================================
  Future<DiseaseResult> _callDiseaseModel({
    required String imagePath,
    required String cropType,
  }) async {
    final imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      throw Exception('The selected image could not be found.');
    }

    final uploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConfig.diseaseModelEndpoint}/gradio_api/upload'),
    )..files.add(await http.MultipartFile.fromPath('files', imagePath));
    final uploadResponse = await http.Response.fromStream(
      await uploadRequest.send().timeout(const Duration(seconds: 60)),
    );
    if (uploadResponse.statusCode != 200) {
      throw Exception('PlantGuard upload failed: ${uploadResponse.body}');
    }
    final uploadData = jsonDecode(uploadResponse.body) as List<dynamic>;
    final serverPath = uploadData.first as String;

    final queueResponse = await http
        .post(
          Uri.parse(
            '${AppConfig.diseaseModelEndpoint}/gradio_api/call/predict',
          ),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'data': [
              {'path': serverPath},
            ],
          }),
        )
        .timeout(const Duration(seconds: 60));
    if (queueResponse.statusCode != 200) {
      throw Exception('PlantGuard queue failed: ${queueResponse.body}');
    }
    final eventId =
        (jsonDecode(queueResponse.body) as Map<String, dynamic>)['event_id']
            as String?;
    if (eventId == null || eventId.isEmpty) {
      throw Exception('PlantGuard did not return an event id.');
    }

    final resultResponse = await http
        .get(
          Uri.parse(
            '${AppConfig.diseaseModelEndpoint}/gradio_api/call/predict/$eventId',
          ),
        )
        .timeout(const Duration(seconds: 90));
    if (resultResponse.statusCode != 200) {
      throw Exception('PlantGuard result failed: ${resultResponse.body}');
    }

    Map<String, dynamic>? prediction;
    for (final line in resultResponse.body.split('\n')) {
      if (!line.startsWith('data: ')) continue;
      final rawData = line.substring(6).trim();
      if (rawData.isEmpty || rawData == '[DONE]') continue;
      final parsed = jsonDecode(rawData);
      if (parsed is List && parsed.isNotEmpty && parsed.first is Map) {
        prediction = Map<String, dynamic>.from(parsed.first as Map);
        break;
      }
    }
    if (prediction == null) {
      throw Exception('PlantGuard returned no prediction.');
    }

    final label = prediction['label'] as String? ?? 'Unknown condition';
    final confidences = (prediction['confidences'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
    final confidence = confidences
        .map((item) => (item['confidence'] as num?)?.toDouble() ?? 0)
        .fold<double>(0, (best, value) => value > best ? value : best);
    final healthy = label.toLowerCase().contains('healthy');
    final severity = healthy
        ? DiseaseSeverity.healthy
        : confidence >= 0.85
        ? DiseaseSeverity.severe
        : confidence >= 0.65
        ? DiseaseSeverity.moderate
        : DiseaseSeverity.mild;

    return DiseaseResult(
      id: 'plantguard_${DateTime.now().millisecondsSinceEpoch}',
      diseaseName: label,
      scientificName: '—',
      cropType: cropType,
      severity: severity,
      confidenceScore: confidence,
      description: healthy
          ? 'The PlantGuard model did not detect visible disease.'
          : 'PlantGuard identified $label in the submitted image.',
      affectedAreaPercent: healthy ? 0 : 100,
      treatments: const [],
      capturedImagePath: imagePath,
      analyzedAt: DateTime.now(),
      isHealthy: healthy,
    );
  }

  Future<PolygonAssignmentResult> _callPolygonAssignApi(
    CaptureMetadata metadata,
  ) async {
    final response = await ApiService.instance.post(
      AppConfig.polygonAssignEndpoint,
      metadata.toApiPayload(),
    );
    return PolygonAssignmentResult(
      success: response['success'] as bool? ?? false,
      polygonId: response['polygon_id'] as String?,
      confidence: (response['confidence'] as num?)?.toDouble() ?? 0.0,
      message: response['message'] as String? ?? '',
    );
  }
}

/// Result from the polygon assignment API
class PolygonAssignmentResult {
  final bool success;
  final String? polygonId;
  final double confidence;
  final String message;

  const PolygonAssignmentResult({
    required this.success,
    this.polygonId,
    required this.confidence,
    required this.message,
  });
}
