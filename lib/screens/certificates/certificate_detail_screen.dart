import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/mock_data_service.dart';
import '../../models/ncct_models.dart';

/// CoLearn Digital Certificate Viewer Screen
/// Official Government of India / NCCT credential format with digital verification
class CertificateDetailScreen extends StatefulWidget {
  final CertificateModel? certificate;

  const CertificateDetailScreen({super.key, this.certificate});

  @override
  State<CertificateDetailScreen> createState() => _CertificateDetailScreenState();
}

class _CertificateDetailScreenState extends State<CertificateDetailScreen> {
  late CertificateModel _cert;
  bool _isDownloading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.certificate != null) {
      _cert = widget.certificate!;
    } else {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CertificateModel) {
        _cert = args;
      } else {
        _cert = MockDataService.certificates.first;
      }
    }
  }

  void _downloadCertificate() {
    setState(() => _isDownloading = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.download_done_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Saved ${_cert.certificateNumber.replaceAll('/', '_')}.pdf to Downloads',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.pureBlack,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _shareCertificate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Share Credential',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Share official verification link or download copy',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.5,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.link_rounded, color: AppTheme.pureBlack),
              title: const Text('Copy Verification URL', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600)),
              subtitle: Text('https://ncct.gov.in/verify?id=${_cert.certificateNumber}', style: const TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification URL copied to clipboard'),
                    backgroundColor: AppTheme.pureBlack,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined, color: AppTheme.pureBlack),
              title: const Text('Add to LinkedIn Profile', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600)),
              subtitle: const Text('Add certified credential to licenses & certifications', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Credential details prepared for LinkedIn export'),
                    backgroundColor: AppTheme.pureBlack,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        title: const Text(
          'Official Credential',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20),
            onPressed: _shareCertificate,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          children: [
            // ── Verified Authenticity Banner ─────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.pureBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Digitally verified by NCCT & Ministry of Cooperation',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/certificate/verify'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Certificate Parchment Container ──────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Dual border inner frame
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.pureBlack, width: 1.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        // Government Emblem & Title Header
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.pureBlack, width: 1.5),
                          ),
                          child: const Center(
                            child: Icon(Icons.account_balance_rounded, size: 24, color: AppTheme.pureBlack),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'NATIONAL COUNCIL FOR COOPERATIVE TRAINING',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'MINISTRY OF COOPERATION • GOVERNMENT OF INDIA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMuted,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: 120,
                          height: 1,
                          color: AppTheme.pureBlack.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),

                        // Certificate Type
                        const Text(
                          'CERTIFICATE OF COMPLETION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Certification Text
                        Text(
                          'This is to certify that',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Recipient Name
                        Text(
                          _cert.recipientName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.pureBlack,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Roll No: ${_cert.rollNumber}',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Body text
                        Text(
                          'has successfully completed the prescribed curriculum, practical assignments, and formal assessment for',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.5,
                            color: AppTheme.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Course Title
                        Text(
                          _cert.courseTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _cert.courseCode,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10.5,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Institute & Grade
                        Text(
                          'Conducted by ${_cert.institute}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Performance: ${_cert.grade}',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Signatures & QR Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // DG NCCT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 32,
                                    alignment: Alignment.bottomLeft,
                                    child: const Text(
                                      'S.K. Sharma',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 8, color: AppTheme.pureBlack),
                                  Text(
                                    _cert.directorGeneral,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 9,
                                      color: AppTheme.textMuted,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // QR Code Simulation
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.pureBlack, width: 1.5),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Icon(Icons.qr_code_2_rounded, size: 48, color: AppTheme.pureBlack),
                                ),
                              ),
                            ),
                            // Institute Director
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 32,
                                    alignment: Alignment.bottomRight,
                                    child: const Text(
                                      'Ramesh K.',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 8, color: AppTheme.pureBlack),
                                  Text(
                                    _cert.instituteDirector,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 9,
                                      color: AppTheme.textMuted,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Security hash footer
                        Text(
                          'Credential ID: ${_cert.certificateNumber}  •  Hash: ${_cert.digitalHash}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 8.5,
                            color: AppTheme.textHint,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Associated Skills Certified ──────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Certified Competencies',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _cert.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceMuted,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded, size: 13, color: AppTheme.textPrimary),
                            const SizedBox(width: 5),
                            Text(
                              skill,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Action Buttons ───────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isDownloading ? null : _downloadCertificate,
                icon: _isDownloading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.download_rounded, size: 20),
                label: Text(
                  _isDownloading ? 'Generating High-Res PDF...' : 'Download Official PDF',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.pureBlack,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/certificate/verify'),
                icon: const Icon(Icons.verified_outlined, size: 18),
                label: const Text(
                  'Verify on NCCT National Portal',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.pureBlack,
                  side: const BorderSide(color: AppTheme.pureBlack, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
