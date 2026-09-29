import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';

class CoLearnSplashScreen extends StatefulWidget {
  const CoLearnSplashScreen({super.key});

  @override
  State<CoLearnSplashScreen> createState() => _CoLearnSplashScreenState();
}

class _CoLearnSplashScreenState extends State<CoLearnSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.55, curve: Curves.easeOut)),
    );
    _scale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic)),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic)),
    );

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/shell');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureBlack,
      body: SafeArea(
        child: Column(
          children: [
            // ── Ministry badge ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
              child: FadeTransition(
                opacity: _fade,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'GOVERNMENT OF INDIA  •  MINISTRY OF COOPERATION',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.55),
                      letterSpacing: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ── Logo mark ──────────────────────────────────
            ScaleTransition(
              scale: _scale,
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  children: [
                    // Circular logo ring
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.5),
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'CoLearn',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NCCT',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.45),
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Tagline ────────────────────────────────────
            SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  children: [
                    Text(
                      'National Cooperative Learning Ecosystem',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.65),
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'National Council for Cooperative Training (NCCT)',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.35),
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ── Bottom loading bar ─────────────────────────
            FadeTransition(
              opacity: _fade,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 52),
                child: Column(
                  children: [
                    SizedBox(
                      width: 36,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        borderRadius: BorderRadius.circular(3),
                        minHeight: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Version 2.4.0',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
