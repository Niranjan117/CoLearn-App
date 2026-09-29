import 'dart:math';

/// Represents a single coordinate point in a polygon
class PolygonCoordinate {
  final double latitude;
  final double longitude;

  const PolygonCoordinate({required this.latitude, required this.longitude});

  factory PolygonCoordinate.fromJson(Map<String, dynamic> json) {
    return PolygonCoordinate(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'lat': latitude, 'lng': longitude};
}

/// Field verification status
enum FieldStatus { verified, pending, unverified }

extension FieldStatusExtension on FieldStatus {
  String get label {
    switch (this) {
      case FieldStatus.verified:
        return 'Verified';
      case FieldStatus.pending:
        return 'Pending';
      case FieldStatus.unverified:
        return 'Unverified';
    }
  }

  String get code => name;
}

/// Represents an agricultural field polygon
/// ============================================================
/// INTEGRATION POINT (Phase 2)
/// This model maps to the Supabase polygon table schema.
/// Connect polygon_service.dart to fetch real data.
/// ============================================================
class FieldModel {
  final String polygonId;
  final String ownerName;
  final String bhoomiLandId;
  final String cropType;
  final String fieldLabel;
  final double areHectares;
  final FieldStatus status;
  final double confidenceScore; // 0.0 – 1.0
  final bool groundTruthVerified;
  final List<PolygonCoordinate> coordinates;
  final double centerLatitude;
  final double centerLongitude;
  final String district;
  final String state;
  final DateTime? lastVerifiedAt;
  final String? assignedByUserId;
  final Map<String, dynamic> tableData;

  const FieldModel({
    required this.polygonId,
    required this.ownerName,
    required this.bhoomiLandId,
    required this.cropType,
    required this.fieldLabel,
    required this.areHectares,
    required this.status,
    required this.confidenceScore,
    required this.groundTruthVerified,
    required this.coordinates,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.district,
    required this.state,
    this.lastVerifiedAt,
    this.assignedByUserId,
    this.tableData = const {},
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    final coordinates = _coordinatesFromJson(json);
    final centerLatitude = _number(json['centroid_y']);
    final centerLongitude = _number(json['centroid_x']);

    if (centerLatitude == null || centerLongitude == null) {
      throw const FormatException(
        'Supabase polygon is missing centroid_x or centroid_y',
      );
    }

    return FieldModel(
      polygonId: _string(json['polygon_id']),
      ownerName: _string(json['owner_name']),
      bhoomiLandId: _string(json['bho_id'] ?? json['bhoomi_land_id']),
      cropType: _string(json['crop_type']),
      fieldLabel: _string(json['field_label']),
      areHectares: _number(json['area_hectares']) ?? 0,
      status: FieldStatus.values.firstWhere(
        (s) => s.code == (json['status'] as String?),
        orElse: () => FieldStatus.unverified,
      ),
      confidenceScore:
          _number(json['confidence_score'] ?? json['confidence_mean']) ?? 0,
      groundTruthVerified: _boolValue(
        json['ground_truth_verified'] ?? json['ground_truth'],
      ),
      coordinates: coordinates,
      centerLatitude: centerLatitude,
      centerLongitude: centerLongitude,
      district: _string(json['district']),
      state: _string(json['state']),
      lastVerifiedAt: json['last_verified_at'] != null
          ? DateTime.parse(json['last_verified_at'] as String)
          : null,
      assignedByUserId: json['assigned_by_user_id'] as String?,
      tableData: Map<String, dynamic>.unmodifiable(json),
    );
  }

  static double? _number(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value');

  static String _string(dynamic value) => value?.toString() ?? '';

  static bool _boolValue(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value?.toString().toLowerCase() == 'true';
  }

  static List<PolygonCoordinate> _coordinatesFromJson(
    Map<String, dynamic> json,
  ) {
    final rawCoordinates = json['coordinates'] ?? json['polygon'];
    if (rawCoordinates is List) {
      return rawCoordinates
          .whereType<Map<String, dynamic>>()
          .map(PolygonCoordinate.fromJson)
          .toList();
    }
    final wkt = json['geometry_wkt'] as String?;
    if (wkt == null) return const [];
    return _parseWktPolygon(wkt);
  }

  static List<PolygonCoordinate> _parseWktPolygon(String wkt) {
    final normalized = wkt.trim();
    final start = normalized.indexOf('((');
    final end = normalized.indexOf('))', start + 2);
    if (start == -1 || end == -1) return const [];
    return normalized
        .substring(start + 2, end)
        .split(',')
        .map((pair) => pair.trim().split(RegExp(r'\s+')))
        .where((parts) => parts.length >= 2)
        .map(
          (parts) => PolygonCoordinate(
            latitude: double.tryParse(parts[1]) ?? double.nan,
            longitude: double.tryParse(parts[0]) ?? double.nan,
          ),
        )
        .where((point) => point.latitude.isFinite && point.longitude.isFinite)
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'polygon_id': polygonId,
    'owner_name': ownerName,
    'bhoomi_land_id': bhoomiLandId,
    'crop_type': cropType,
    'field_label': fieldLabel,
    'area_hectares': areHectares,
    'status': status.code,
    'confidence_score': confidenceScore,
    'ground_truth_verified': groundTruthVerified,
    'coordinates': coordinates.map((c) => c.toJson()).toList(),
    'center_lat': centerLatitude,
    'center_lng': centerLongitude,
    'district': district,
    'state': state,
    'last_verified_at': lastVerifiedAt?.toIso8601String(),
    'assigned_by_user_id': assignedByUserId,
  };

  /// Compute bounding box center from coordinates
  static Map<String, double> computeCenter(List<PolygonCoordinate> coords) {
    if (coords.isEmpty) return {'lat': 0, 'lng': 0};
    double sumLat = 0, sumLng = 0;
    for (final c in coords) {
      sumLat += c.latitude;
      sumLng += c.longitude;
    }
    return {'lat': sumLat / coords.length, 'lng': sumLng / coords.length};
  }

  /// Approximate area in hectares from coordinates (Shoelace formula)
  static double approximateAreaHectares(List<PolygonCoordinate> coords) {
    if (coords.length < 3) return 0;
    double area = 0;
    const earthRadius = 6371000.0; // meters
    final n = coords.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      final xi =
          coords[i].longitude *
          (pi / 180) *
          earthRadius *
          cos(coords[i].latitude * pi / 180);
      final yi = coords[i].latitude * (pi / 180) * earthRadius;
      final xj =
          coords[j].longitude *
          (pi / 180) *
          earthRadius *
          cos(coords[j].latitude * pi / 180);
      final yj = coords[j].latitude * (pi / 180) * earthRadius;
      area += xi * yj - xj * yi;
    }
    return (area.abs() / 2) / 10000; // Convert m² to hectares
  }
}
