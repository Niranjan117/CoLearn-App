import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/field_model.dart';
import '../../providers/map_controller.dart';
import '../../widgets/common/agri_app_bar.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_state_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  bool _showFieldPanel = false;
  bool _isThreeDimensional = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapController>().loadPolygons();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  // Build Google Maps polygons from field data
  Set<Polygon> _buildPolygons(List<FieldModel> fields) {
    return fields.where((field) => field.coordinates.length >= 3).map((field) {
      final points = field.coordinates
          .map((c) => LatLng(c.latitude, c.longitude))
          .toList();
      final fillColor = _fieldFillColor(field.status);
      final strokeColor = _fieldStrokeColor(field.status);

      return Polygon(
        polygonId: PolygonId(field.polygonId),
        points: points,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: 2,
        onTap: () => _onPolygonTapped(field),
      );
    }).toSet();
  }

  // Build map markers for field centers
  Set<Marker> _buildMarkers(List<FieldModel> fields) {
    return fields
        .where(
          (field) => field.centerLatitude != 0 || field.centerLongitude != 0,
        )
        .map((field) {
          return Marker(
            markerId: MarkerId('marker_${field.polygonId}'),
            position: LatLng(field.centerLatitude, field.centerLongitude),
            onTap: () => _onPolygonTapped(field),
            infoWindow: InfoWindow(
              title: field.fieldLabel,
              snippet:
                  '${field.cropType} • ${field.areHectares.toStringAsFixed(1)} ha',
            ),
          );
        })
        .toSet();
  }

  Color _fieldFillColor(FieldStatus status) {
    switch (status) {
      case FieldStatus.verified:
        return AppTheme.statusVerified.withValues(alpha: 0.25);
      case FieldStatus.pending:
        return AppTheme.statusPending.withValues(alpha: 0.25);
      case FieldStatus.unverified:
        return AppTheme.statusUnverified.withValues(alpha: 0.25);
    }
  }

  Color _fieldStrokeColor(FieldStatus status) {
    switch (status) {
      case FieldStatus.verified:
        return AppTheme.statusVerified;
      case FieldStatus.pending:
        return AppTheme.statusPending;
      case FieldStatus.unverified:
        return AppTheme.statusUnverified;
    }
  }

  void _onPolygonTapped(FieldModel field) {
    context.read<MapController>().selectField(field);
    setState(() => _showFieldPanel = true);
    _sheetController.animateTo(
      0.4,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(field.centerLatitude, field.centerLongitude),
          zoom: 15.5,
          tilt: _isThreeDimensional ? 55 : 0,
          bearing: _isThreeDimensional ? 25 : 0,
        ),
      ),
    );
  }

  void _closePanel() {
    context.read<MapController>().clearSelection();
    setState(() => _showFieldPanel = false);
  }

  void _fitFields(List<FieldModel> fields) {
    final points = fields
        .expand((field) => field.coordinates)
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    if (_mapController == null || points.isEmpty) return;

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;
    for (final point in points.skip(1)) {
      minLat = point.latitude < minLat ? point.latitude : minLat;
      maxLat = point.latitude > maxLat ? point.latitude : maxLat;
      minLng = point.longitude < minLng ? point.longitude : minLng;
      maxLng = point.longitude > maxLng ? point.longitude : maxLng;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        48,
      ),
    );
  }

  void _toggleThreeDimensional(List<FieldModel> fields) {
    setState(() => _isThreeDimensional = !_isThreeDimensional);
    if (_mapController == null || fields.isEmpty) return;
    final first = fields.first;
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(first.centerLatitude, first.centerLongitude),
          zoom: 16,
          tilt: _isThreeDimensional ? 55 : 0,
          bearing: _isThreeDimensional ? 25 : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapCtrl = context.watch<MapController>();
    final fields = mapCtrl.filteredFields;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AgriAppBar(
        title: 'Land Map',
        subtitle: '${fields.length} fields shown',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterSheet(context),
            tooltip: 'Filter fields',
          ),
          IconButton(
            icon: const Icon(Icons.layers_rounded),
            onPressed: () => _toggleThreeDimensional(fields),
            tooltip: 'Map layers',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _LegendRow(),
        ),
      ),
      body: mapCtrl.isLoading
          ? const InlineLoader(message: 'Loading field polygons...')
          : mapCtrl.error != null
          ? ErrorStateWidget(
              message: mapCtrl.error!,
              onRetry: () => mapCtrl.loadPolygons(),
              isNetwork: true,
            )
          : fields.isEmpty
          ? const ErrorStateWidget(
              message: 'No polygon geometry was returned by Supabase.',
              isNetwork: false,
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _fitFields(fields);
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      fields.first.centerLatitude,
                      fields.first.centerLongitude,
                    ),
                    zoom: 15,
                  ),
                  mapType: _isThreeDimensional
                      ? MapType.satellite
                      : MapType.normal,
                  buildingsEnabled: true,
                  polygons: _buildPolygons(fields),
                  markers: _buildMarkers(fields),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  onTap: (_) => _closePanel(),
                ),

                // ─── Field Detail Bottom Sheet ──────────────────────
                if (_showFieldPanel && mapCtrl.selectedField != null)
                  DraggableScrollableSheet(
                    controller: _sheetController,
                    initialChildSize: 0.4,
                    minChildSize: 0.15,
                    maxChildSize: 0.85,
                    snap: true,
                    snapSizes: const [0.15, 0.4, 0.85],
                    builder: (context, scrollController) {
                      return _FieldDetailPanel(
                        field: mapCtrl.selectedField!,
                        scrollController: scrollController,
                        onClose: _closePanel,
                      );
                    },
                  ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () =>
                _mapController?.animateCamera(CameraUpdate.zoomIn()),
            backgroundColor: AppTheme.surfaceWhite,
            foregroundColor: AppTheme.primaryGreen,
            child: const Icon(Icons.add_rounded),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () =>
                _mapController?.animateCamera(CameraUpdate.zoomOut()),
            backgroundColor: AppTheme.surfaceWhite,
            foregroundColor: AppTheme.primaryGreen,
            child: const Icon(Icons.remove_rounded),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'my_location',
            onPressed: () => _fitFields(fields),
            backgroundColor: AppTheme.primaryGreen,
            child: const Icon(Icons.my_location_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final mapCtrl = context.read<MapController>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _FilterSheet(
        currentStatus: mapCtrl.filterStatus,
        onStatusChanged: (s) {
          mapCtrl.setStatusFilter(s);
          Navigator.pop(ctx);
        },
        onClear: () {
          mapCtrl.clearFilters();
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

// ─── Field Detail Panel ────────────────────────────────────────
class _FieldDetailPanel extends StatelessWidget {
  final FieldModel field;
  final ScrollController scrollController;
  final VoidCallback onClose;

  const _FieldDetailPanel({
    required this.field,
    required this.scrollController,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(field.status);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.fieldLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              field.status.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            field.cropType,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: onClose,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
          const Divider(),
          // Scrollable content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Info grid
                _InfoGrid(field: field),
                const SizedBox(height: 16),

                // Confidence bar
                if (!field.groundTruthVerified) ...[
                  const Text(
                    'Polygon Match Confidence',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: field.confidenceScore,
                      minHeight: 8,
                      backgroundColor: AppTheme.surfaceGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(field.confidenceScore * 100).toStringAsFixed(1)}% confidence',
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // CTA Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outline_rounded, size: 16),
                        label: const Text('Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryGreen,
                          side: const BorderSide(color: AppTheme.primaryGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/verification');
                        },
                        icon: const Icon(Icons.verified_rounded, size: 16),
                        label: const Text('Verify Field'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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

  Color _statusColor(FieldStatus s) {
    switch (s) {
      case FieldStatus.verified:
        return AppTheme.statusVerified;
      case FieldStatus.pending:
        return AppTheme.statusPending;
      case FieldStatus.unverified:
        return AppTheme.statusUnverified;
    }
  }
}

class _InfoGrid extends StatelessWidget {
  final FieldModel field;
  const _InfoGrid({required this.field});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoItem(label: 'Polygon ID', value: field.polygonId),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoItem(
                label: 'Bhoomi / Land ID',
                value: field.bhoomiLandId,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _InfoItem(label: 'Owner', value: field.ownerName),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoItem(
                label: 'Area',
                value: '${field.areHectares.toStringAsFixed(2)} ha',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _InfoItem(
                label: 'Ground Truth',
                value: field.groundTruthVerified
                    ? '✓ Verified'
                    : '✗ Not Verified',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoItem(label: 'District', value: field.district),
            ),
          ],
        ),
        if (field.lastVerifiedAt != null) ...[
          const SizedBox(height: 10),
          _InfoItem(
            label: 'Last Verified',
            value: _formatDate(field.lastVerifiedAt!),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.textHint,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Legend Row ────────────────────────────────────────────────
class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primaryGreen,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          _LegendItem(color: AppTheme.statusVerified, label: 'Verified'),
          const SizedBox(width: 16),
          _LegendItem(color: AppTheme.statusPending, label: 'Pending'),
          const SizedBox(width: 16),
          _LegendItem(color: AppTheme.statusUnverified, label: 'Unverified'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}

// ─── Filter Sheet ──────────────────────────────────────────────
class _FilterSheet extends StatelessWidget {
  final FieldStatus? currentStatus;
  final ValueChanged<FieldStatus?> onStatusChanged;
  final VoidCallback onClear;

  const _FilterSheet({
    required this.currentStatus,
    required this.onStatusChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Fields',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const Text(
            'Verification Status',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ...FieldStatus.values.map((s) {
                final isSelected = currentStatus == s;
                return FilterChip(
                  label: Text(s.label),
                  selected: isSelected,
                  onSelected: (_) => onStatusChanged(isSelected ? null : s),
                  selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.15),
                  checkmarkColor: AppTheme.primaryGreen,
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onClear,
                  child: const Text('Clear All'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
