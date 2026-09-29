import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/capture_metadata_model.dart';
import '../../models/disease_result_model.dart';
import '../../providers/disease_controller.dart';
import '../../services/camera_service.dart';
import '../../widgets/common/agri_app_bar.dart';
import '../../widgets/common/agri_button.dart';
import '../../widgets/common/agri_card.dart';
import '../../widgets/disease/confidence_bar.dart';

class DiseaseScreen extends StatelessWidget {
  const DiseaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final ctrl = DiseaseController();
        // If navigated from capture screen with arguments
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          ctrl.setImage(
            args['imagePath'] as String? ?? '',
            cropType: args['cropType'] as String?,
          );
          final metadata = args['metadata'] as CaptureMetadata?;
          if (metadata != null) ctrl.setMetadata(metadata);
        }
        return ctrl;
      },
      child: const _DiseaseFlow(),
    );
  }
}

class _DiseaseFlow extends StatelessWidget {
  const _DiseaseFlow();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DiseaseController>();

    switch (ctrl.step) {
      case DiseaseFlowStep.upload:
        return const _UploadState();
      case DiseaseFlowStep.analyzing:
        return const _AnalyzingState();
      case DiseaseFlowStep.result:
        return const _ResultState();
      case DiseaseFlowStep.metadataReview:
        return const _MetadataReviewState();
      case DiseaseFlowStep.assigning:
        return const _AssigningState();
      case DiseaseFlowStep.verificationComplete:
        return const _VerificationCompleteState();
    }
  }
}

// ─── State A: Upload ──────────────────────────────────────────

