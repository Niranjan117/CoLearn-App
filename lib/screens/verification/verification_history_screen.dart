import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/verification_model.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/common/agri_app_bar.dart';
import '../../widgets/common/agri_card.dart';
import '../../widgets/common/empty_state_widget.dart';

class VerificationHistoryScreen extends StatefulWidget {
  const VerificationHistoryScreen({super.key});

  @override
  State<VerificationHistoryScreen> createState() =>
      _VerificationHistoryScreenState();
}

class _VerificationHistoryScreenState
    extends State<VerificationHistoryScreen> {
  bool _isLoading = false;
  List<VerificationRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _records = MockDataService.verificationHistory;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: const AgriAppBar(
        title: 'Verification History',
        subtitle: 'All polygon matching attempts',
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : _records.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.history_rounded,
                  title: 'No History Yet',
                  message:
                      'Your field verification history will appear here after you capture your first image.',
                )
              : RefreshIndicator(
                  color: AppTheme.primaryGreen,
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: _records.length,
                    separatorBuilder: (context, idx) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _VerificationCard(record: _records[i]),
                  ),
                ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final VerificationRecord record;

  const _VerificationCard({required this.record});

  Color get _statusColor {
    switch (record.status) {
      case VerificationStatus.matched:
        return AppTheme.successGreen;
      case VerificationStatus.pending:
        return AppTheme.warningAmber;
      case VerificationStatus.failed:
        return AppTheme.errorRed;
      case VerificationStatus.reviewing:
        return AppTheme.infoBlue;
    }
  }

  IconData get _statusIcon {
    switch (record.status) {
      case VerificationStatus.matched:
        return Icons.check_circle_rounded;
      case VerificationStatus.pending:
        return Icons.pending_rounded;
      case VerificationStatus.failed:
        return Icons.cancel_rounded;
      case VerificationStatus.reviewing:
        return Icons.rate_review_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Status header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              children: [
                Icon(_statusIcon, size: 16, color: _statusColor),
                const SizedBox(width: 8),
                Text(
                  record.status.label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _statusColor),
                ),
                const Spacer(),
                Text(
                  _formatDate(record.createdAt),
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textHint),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Crop and field
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        record.metadata.inputCropType,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (record.matchedField != null)
                      Expanded(
                        child: Text(
                          record.matchedField!.fieldLabel,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Metadata summary
                Row(
                  children: [
                    _MetaBadge(
                      icon: Icons.gps_fixed_rounded,
                      value:
                          '${record.metadata.userLat.toStringAsFixed(3)}, ${record.metadata.userLng.toStringAsFixed(3)}',
                    ),
                    const SizedBox(width: 8),
                    _MetaBadge(
                      icon: Icons.explore_rounded,
                      value: '${record.metadata.compassDeg.toStringAsFixed(0)}°',
                    ),
                    const SizedBox(width: 8),
                    _MetaBadge(
                      icon: Icons.signal_cellular_alt_rounded,
                      value: '${record.metadata.gpsScore.toStringAsFixed(1)}m',
                    ),
                  ],
                ),

                if (record.hasMatch && record.matchConfidence != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: record.matchConfidence,
                            minHeight: 5,
                            backgroundColor: AppTheme.surfaceGrey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                _statusColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${((record.matchConfidence ?? 0) * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _statusColor),
                      ),
                    ],
                  ),
                ],

                if (record.notes != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    record.notes!,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textHint,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  const _MetaBadge({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppTheme.textHint),
        const SizedBox(width: 3),
        Text(value,
            style:
                const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}
