import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/app_theme.dart';
import '../../models/mock_data_service.dart';
import '../../models/ncct_models.dart';

class VRLearningScreen extends StatefulWidget {
  const VRLearningScreen({super.key});

  @override
  State<VRLearningScreen> createState() => _VRLearningScreenState();
}

class _VRLearningScreenState extends State<VRLearningScreen> {
  @override
  Widget build(BuildContext context) {
    final demos = MockDataService.vrDemos;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.pureBlack,
            pinned: true,
            expandedHeight: 140,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.pureBlack,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.vrpano_rounded, size: 14, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text(
                                    '360° / VR',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'WebXR Ready',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Immersive Learning',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.6,
                          ),
                        ),
                        Text(
                          'Factory & cooperative facility virtual tours',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.5,
                            color: Colors.white.withValues(alpha: 0.55),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              '360° / VR Learning',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 17,
                letterSpacing: -0.2,
              ),
            ),
          ),

          // ── Cardboard / VR mode banner ──────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.pureBlack,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                child: _VREntryBanner(),
              ),
            ),
          ),

          // ── VR Demo List ────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _VRDemoCard(demo: demos[i]),
                childCount: demos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── VR Entry Mode Banner ─────────────────────────────────────
class _VREntryBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.view_in_ar_rounded, size: 32, color: AppTheme.pureBlack),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter VR / Cardboard Mode',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Compatible with Google Cardboard, Samsung Gear VR, and any WebXR browser. Hold your phone inside a headset to enter immersive mode.',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/vr/cardboard'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.pureBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.headset_rounded, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Enter VR',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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

// ─── VR Demo Card ─────────────────────────────────────────────
class _VRDemoCard extends StatelessWidget {
  final VRDemoModel demo;
  const _VRDemoCard({required this.demo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VRViewerScreen(demo: demo)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panorama Preview
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusMedium)),
              child: Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: AppTheme.greyDark,
                    child: Image.network(
                      demo.panoramaImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _PanoramaPlaceholder(),
                    ),
                  ),
                  // Overlay gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 360 icon
                  const Positioned(
                    top: 12,
                    right: 12,
                    child: _Badge360(),
                  ),
                  // Hotspot count
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${demo.hotspots.length} interactive hotspots',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Duration
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        demo.duration,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Play button
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12)],
                        ),
                        child: const Icon(Icons.play_circle_fill_rounded, size: 30, color: AppTheme.pureBlack),
                      ),
                    ),
                  ),
                ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.greySubtle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          demo.sector,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    demo.title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${demo.facilityName}  •  ${demo.location}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11.5,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    demo.description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.45,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  // Key machinery chips
                  if (demo.keyMachinery.isNotEmpty) ...[
                    const Text(
                      'Key Machinery',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: demo.keyMachinery.map((m) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.greySubtle,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m.name,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => VRViewerScreen(demo: demo)),
                          ),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.pureBlack,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.vrpano_rounded, size: 18, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Open 360° View',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/vr/cardboard', arguments: demo),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.headset_rounded, size: 16, color: AppTheme.textSecondary),
                                SizedBox(width: 6),
                                Text(
                                  'Cardboard',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}

// ─── 360° VR Viewer ───────────────────────────────────────────
class VRViewerScreen extends StatefulWidget {
  final VRDemoModel demo;
  const VRViewerScreen({super.key, required this.demo});

  @override
  State<VRViewerScreen> createState() => _VRViewerScreenState();
}