class _UploadState extends StatelessWidget {
  const _UploadState();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DiseaseController>();
    final hasImage = ctrl.imagePath != null && ctrl.imagePath!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: const AgriAppBar(
        title: 'Disease Identification',
        subtitle: 'AI-powered plant disease detection',
        showBack: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // INTEGRATION POINT (Phase 2)
            // Replace mock analysis with real ML model call via disease_service.dart
            // ============================================================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentTeal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.accentTeal.withValues(alpha: 0.25)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.biotech_rounded,
                      color: AppTheme.accentTeal, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Capture a clear image of the plant leaves or stems. '
                      'The AI model will identify diseases with confidence scores.',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.accentTeal,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Image preview / picker
            GestureDetector(
              onTap: () async {
                final result =
                    await CameraService.instance.pickFromGallery();
                if (result.isSuccess && result.imagePath != null) {
                  ctrl.setImage(result.imagePath!);
                }
              },
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceGrey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hasImage
                        ? AppTheme.primaryGreen
                        : AppTheme.borderColor,
                    width: hasImage ? 2 : 1,
                  ),
                ),
                child: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(ctrl.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_rounded,
                              size: 52, color: AppTheme.textHint),
                          SizedBox(height: 12),
                          Text(
                            'Tap to select plant image',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'or use the Capture tab to take a photo',
                            style: TextStyle(
                                fontSize: 12, color: AppTheme.textHint),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Crop type selector if not set
            if (!hasImage || ctrl.selectedCropType == null) ...[
              const Text('Crop Type',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CropTypes.all.take(6).map((crop) {
                  final selected = ctrl.selectedCropType == crop.id;
                  return FilterChip(
                    label: Text('${crop.emoji} ${crop.label}'),
                    selected: selected,
                    onSelected: (_) => ctrl.setCropType(crop.id),
                    selectedColor:
                        AppTheme.primaryGreen.withValues(alpha: 0.15),
                    checkmarkColor: AppTheme.primaryGreen,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Tips
            const _GoodPhotoTips(),

            const SizedBox(height: 24),

            // Analyze button
            AgriButton(
              label: 'Identify Disease',
              fullWidth: true,
              size: AgriButtonSize.large,
              icon: Icons.search_rounded,
              onPressed: (!hasImage || ctrl.selectedCropType == null)
                  ? null
                  : () => ctrl.analyzeDisease(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoodPhotoTips extends StatelessWidget {
  const _GoodPhotoTips();

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tips for Better Results',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          ...[
            '📸 Capture in good natural lighting',
            '🔍 Focus on the affected leaf or stem area',
            '📐 Keep camera steady and close (20–40 cm)',
            '🌿 Include both healthy and diseased parts',
          ].map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(tip,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4)),
              )),
        ],
      ),
    );
  }
}

// ─── State B: Analyzing ───────────────────────────────────────

class _AnalyzingState extends StatelessWidget {
  const _AnalyzingState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: const AgriAppBar(
          title: 'Analysing Image', showBack: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated analysis illustration
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryGreen,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Analysing Plant Image',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Our AI model is examining your image for diseases, '
                'nutrient deficiencies, and plant health indicators.',
                style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Progress steps
              ...[
                ('Preprocessing image', true),
                ('Running disease classification', true),
                ('Generating health report', false),
              ].map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        item.$2
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 18,
                        color: item.$2
                            ? AppTheme.primaryGreen
                            : AppTheme.textHint,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.$1,
                        style: TextStyle(
                          fontSize: 13,
                          color: item.$2
                              ? AppTheme.textPrimary
                              : AppTheme.textHint,
                          fontWeight: item.$2
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '// INTEGRATION POINT: Real ML model will be connected in Phase 2',
                style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.textHint,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── State C: Result ──────────────────────────────────────────

class _ResultState extends StatelessWidget {
  const _ResultState();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DiseaseController>();
    final result = ctrl.result;

    if (result == null) return const _UploadState();

    final isHealthy = result.isHealthy;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AgriAppBar(
        title: 'Disease Report',
        subtitle: result.cropType,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Result hero card
            AgriCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isHealthy
                              ? AppTheme.successGreen.withValues(alpha: 0.12)
                              : AppTheme.errorRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isHealthy
                              ? Icons.eco_rounded
                              : Icons.coronavirus_rounded,
                          color: isHealthy
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.diseaseName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary),
                            ),
                            if (!isHealthy)
                              Text(
                                result.scientificName,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                      ),
                      SeverityBadge(severity: result.severity),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ConfidenceBar(
                    value: result.confidenceScore,
                    label: 'Detection Confidence',
                  ),
                  if (!isHealthy) ...[
                    const SizedBox(height: 12),
                    _ProgressRow(
                      label: 'Affected Area',
                      value: result.affectedAreaPercent / 100,
                      valueLabel:
                          '${result.affectedAreaPercent.toStringAsFixed(0)}%',
                      color: AppTheme.warningAmber,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            AgriCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About this condition',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  const SizedBox(height: 8),
                  Text(result.description,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.6)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Treatment recommendations
            if (result.treatments.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Treatment Recommendations',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
              ),
              const SizedBox(height: 10),
              ...result.treatments.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _TreatmentCard(treatment: t),
                  )),
              const SizedBox(height: 8),
            ],

            // Zero Data Waste CTA
            _ZeroDataWasteCard(onProceed: () {
              final metadata = ctrl.captureMetadata ??
                  CaptureMetadata(
                    userLat: 15.4589,
                    userLng: 75.0078,
                    gpsScore: 8.5,
                    compassDeg: 12.0,
                    inputCropType: result.cropType,
                    capturedAt: DateTime.now(),
                  );
              ctrl.proceedToMetadata(metadata);
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final String valueLabel;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.valueLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
            Text(valueLabel,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppTheme.surfaceGrey,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final TreatmentRecommendation treatment;

  const _TreatmentCard({required this.treatment});

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      border: treatment.isUrgent
          ? Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3))
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: treatment.isUrgent
                  ? AppTheme.errorRed.withValues(alpha: 0.10)
                  : AppTheme.primaryGreen.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.healing_rounded,
              size: 20,
              color: treatment.isUrgent
                  ? AppTheme.errorRed
                  : AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(treatment.title,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary)),
                    ),
                    if (treatment.isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Urgent',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.errorRed,
                                fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(treatment.description,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZeroDataWasteCard extends StatelessWidget {
  final VoidCallback onProceed;

  const _ZeroDataWasteCard({required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen.withValues(alpha: 0.05),
            AppTheme.accentTeal.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.recycling_rounded,
                  color: AppTheme.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Zero Data Waste 🌱',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'The GPS location and compass data from your image capture can '
            'identify your corresponding agricultural field polygon — '
            'without any extra effort on your part.',
            style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.5),
          ),
          const SizedBox(height: 12),
          AgriButton(
            label: 'Identify My Field Polygon',
            fullWidth: true,
            icon: Icons.my_location_rounded,
            variant: AgriButtonVariant.outline,
            onPressed: onProceed,
          ),
        ],
      ),
    );
  }
}

