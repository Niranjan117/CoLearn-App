import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for camera and image gallery access
class CameraService {
  CameraService._();
  static final CameraService instance = CameraService._();

  final ImagePicker _picker = ImagePicker();

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  /// Open camera and capture an image
  Future<CameraResult> captureFromCamera({
    int imageQuality = 90,
    double? maxWidth,
    double? maxHeight,
  }) async {
    final hasPermission = await requestCameraPermission();
    if (!hasPermission) {
      return CameraResult.permissionDenied();
    }

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth ?? 1920,
        maxHeight: maxHeight ?? 1920,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (file == null) return CameraResult.cancelled();
      return CameraResult.success(file.path);
    } catch (e) {
      return CameraResult.failure('Camera error: $e');
    }
  }

  /// Pick image from gallery
  Future<CameraResult> pickFromGallery({int imageQuality = 90}) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      if (file == null) return CameraResult.cancelled();
      return CameraResult.success(file.path);
    } catch (e) {
      return CameraResult.failure('Gallery error: $e');
    }
  }
}

enum CameraResultStatus { success, permissionDenied, cancelled, failure }

class CameraResult {
  final CameraResultStatus status;
  final String? imagePath;
  final String? errorMessage;

  const CameraResult._({
    required this.status,
    this.imagePath,
    this.errorMessage,
  });

  factory CameraResult.success(String path) =>
      CameraResult._(status: CameraResultStatus.success, imagePath: path);

  factory CameraResult.permissionDenied() =>
      CameraResult._(
        status: CameraResultStatus.permissionDenied,
        errorMessage: 'Camera permission denied. Please allow camera access in settings.',
      );

  factory CameraResult.cancelled() =>
      CameraResult._(status: CameraResultStatus.cancelled);

  factory CameraResult.failure(String msg) =>
      CameraResult._(status: CameraResultStatus.failure, errorMessage: msg);

  bool get isSuccess => status == CameraResultStatus.success;
  bool get isCancelled => status == CameraResultStatus.cancelled;
  bool get isPermissionDenied => status == CameraResultStatus.permissionDenied;
}
