import 'capture_metadata_model.dart';
import 'field_model.dart';

/// Status of a polygon matching / verification attempt
enum VerificationStatus { matched, pending, failed, reviewing }

extension VerificationStatusExt on VerificationStatus {
  String get label {
    switch (this) {
      case VerificationStatus.matched:
        return 'Field Matched';
      case VerificationStatus.pending:
        return 'Pending Review';
      case VerificationStatus.failed:
        return 'No Match Found';
      case VerificationStatus.reviewing:
        return 'Under Review';
    }
  }
}

/// A record of a verification attempt — metadata → polygon match
/// ============================================================
/// INTEGRATION POINT (Phase 2)
/// Populated after POST /detect_and_assign_polygon response.
/// Store in Supabase for the verification history.
/// ============================================================
class VerificationRecord {
  final String id;
  final String userId;
  final CaptureMetadata metadata;
  final VerificationStatus status;
  final String? matchedPolygonId;
  final double? matchConfidence; // 0.0 – 1.0
  final FieldModel? matchedField;
  final String? diseaseResultId;
  final String? notes;
  final DateTime createdAt;

  const VerificationRecord({
    required this.id,
    required this.userId,
    required this.metadata,
    required this.status,
    this.matchedPolygonId,
    this.matchConfidence,
    this.matchedField,
    this.diseaseResultId,
    this.notes,
    required this.createdAt,
  });

  bool get hasMatch =>
      status == VerificationStatus.matched && matchedField != null;
}

/// Summary stats for the dashboard
class VerificationStats {
  final int totalAnalyses;
  final int matchedFields;
  final int pendingReviews;
  final int failedMatches;
  final int thisMonthAnalyses;

  const VerificationStats({
    required this.totalAnalyses,
    required this.matchedFields,
    required this.pendingReviews,
    required this.failedMatches,
    required this.thisMonthAnalyses,
  });

  double get successRate =>
      totalAnalyses == 0 ? 0 : matchedFields / totalAnalyses;
}
