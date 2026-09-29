import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/capture_metadata_model.dart';
import '../../providers/capture_controller.dart';
import '../../services/camera_service.dart';
import '../../widgets/common/agri_button.dart';

/// 3-Step Capture Flow: Camera → Preview → Crop Selection
class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CaptureController(),
      child: const _CaptureFlow(),
    );
  }
}

class _CaptureFlow extends StatelessWidget {
  const _CaptureFlow();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CaptureController>();

    switch (ctrl.step) {
      case CaptureStep.camera:
        return const _CameraStep();
      case CaptureStep.preview:
        return const _PreviewStep();
      case CaptureStep.cropSelection:
        return const _CropSelectionStep();
      case CaptureStep.done:
        return const _DoneStep();
    }
  }
}

// ─── Step 1: Camera ───────────────────────────────────────────

class _CameraStep extends StatefulWidget {
  const _CameraStep();

  @override
  State<_CameraStep> createState() => _CameraStepState();
}

class _CameraStepState extends State<_CameraStep> {
  bool _hasPermission = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    context.read<CaptureController>().fetchCurrentLocation();
  }

  Future<void> _checkPermission() async {
    final granted = await CameraService.instance.requestCameraPermission();
    if (mounted) setState(() => _hasPermission = granted);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CaptureController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Capture Plant Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_off_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: !_hasPermission
          ? _PermissionDeniedView(onRequest: _checkPermission)
          : Stack(
              children: [
                // Camera preview placeholder (real camera via camera package)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFF1A1A1A),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 80,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),

                // Grid guide overlay
                Positioned.fill(child: _CameraGridOverlay()),

                // Top info badges
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        _MetadataBadge(
                          icon: Icons.gps_fixed_rounded,
                          label: ctrl.isLoadingLocation
                              ? 'Getting GPS...'
                              : ctrl.currentLat != null
                                  ? '${ctrl.currentLat!.toStringAsFixed(4)}°N'
                                  : 'No GPS',
                          color: ctrl.currentLat != null
                              ? AppTheme.successGreen
                              : AppTheme.warningAmber,
                        ),
                        const SizedBox(width: 8),
                        _MetadataBadge(
                          icon: Icons.explore_rounded,
                          label: 'N 12°',
                          color: AppTheme.infoBlue,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom controls
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Info text
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentTeal.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppTheme.accentTeal.withValues(alpha: 0.4)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  color: Colors.white70, size: 14),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'GPS & compass data will be used to identify your field polygon',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white70,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Shutter row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Gallery button
                            _CircleButton(
                              icon: Icons.photo_library_rounded,
                              onTap: () async {
                                await ctrl.pickFromGallery();
                              },
                            ),
                            // Shutter
                            GestureDetector(
                              onTap: _isCapturing
                                  ? null
                                  : () async {
                                      setState(() => _isCapturing = true);
                                      await ctrl.captureImage();
                                      if (mounted) {
                                        setState(() => _isCapturing = false);
                                      }
                                    },
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 3),
                                  color: _isCapturing
                                      ? Colors.white38
                                      : Colors.white,
                                ),
                                child: _isCapturing
                                    ? const Padding(
                                        padding: EdgeInsets.all(20),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: AppTheme.primaryGreen,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                            // Switch camera
                            _CircleButton(
                              icon: Icons.flip_camera_ios_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CameraGridOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    // Rule of thirds grid
    canvas.drawLine(
        Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(size.width * 2 / 3, 0),
        Offset(size.width * 2 / 3, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height / 3), Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, size.height * 2 / 3),
        Offset(size.width, size.height * 2 / 3), paint);

    // Center circle
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), 24, circlePaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MetadataBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetadataBadge(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.15),
          border: Border.all(color: Colors.white38),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  final VoidCallback onRequest;
  const _PermissionDeniedView({required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_rounded,
                size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            const Text(
              'Camera Access Required',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'To capture plant images for disease identification, '
              'please allow camera access.',
              style: TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRequest,
              icon: const Icon(Icons.security_rounded),
              label: const Text('Allow Camera Access'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 2: Preview ──────────────────────────────────────────

class _PreviewStep extends StatelessWidget {
  const _PreviewStep();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CaptureController>();
    final imagePath = ctrl.capturedImagePath;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Review Image'),
      ),
      body: Column(
        children: [
          // Image preview
          Expanded(
            flex: 3,
            child: imagePath != null
                ? Image.file(File(imagePath), fit: BoxFit.contain)
                : Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Center(
                      child: Icon(Icons.image_rounded,
                          size: 80, color: Colors.white24),
                    ),
                  ),
          ),

          // Metadata panel
          Container(
            color: const Color(0xFF111111),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Captured Metadata',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'This data will be used for field polygon identification',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetadataRow(
                        icon: Icons.gps_fixed_rounded,
                        label: 'Latitude',
                        value: ctrl.currentLat?.toStringAsFixed(6) ?? '—',
                        color: AppTheme.successGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetadataRow(
                        icon: Icons.gps_fixed_rounded,
                        label: 'Longitude',
                        value: ctrl.currentLng?.toStringAsFixed(6) ?? '—',
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _MetadataRow(
                        icon: Icons.signal_cellular_alt_rounded,
                        label: 'GPS Accuracy',
                        value: ctrl.gpsAccuracy != null
                            ? '${ctrl.gpsAccuracy!.toStringAsFixed(1)}m'
                            : '—',
                        color: AppTheme.infoBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetadataRow(
                        icon: Icons.explore_rounded,
                        label: 'Compass',
                        value: '12° N',
                        color: AppTheme.secondaryGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AgriButton(
                        label: 'Retake',
                        variant: AgriButtonVariant.outline,
                        icon: Icons.refresh_rounded,
                        fullWidth: true,
                        onPressed: () =>
                            context.read<CaptureController>().retake(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AgriButton(
                        label: 'Confirm',
                        icon: Icons.check_rounded,
                        fullWidth: true,
                        onPressed: () =>
                            context.read<CaptureController>().confirmPreview(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetadataRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        color: color.withValues(alpha: 0.7))),
                Text(value,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 3: Crop Selection ────────────────────────────────────

class _CropSelectionStep extends StatefulWidget {
  const _CropSelectionStep();

  @override
  State<_CropSelectionStep> createState() => _CropSelectionStepState();
}

class _CropSelectionStepState extends State<_CropSelectionStep> {
  String? _selected;
  final double _compassDeg = 12.0; // Mock compass

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CaptureController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        title: const Text('Select Crop Type'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => ctrl.retake(),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Container(
            color: AppTheme.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _StepDot(step: 1, isActive: false, label: 'Capture'),
                _StepLine(),
                _StepDot(step: 2, isActive: false, label: 'Preview'),
                _StepLine(),
                _StepDot(step: 3, isActive: true, label: 'Crop Type'),
              ],
            ),
          ),

          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.accentTeal.withValues(alpha: 0.08),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 16, color: AppTheme.accentTeal),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Select the crop in your captured image. This is required '
                    'for disease identification and field polygon matching.',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.accentTeal,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: CropTypes.all.length,
              itemBuilder: (context, i) {
                final crop = CropTypes.all[i];
                final isSelected = _selected == crop.id;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selected = crop.id);
                    ctrl.selectCrop(crop.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryGreen.withValues(alpha: 0.12)
                          : AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : AppTheme.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(crop.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          crop.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(Icons.check_circle_rounded,
                                size: 16, color: AppTheme.primaryGreen),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: AgriButton(
              label: _selected == null
                  ? 'Select a Crop Type'
                  : 'Analyse for Disease',
              fullWidth: true,
              size: AgriButtonSize.large,
              icon: Icons.biotech_rounded,
              onPressed: _selected == null
                  ? null
                  : () {
                      ctrl.confirmCrop(_compassDeg);
                      Navigator.pushReplacementNamed(context, '/disease',
                          arguments: {
                            'imagePath': ctrl.capturedImagePath,
                            'cropType': ctrl.selectedCropType,
                            'metadata': ctrl.buildMetadata(_compassDeg),
                          });
                    },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int step;
  final bool isActive;
  final String label;
  const _StepDot(
      {required this.step, required this.isActive, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white38,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? AppTheme.primaryGreen
                    : Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.white70)),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.only(bottom: 18),
        color: Colors.white30,
      ),
    );
  }
}

// ─── Done step ────────────────────────────────────────────────

class _DoneStep extends StatelessWidget {
  const _DoneStep();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                size: 80, color: AppTheme.successGreen),
            const SizedBox(height: 16),
            const Text('Image Captured!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            const Text(
              'Proceeding to disease analysis...',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppTheme.primaryGreen),
          ],
        ),
      ),
    );
  }
}