class _VRViewerScreenState extends State<VRViewerScreen>
    with SingleTickerProviderStateMixin {
  double _yaw = 0; // horizontal rotation in degrees
  double _panStart = 0;
  double _yawStart = 0;
  VRHotspot? _activeHotspot;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demo = widget.demo;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.pureBlack,
      body: Stack(
        children: [
          // ── Panoramic viewer (simulated with GestureDetector + paint) ──
          GestureDetector(
            onHorizontalDragStart: (d) {
              _panStart = d.localPosition.dx;
              _yawStart = _yaw;
            },
            onHorizontalDragUpdate: (d) {
              setState(() {
                _yaw = (_yawStart + (_panStart - d.localPosition.dx) * 0.35) % 360;
              });
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  // Background panorama image (parallax scroll simulation)
                  Positioned(
                    left: -(_yaw / 360 * size.width * 2),
                    top: 0,
                    right: -size.width * 2 + (_yaw / 360 * size.width * 2),
                    bottom: 0,
                    child: Image.network(
                      demo.panoramaImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.cardDark,
                        child: const Center(
                          child: Text(
                            '360° View',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Hotspot overlays
                  ...demo.hotspots.map((hotspot) {
                    // Calculate x position based on azimuth and current yaw
                    final hotspotX = _hotspotX(hotspot.azimuthDegrees, size.width);
                    final hotspotY = _hotspotY(hotspot.elevationDegrees, size.height);
                    return Positioned(
                      left: hotspotX - 18,
                      top: hotspotY - 18,
                      child: GestureDetector(
                        onTap: () => setState(
                          () => _activeHotspot = _activeHotspot == hotspot ? null : hotspot,
                        ),
                        child: AnimatedBuilder(
                          animation: _pulseCtrl,
                          builder: (_, __) => Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15 + 0.1 * _pulseCtrl.value),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.7),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.add_rounded, size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // ── Compass / yaw indicator ────────────────────────────
          Positioned(
            top: 48 + MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: _yaw * math.pi / 180,
                      child: const Icon(Icons.navigation_rounded, size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_yaw.round()}°',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Top bar ────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16, MediaQuery.of(context).padding.top + 10, 16, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.65), Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demo.title,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          demo.facilityName,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/vr/cardboard', arguments: demo),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.headset_rounded, size: 14, color: AppTheme.pureBlack),
                          SizedBox(width: 5),
                          Text(
                            'Cardboard',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.pureBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Hotspot detail card ────────────────────────────────
          if (_activeHotspot != null)
            Positioned(
              bottom: 32 + MediaQuery.of(context).padding.bottom,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _activeHotspot!.alertLevel,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _activeHotspot!.alertLevel == 'Optimal'
                                  ? AppTheme.successGreen
                                  : Colors.white70,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _activeHotspot = null),
                          child: const Icon(Icons.close_rounded, size: 18, color: Colors.white54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _activeHotspot!.title,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _activeHotspot!.description,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.analytics_outlined, size: 14, color: Colors.white70),
                          const SizedBox(width: 6),
                          Text(
                            _activeHotspot!.diagnosticMetric,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Drag hint ─────────────────────────────────────────
          if (_activeHotspot == null)
            Positioned(
              bottom: 32 + MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.swipe_rounded, size: 16, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(
                        'Swipe to look around  •  Tap  +  for details',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11.5,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _hotspotX(double azimuth, double width) {
    // Map azimuth to x position within the viewport based on current yaw
    double delta = ((azimuth - _yaw) + 360) % 360;
    if (delta > 180) delta -= 360;
    return (width / 2) + (delta / 60) * (width / 2);
  }

  double _hotspotY(double elevation, double height) {
    return (height / 2) - (elevation / 45) * (height * 0.25);
  }
}

// ─── Cardboard Mode Screen ────────────────────────────────────
class VRCardboardScreen extends StatefulWidget {
  const VRCardboardScreen({super.key});

  @override
  State<VRCardboardScreen> createState() => _VRCardboardScreenState();
}

class _VRCardboardScreenState extends State<VRCardboardScreen> {
  VRDemoModel? _demo;
  double _yaw = 0;
  double _panStart = 0;
  double _yawStart = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _demo = ModalRoute.of(context)?.settings.arguments as VRDemoModel?;
    _demo ??= MockDataService.vrDemos.first;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final halfWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragStart: (d) {
          _panStart = d.localPosition.dx;
          _yawStart = _yaw;
        },
        onHorizontalDragUpdate: (d) {
          setState(() {
            _yaw = (_yawStart + (_panStart - d.localPosition.dx) * 0.4) % 360;
          });
        },
        child: Stack(
          children: [
            // ── Left eye ───────────────────────────────────
            Positioned(
              left: 0,
              top: 0,
              width: halfWidth,
              height: size.height,
              child: _PanoramaEye(
                demo: _demo!,
                yaw: _yaw,
                pupilOffset: -0.03,
              ),
            ),
            // ── Centre divider ────────────────────────────
            Positioned(
              left: halfWidth - 1,
              top: 0,
              width: 2,
              height: size.height,
              child: Container(color: Colors.black),
            ),
            // ── Right eye ──────────────────────────────────
            Positioned(
              left: halfWidth + 1,
              top: 0,
              width: halfWidth - 1,
              height: size.height,
              child: _PanoramaEye(
                demo: _demo!,
                yaw: _yaw,
                pupilOffset: 0.03,
              ),
            ),
            // ── Back button ────────────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: AppTheme.pureBlack),
                      SizedBox(width: 4),
                      Text(
                        'Exit VR',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.pureBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Reticle ────────────────────────────────────
            Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white54, width: 1.5),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 3,
                    height: 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanoramaEye extends StatelessWidget {
  final VRDemoModel demo;
  final double yaw;
  final double pupilOffset;

  const _PanoramaEye({
    required this.demo,
    required this.yaw,
    required this.pupilOffset,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final eyeWidth = size.width / 2;
    final shift = -(yaw / 360 * eyeWidth * 3) + (pupilOffset * eyeWidth);

    return ClipRect(
      child: OverflowBox(
        maxWidth: eyeWidth * 4,
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(shift, 0),
          child: Image.network(
            demo.panoramaImageUrl,
            width: eyeWidth * 4,
            height: size.height,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppTheme.cardDark,
              width: eyeWidth * 4,
              height: size.height,
              child: const Center(
                child: Text(
                  'VR',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white10,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────
class _Badge360 extends StatelessWidget {
  const _Badge360();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.vrpano_rounded, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            '360°',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PanoramaPlaceholder extends StatelessWidget {
  const _PanoramaPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.cardDark,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.vrpano_rounded, size: 48, color: Colors.white24),
            SizedBox(height: 8),
            Text(
              '360° Environment',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                color: Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
