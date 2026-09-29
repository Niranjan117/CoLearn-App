import 'package:geolocator/geolocator.dart';
import '../config/app_config.dart';

/// Service for obtaining device GPS location and accuracy
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Request location permission and get current position
  Future<LocationResult> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult.failure('Location services are disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult.failure('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult.failure(
          'Location permission permanently denied. Please enable in app settings.');
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: AppConfig.locationTimeout,
        ),
      );
      return LocationResult.success(position);
    } catch (e) {
      return LocationResult.failure('Failed to get location: $e');
    }
  }

  /// Stream location updates
  Stream<Position> get locationStream => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
        ),
      );

  /// Check if location permission is granted
  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}

class LocationResult {
  final bool isSuccess;
  final Position? position;
  final String? errorMessage;

  const LocationResult._({
    required this.isSuccess,
    this.position,
    this.errorMessage,
  });

  factory LocationResult.success(Position position) =>
      LocationResult._(isSuccess: true, position: position);

  factory LocationResult.failure(String message) =>
      LocationResult._(isSuccess: false, errorMessage: message);

  /// GPS accuracy in meters (lower is better)
  double get accuracy => position?.accuracy ?? 999.0;
}
