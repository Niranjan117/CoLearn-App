/// Capture metadata collected from the device at the time of image capture.
/// This is the "Zero Data Waste" payload used to identify the farmer's
/// agricultural field polygon via the polygon-assignment API.
///
/// ============================================================
/// INTEGRATION POINT (Phase 2)
/// POST /detect_and_assign_polygon
/// Payload: {
///   "user_lat": user_lat,
///   "user_lng": user_lng,
///   "gps_score": gps_score,
///   "compass_deg": compass_deg,
///   "input_crop_type": input_crop_type
/// }
/// ============================================================
class CaptureMetadata {
  /// Device GPS latitude at time of capture
  final double userLat;

  /// Device GPS longitude at time of capture
  final double userLng;

  /// GPS accuracy score (lower = better; in meters)
  final double gpsScore;

  /// Compass bearing in degrees (0–360, where 0/360 = North)
  final double compassDeg;

  /// Crop type selected by farmer
  final String inputCropType;

  /// Timestamp of capture
  final DateTime capturedAt;

  /// Altitude (optional metadata)
  final double? altitudeMeters;

  /// Path to the captured image file
  final String? imagePath;

  const CaptureMetadata({
    required this.userLat,
    required this.userLng,
    required this.gpsScore,
    required this.compassDeg,
    required this.inputCropType,
    required this.capturedAt,
    this.altitudeMeters,
    this.imagePath,
  });

  /// Converts to the exact API payload structure as documented
  Map<String, dynamic> toApiPayload() => {
        'user_lat': userLat,
        'user_lng': userLng,
        'gps_score': gpsScore,
        'compass_deg': compassDeg,
        'input_crop_type': inputCropType,
      };

  /// Human-readable compass direction from degrees
  String get compassDirection {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N'];
    final index = ((compassDeg + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  String get formattedLat {
    final dir = userLat >= 0 ? 'N' : 'S';
    return '${userLat.abs().toStringAsFixed(6)}° $dir';
  }

  String get formattedLng {
    final dir = userLng >= 0 ? 'E' : 'W';
    return '${userLng.abs().toStringAsFixed(6)}° $dir';
  }

  String get gpsAccuracyLabel {
    if (gpsScore <= 5) return 'Excellent';
    if (gpsScore <= 10) return 'Good';
    if (gpsScore <= 20) return 'Fair';
    return 'Poor';
  }

  CaptureMetadata copyWith({
    double? userLat,
    double? userLng,
    double? gpsScore,
    double? compassDeg,
    String? inputCropType,
    DateTime? capturedAt,
    double? altitudeMeters,
    String? imagePath,
  }) {
    return CaptureMetadata(
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      gpsScore: gpsScore ?? this.gpsScore,
      compassDeg: compassDeg ?? this.compassDeg,
      inputCropType: inputCropType ?? this.inputCropType,
      capturedAt: capturedAt ?? this.capturedAt,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

/// Crop types supported by the system
class CropTypes {
  CropTypes._();

  static const List<CropTypeOption> all = [
    CropTypeOption(id: 'rice', label: 'Rice', emoji: '🌾', icon: '🌾'),
    CropTypeOption(id: 'wheat', label: 'Wheat', emoji: '🌾', icon: '🌾'),
    CropTypeOption(id: 'cotton', label: 'Cotton', emoji: '🌿', icon: '🌿'),
    CropTypeOption(id: 'sugarcane', label: 'Sugarcane', emoji: '🎋', icon: '🎋'),
    CropTypeOption(id: 'maize', label: 'Maize / Corn', emoji: '🌽', icon: '🌽'),
    CropTypeOption(id: 'pulses', label: 'Pulses / Dal', emoji: '🫘', icon: '🫘'),
    CropTypeOption(id: 'vegetables', label: 'Vegetables', emoji: '🥦', icon: '🥦'),
    CropTypeOption(id: 'soybean', label: 'Soybean', emoji: '🌱', icon: '🌱'),
    CropTypeOption(id: 'groundnut', label: 'Groundnut', emoji: '🥜', icon: '🥜'),
    CropTypeOption(id: 'sunflower', label: 'Sunflower', emoji: '🌻', icon: '🌻'),
    CropTypeOption(id: 'turmeric', label: 'Turmeric', emoji: '🌿', icon: '🌿'),
    CropTypeOption(id: 'other', label: 'Other', emoji: '🌿', icon: '🌿'),
  ];
}

class CropTypeOption {
  final String id;
  final String label;
  final String emoji;
  final String icon;

  const CropTypeOption({
    required this.id,
    required this.label,
    required this.emoji,
    required this.icon,
  });
}
