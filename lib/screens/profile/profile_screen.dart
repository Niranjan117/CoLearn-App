import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/mock_data_service.dart';
import '../../models/ncct_models.dart';

class LearnersProfileScreen extends StatelessWidget {
  const LearnersProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // ── Profile hero header ──────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.pureBlack,
              padding: EdgeInsets.fromLTRB(
                  22, MediaQuery.of(context).padding.top + 14, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white.withValues(alpha: 0.25)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.edit_rounded,
                                  size: 12,
                                  color: Colors.white60),
                              const SizedBox(width: 5),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Avatar with initials
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.06),
                            ],
                          ),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user.initials,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              user.rollNumber,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11.5,
                                color: Colors.white.withValues(alpha: 0.5),
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.account_balance_outlined,
                                    color: Colors.white54, size: 12),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    user.currentInstitute,
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.65),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  // Stats row
                  Row(
                    children: [
                      _ProfileStat('${user.certificatesCount}', 'Certificates'),
                      _ProfileDivider(),
                      _ProfileStat(user.gpa, 'GPA'),
                      _ProfileDivider(),
                      _ProfileStat(user.academicRank, 'Rank'),
                      _ProfileDivider(),
                      _ProfileStat(
                          '${user.totalCreditsEarned}/${user.requiredCredits}',
                          'Credits'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ── Learning streak ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D0D0E), Color(0xFF27272A)],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🔥  14-day streak',
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Keep going — 7 more days for a badge!',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 11.5,
                                  color: Colors.white.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Mini streak dots
                          Row(
                            children: List.generate(7, (i) {
                              final active = i < 5;
                              return Container(
                                margin: const EdgeInsets.only(left: 4),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: active
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.2),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Progress ring section ──────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _InfoSection(
                      title: 'Programme Progress',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Progress circle
                              SizedBox(
                                width: 72,
                                height: 72,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: user.totalCreditsEarned /
                                          user.requiredCredits,
                                      backgroundColor: AppTheme.greySubtle,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              AppTheme.pureBlack),
                                      strokeWidth: 7,
                                    ),
                                    Text(
                                      '${((user.totalCreditsEarned / user.requiredCredits) * 100).round()}%',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.activeProgramme,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${user.enrolledBatch}  •  ${user.currentInstitute}',
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 11.5,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _MiniStat('${user.totalCreditsEarned}',
                                            'Credits Earned'),
                                        const SizedBox(width: 12),
                                        _MiniStat('${user.requiredCredits}',
                                            'Required'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skills & Badges
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _InfoSection(
                      title: 'Skills & Badges',
                      trailing: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/skills'),
                        child: const Text(
                          'View all',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.4,
                        children:
                            user.earnedBadges.map((b) => _BadgeTile(badge: b)).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick links
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _InfoSection(
                      title: 'Account',
                      child: Column(
                        children: [
                          _MenuTile(
                            icon: Icons.calendar_today_rounded,
                            label: 'Attendance Record',
                            value: '${user.attendanceRate.toStringAsFixed(1)}%',
                            onTap: () =>
                                Navigator.pushNamed(context, '/attendance'),
                          ),
                          _MenuTile(
                            icon: Icons.workspace_premium_rounded,
                            label: 'My Certificates',
                            value: '${user.certificatesCount} issued',
                            onTap: () =>
                                Navigator.pushNamed(context, '/certificates'),
                          ),
                          _MenuTile(
                            icon: Icons.work_outline_rounded,
                            label: 'Job Applications',
                            value: '${user.jobApplicationsCount} applied',
                            onTap: () =>
                                Navigator.pushNamed(context, '/careers'),
                          ),
                          _MenuTile(
                            icon: Icons.notifications_none_rounded,
                            label: 'Notifications',
                            onTap: () =>
                                Navigator.pushNamed(context, '/notifications'),
                          ),
                          _MenuTile(
                            icon: Icons.school_rounded,
                            label: 'NCCT Portal',
                            onTap: () {},
                          ),
                          _MenuTile(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            showDivider: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sign out
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.logout_rounded,
                                  size: 16, color: AppTheme.errorRed),
                              SizedBox(width: 8),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.errorRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

// ─── Supporting widgets ──────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            )),
        Text(label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 9.5,
              color: AppTheme.textMuted,
            )),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  const _ProfileStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 9.5,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 28,
        color: Colors.white.withValues(alpha: 0.15),
        margin: const EdgeInsets.symmetric(horizontal: 6),
      );
}

class _InfoSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _InfoSection({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              if (trailing != null) ...[const Spacer(), trailing!],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final SkillBadge badge;
  const _BadgeTile({required this.badge});

  Color get _tierColor {
    switch (badge.tier) {
      case 'Platinum':
        return const Color(0xFF94A3B8);
      case 'Gold':
        return const Color(0xFFD97706);
      case 'Silver':
        return const Color(0xFF71717A);
      default:
        return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.greySubtle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _tierColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(badge.icon, size: 18, color: _tierColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  badge.name,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  badge.tier,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: _tierColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool showDivider;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.value,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.greySubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppTheme.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (value != null) ...[
                  Text(
                    value!,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppTheme.greyLight),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppTheme.borderColor),
      ],
    );
  }
}
