import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/field_model.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/common/agri_app_bar.dart';
import '../../widgets/common/agri_card.dart';
import '../../widgets/common/empty_state_widget.dart';

class MyFieldsScreen extends StatefulWidget {
  const MyFieldsScreen({super.key});

  @override
  State<MyFieldsScreen> createState() => _MyFieldsScreenState();
}

class _MyFieldsScreenState extends State<MyFieldsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final List<String> _tabs = ['All', 'Verified', 'Pending', 'Unverified'];
  List<FieldModel> _allFields = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadFields();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFields() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _allFields = MockDataService.fields;
      _isLoading = false;
    });
  }

  List<FieldModel> _filterFields(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return _allFields.where((f) => f.status == FieldStatus.verified).toList();
      case 2:
        return _allFields.where((f) => f.status == FieldStatus.pending).toList();
      case 3:
        return _allFields.where((f) => f.status == FieldStatus.unverified).toList();
      default:
        return _allFields;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AgriAppBar(
        title: 'My Fields',
        subtitle: '${_allFields.length} registered fields',
        showBack: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: AppTheme.secondaryGold,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : TabBarView(
              controller: _tabController,
              children: List.generate(
                _tabs.length,
                (i) => _FieldList(
                  fields: _filterFields(i),
                  onRefresh: _loadFields,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/capture'),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
        label: const Text(
          'Capture & Verify',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _FieldList extends StatelessWidget {
  final List<FieldModel> fields;
  final Future<void> Function() onRefresh;

  const _FieldList({required this.fields, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (fields.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.landscape_rounded,
        title: 'No Fields Found',
        message: 'No fields in this category yet.\nCapture an image to register a field.',
        actionLabel: 'Capture Image',
        onAction: () => Navigator.pushNamed(context, '/capture'),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primaryGreen,
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: fields.length,
        separatorBuilder: (context, idx) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _FieldCard(field: fields[i]),
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  final FieldModel field;

  const _FieldCard({required this.field});

  Color get _statusColor {
    switch (field.status) {
      case FieldStatus.verified:
        return AppTheme.statusVerified;
      case FieldStatus.pending:
        return AppTheme.statusPending;
      case FieldStatus.unverified:
        return AppTheme.statusUnverified;
    }
  }

  IconData get _cropIcon {
    switch (field.cropType.toLowerCase()) {
      case 'rice':
        return Icons.grass_rounded;
      case 'cotton':
        return Icons.local_florist_rounded;
      case 'wheat':
        return Icons.grain_rounded;
      case 'maize':
      case 'corn':
        return Icons.spa_rounded;
      case 'sugarcane':
        return Icons.park_rounded;
      default:
        return Icons.eco_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: EdgeInsets.zero,
      onTap: () => Navigator.pushNamed(context, '/fields/detail',
          arguments: field),
      child: Column(
        children: [
          // Map thumbnail bar (colored by status)
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_cropIcon, color: _statusColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            field.fieldLabel,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${field.cropType} • ${field.areHectares.toStringAsFixed(2)} ha',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        field.status.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 0),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _FieldMeta(
                        icon: Icons.fingerprint_rounded,
                        label: field.polygonId),
                    const Spacer(),
                    _FieldMeta(
                        icon: Icons.location_on_rounded,
                        label: field.district),
                    const Spacer(),
                    if (field.groundTruthVerified)
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded,
                              size: 14, color: AppTheme.successGreen),
                          SizedBox(width: 3),
                          Text(
                            'Ground Truth',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.successGreen,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    else
                      Text(
                        '${(field.confidenceScore * 100).toStringAsFixed(0)}% match',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
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

class _FieldMeta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FieldMeta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.textHint),
        const SizedBox(width: 4),
        Text(
          label.length > 16 ? '${label.substring(0, 14)}…' : label,
          style:
              const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
