import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/shell/main_shell.dart';
import 'screens/courses/courses_screen.dart';
import 'screens/courses/course_detail_screen.dart';
import 'screens/courses/course_player_screen.dart';
import 'screens/certificates/certificates_screen.dart';
import 'screens/certificates/certificate_detail_screen.dart';
import 'screens/assessments/assessments_hub_screen.dart';
import 'screens/skills/skills_badges_screen.dart';
import 'screens/attendance/attendance_screen.dart';
import 'screens/careers/careers_screen.dart';
import 'screens/vr/vr_learning_screen.dart';
import 'screens/notifications/notifications_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const CoLearnApp());
}

class CoLearnApp extends StatelessWidget {
  const CoLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoLearn — NCCT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // ─── Direct Routes ───────────────────────────────────────
      initialRoute: '/',
      routes: {
        '/': (_) => const CoLearnSplashScreen(),
        '/shell': (_) => const MainShell(),
        '/home': (_) => const MainShell(),
        '/courses': (_) => const CoursesScreen(),
        '/course/player': (_) => const CoursePlayerScreen(),
        '/certificates': (_) => const CertificatesScreen(),
        '/attendance': (_) => const AttendanceScreen(),
        '/careers': (_) => const CareersScreen(),
        '/vr': (_) => const VRLearningScreen(),
        '/vr/cardboard': (_) => const VRCardboardScreen(),
        '/notifications': (_) => const NotificationsScreen(),
        '/quiz': (_) => const AssessmentsHubScreen(),
        '/skills': (_) => const SkillsBadgesScreen(),
      },

      // ─── Dynamic Argument Routes ─────────────────────────────
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/course/detail':
            return MaterialPageRoute(
              builder: (_) => const CourseDetailScreen(),
              settings: settings,
            );
          case '/certificate/detail':
            return MaterialPageRoute(
              builder: (_) => const CertificateDetailScreen(),
              settings: settings,
            );
          case '/certificate/verify':
            return MaterialPageRoute(
              builder: (_) => const CertVerifyScreen(),
              settings: settings,
            );
          case '/course/player':
            return MaterialPageRoute(
              builder: (_) => const CoursePlayerScreen(),
              settings: settings,
            );
          case '/quiz':
            return MaterialPageRoute(
              builder: (_) => const AssessmentsHubScreen(),
              settings: settings,
            );
          case '/skills':
            return MaterialPageRoute(
              builder: (_) => const SkillsBadgesScreen(),
              settings: settings,
            );
          default:
            return null;
        }
      },
    );
  }
}

// ─── Certificate Verification Screen ────────────────────────────
class CertVerifyScreen extends StatefulWidget {
  const CertVerifyScreen({super.key});

  @override
  State<CertVerifyScreen> createState() => _CertVerifyScreenState();
}

class _CertVerifyScreenState extends State<CertVerifyScreen> {
  final TextEditingController _certController =
      TextEditingController(text: 'NCCT/VAMN/CERT/2024/0421');
  bool _verified = false;

  @override
  void dispose() {
    _certController.dispose();
    super.dispose();
  }

  void _performVerification() {
    setState(() => _verified = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        title: const Text(
          'Verify Certificate',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.pureBlack,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Column(
              children: [
                const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 14),
                const Text(
                  'Scan Physical QR Code',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Point your device camera at the cryptographic QR code printed on the official NCCT certificate.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.65),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Camera scanner ready. Hold over QR code.'),
                        backgroundColor: AppTheme.pureBlack,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
                  label: const Text(
                    'Open Camera Scanner',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Or verify by Certificate Number',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _certController,
            decoration: InputDecoration(
              hintText: 'e.g. NCCT/VAMN/CERT/2024/0421',
              prefixIcon: const Icon(Icons.verified_outlined),
              filled: true,
              fillColor: AppTheme.surfaceWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _performVerification,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pureBlack,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Verify Authenticity',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (_verified) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.successGreen, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Authentic Government Credential',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.successGreen,
                              ),
                            ),
                            Text(
                              'National Council for Cooperative Training (NCCT)',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: AppTheme.borderColor),
                  _buildVerifyRow('Recipient', 'Arjun Mehta'),
                  _buildVerifyRow('Roll Number', 'HDCM/PNE/2024/042'),
                  _buildVerifyRow('Programme', 'Cooperative Finance & Credit Management'),
                  _buildVerifyRow('Institute', 'VAMNICOM, Pune'),
                  _buildVerifyRow('Issued Date', '30 August 2024'),
                  _buildVerifyRow('Grade', 'Grade A (Distinction) — 85%'),
                  _buildVerifyRow('Security Hash', 'a94f3e6d8b0c1e7f92b4510... [Valid]'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