// ─── State D: Metadata Review ─────────────────────────────────

class _MetadataReviewState extends StatelessWidget {
  const _MetadataReviewState();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DiseaseController>();
    final meta = ctrl.captureMetadata;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AgriAppBar(
        title: 'Field Identification',
        subtitle: 'Review capture metadata',
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => ctrl.goBackToResult(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AgriCard(
              backgroundColor:
                  AppTheme.primaryGreen.withValues(alpha: 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.send_rounded,
                          color: AppTheme.primaryGreen, size: 18),
                      SizedBox(width: 8),
                      Text('API Payload Preview',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // ============================================================
                    // INTEGRATION POINT (Phase 2)
                    // POST ${AppConfig.polygonAssignEndpoint}
                    // ============================================================
                    'POST /detect_and_assign_polygon',
                    style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metadata fields
            if (meta != null) ...[
              _MetaField(
                  label: 'user_lat',
                  value: meta.userLat.toStringAsFixed(6),
                  icon: Icons.gps_fixed_rounded,
                  color: AppTheme.successGreen),
              const SizedBox(height: 10),
              _MetaField(
                  label: 'user_lng',
                  value: meta.userLng.toStringAsFixed(6),
                  icon: Icons.gps_fixed_rounded,
                  color: AppTheme.successGreen),
              const SizedBox(height: 10),
              _MetaField(
                  label: 'gps_score',
                  value:
                      '${meta.gpsScore.toStringAsFixed(1)}m (${meta.gpsAccuracyLabel})',
                  icon: Icons.signal_cellular_alt_rounded,
                  color: AppTheme.infoBlue),
              const SizedBox(height: 10),
              _MetaField(
                  label: 'compass_deg',
                  value: '${meta.compassDeg.toStringAsFixed(1)}° ${meta.compassDirection}',
                  icon: Icons.explore_rounded,
                  color: AppTheme.secondaryGold),
              const SizedBox(height: 10),
              _MetaField(
                  label: 'input_crop_type',
                  value: meta.inputCropType,
                  icon: Icons.eco_rounded,
                  color: AppTheme.primaryGreen),
            ] else
              const Text('No metadata captured. Please use Capture tab.',
                  style: TextStyle(color: AppTheme.textSecondary)),

            const SizedBox(height: 24),

            // Workflow explanation
            _WorkflowCard(),
            const SizedBox(height: 24),

            // Submit button
            AgriButton(
              label: 'Identify My Field',
              fullWidth: true,
              size: AgriButtonSize.large,
              icon: Icons.my_location_rounded,
              isLoading: ctrl.isLoading,
              onPressed: () => ctrl.assignPolygon(),
            ),
            const SizedBox(height: 12),
            AgriButton(
              label: 'Skip for Now',
              fullWidth: true,
              variant: AgriButtonVariant.ghost,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetaField({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textHint,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, size: 16, color: color),
        ],
      ),
    );
  }
}

class _WorkflowCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgriCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How Field Identification Works',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          _WorkflowStep(
              step: '1', label: 'Your GPS + compass is captured at image time'),
          _WorkflowStep(
              step: '2', label: 'Data is sent to the polygon-assignment API'),
          _WorkflowStep(
              step: '3',
              label: 'Supabase identifies the best matching field polygon'),
          _WorkflowStep(
              step: '4', label: 'Your field record is updated automatically'),
        ],
      ),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final String step;
  final String label;
  const _WorkflowStep({required this.step, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(step,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ─── State E: Assigning ───────────────────────────────────────

class _AssigningState extends StatelessWidget {
  const _AssigningState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: const AgriAppBar(title: 'Finding Your Field', showBack: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                      color: AppTheme.accentTeal, strokeWidth: 3),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Matching to Field Polygon',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
              const SizedBox(height: 12),
              const Text(
                'Sending GPS, compass, and crop type data to the '
                'polygon assignment service...',
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── State F: Verification Complete ──────────────────────────

class _VerificationCompleteState extends StatelessWidget {
  const _VerificationCompleteState();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DiseaseController>();
    final record = ctrl.verificationRecord;
    final matched = record?.hasMatch ?? false;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: const AgriAppBar(title: 'Field Identified', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Result icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: matched
                    ? AppTheme.successGreen.withValues(alpha: 0.12)
                    : AppTheme.errorRed.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                matched
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 52,
                color: matched ? AppTheme.successGreen : AppTheme.errorRed,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              matched ? 'Field Identified!' : 'No Match Found',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            if (matched && record?.matchedField != null) ...[
              Text(
                record!.matchedField!.fieldLabel,
                style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Matched field details
              AgriCard(
                child: Column(
                  children: [
                    _ResultRow(
                        label: 'Polygon ID',
                        value: record.matchedField!.polygonId),
                    _ResultRow(
                        label: 'Bhoomi / Land ID',
                        value: record.matchedField!.bhoomiLandId),
                    _ResultRow(
                        label: 'Crop Type',
                        value: record.matchedField!.cropType),
                    _ResultRow(
                        label: 'Owner',
                        value: record.matchedField!.ownerName),
                    _ResultRow(
                      label: 'Match Confidence',
                      value:
                          '${((record.matchConfidence ?? 0) * 100).toStringAsFixed(1)}%',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Verification timeline
              _VerificationTimeline(),
              const SizedBox(height: 24),

              // Actions
              AgriButton(
                label: 'View on Map',
                fullWidth: true,
                icon: Icons.map_rounded,
                onPressed: () => Navigator.pushNamed(context, '/map'),
              ),
              const SizedBox(height: 10),
              AgriButton(
                label: 'View History',
                fullWidth: true,
                variant: AgriButtonVariant.outline,
                icon: Icons.history_rounded,
                onPressed: () =>
                    Navigator.pushNamed(context, '/verification/history'),
              ),
            ] else ...[
              const SizedBox(height: 16),
              const Text(
                'No agricultural field polygon was found matching your current location. '
                'Please ensure GPS is enabled and try again from your field.',
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AgriButton(
                label: 'Try Again',
                fullWidth: true,
                icon: Icons.refresh_rounded,
                onPressed: () => ctrl.reset(),
              ),
            ],
            const SizedBox(height: 12),
            AgriButton(
              label: 'Done',
              fullWidth: true,
              variant: AgriButtonVariant.ghost,
              onPressed: () {
                ctrl.reset();
                Navigator.popUntil(context, ModalRoute.withName('/shell'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textSecondary)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _VerificationTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgriCard(
      backgroundColor: AppTheme.surfaceGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Verification Steps',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          _TimelineItem(
              step: 'Image Captured',
              detail: 'GPS & compass metadata collected',
              isComplete: true),
          _TimelineItem(
              step: 'Metadata Submitted',
              detail: 'POST /detect_and_assign_polygon',
              isComplete: true),
          _TimelineItem(
              step: 'Polygon Matched',
              detail: 'Field identified with confidence',
              isComplete: true),
          _TimelineItem(
              step: 'Record Updated',
              detail: 'Verification saved to Supabase',
              isComplete: false,
              isLast: true),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String step;
  final String detail;
  final bool isComplete;
  final bool isLast;

  const _TimelineItem({
    required this.step,
    required this.detail,
    required this.isComplete,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete
                    ? AppTheme.primaryGreen
                    : AppTheme.borderColor,
              ),
              child: Icon(
                isComplete ? Icons.check_rounded : Icons.circle_outlined,
                size: 12,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                  width: 2,
                  height: 28,
                  color: isComplete
                      ? AppTheme.primaryGreen.withValues(alpha: 0.3)
                      : AppTheme.borderColor),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isComplete
                            ? AppTheme.textPrimary
                            : AppTheme.textHint)),
                Text(detail,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textHint)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
