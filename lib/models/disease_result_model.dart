/// Severity of a plant disease
enum DiseaseSeverity { mild, moderate, severe, healthy }

extension DiseaseSeverityExtension on DiseaseSeverity {
  String get label {
    switch (this) {
      case DiseaseSeverity.mild:
        return 'Mild';
      case DiseaseSeverity.moderate:
        return 'Moderate';
      case DiseaseSeverity.severe:
        return 'Severe';
      case DiseaseSeverity.healthy:
        return 'Healthy';
    }
  }
}

/// A treatment recommendation for the identified disease
class TreatmentRecommendation {
  final String title;
  final String description;
  final String iconCode; // Material icon codepoint as hex string
  final bool isUrgent;

  const TreatmentRecommendation({
    required this.title,
    required this.description,
    required this.iconCode,
    this.isUrgent = false,
  });
}

/// Result of a disease identification analysis
/// ============================================================
/// INTEGRATION POINT (Phase 2)
/// This model will be populated from the ML model API response.
/// Replace mock data in disease_service.dart with real response.
/// ============================================================
class DiseaseResult {
  final String id;
  final String diseaseName;
  final String scientificName;
  final String cropType;
  final DiseaseSeverity severity;
  final double confidenceScore; // 0.0 – 1.0
  final String description;
  final double affectedAreaPercent;
  final List<TreatmentRecommendation> treatments;
  final String? capturedImagePath;
  final DateTime analyzedAt;
  final bool isHealthy;

  const DiseaseResult({
    required this.id,
    required this.diseaseName,
    required this.scientificName,
    required this.cropType,
    required this.severity,
    required this.confidenceScore,
    required this.description,
    required this.affectedAreaPercent,
    required this.treatments,
    this.capturedImagePath,
    required this.analyzedAt,
    required this.isHealthy,
  });

  factory DiseaseResult.fromJson(Map<String, dynamic> json) {
    return DiseaseResult(
      id: json['id'] as String,
      diseaseName: json['disease_name'] as String,
      scientificName: json['scientific_name'] as String,
      cropType: json['crop_type'] as String,
      severity: DiseaseSeverity.values.firstWhere(
        (s) => s.name == json['severity'],
        orElse: () => DiseaseSeverity.mild,
      ),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      description: json['description'] as String,
      affectedAreaPercent: (json['affected_area_percent'] as num).toDouble(),
      treatments: (json['treatments'] as List? ?? [])
          .map((t) => TreatmentRecommendation(
                title: t['title'] as String,
                description: t['description'] as String,
                iconCode: t['icon_code'] as String? ?? 'e3f4',
                isUrgent: t['is_urgent'] as bool? ?? false,
              ))
          .toList(),
      capturedImagePath: json['captured_image_path'] as String?,
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
      isHealthy: json['is_healthy'] as bool? ?? false,
    );
  }
}
