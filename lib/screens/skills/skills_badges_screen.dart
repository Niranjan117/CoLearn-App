import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/mock_data_service.dart';
import '../../models/ncct_models.dart';

/// CoLearn Skills & Badges Directory Screen
/// Demonstrates earned NCCT micro-credentials, competencies, and badges in progress
class SkillsBadgesScreen extends StatefulWidget {
  const SkillsBadgesScreen({super.key});

  @override
  State<SkillsBadgesScreen> createState() => _SkillsBadgesScreenState();
}

class _SkillsBadgesScreenState extends State<SkillsBadgesScreen> {
  String _selectedTier = 'All';

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;
    final allBadges = user.earnedBadges;
    final filtered = _selectedTier == 'All'
        ? allBadges
        : allBadges.where((b) => b.tier == _selectedTier).toList();

    final platinumCount = allBadges.where((b) => b.tier == 'Platinum').length;
    final goldCount = allBadges.where((b) => b.tier == 'Gold').length;
    final silverCount = allBadges.where((b) => b.tier == 'Silver').length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        title: const Text(
          'Skills & Badges',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // ── Summary Card ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.pureBlack,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verified Competencies',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${allBadges.length} NCCT Certified Badges',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildTierCounter('Platinum', platinumCount, Colors.white),
                    const SizedBox(width: 8),
                    _buildTierCounter('Gold', goldCount, const Color(0xFFFFD700)),
                    const SizedBox(width: 8),
                    _buildTierCounter('Silver', silverCount, const Color(0xFFC0C0C0)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Filter Chips ──────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Platinum', 'Gold', 'Silver'].map((tier) {
                final active = _selectedTier == tier;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTier = tier),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppTheme.pureBlack : AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? AppTheme.pureBlack : AppTheme.borderColor,
                      ),
                    ),
                    child: Text(
                      tier,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : AppTheme.textMuted,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // ── Earned Badges List ────────────────────────────────
          const Text(
            'Awarded Credentials',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...filtered.map((badge) => _buildBadgeDetailCard(badge)),

          const SizedBox(height: 24),

          // ── Badges In Progress ────────────────────────────────
          const Text(
            'Competencies in Progress',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildInProgressCard(
            title: 'PACS Digital Automation Leader',
            category: 'Technology',
            progress: 0.75,
            requirement: 'Complete Week 4 of ERP & digital transformation module',
          ),
          const SizedBox(height: 10),
          _buildInProgressCard(
            title: 'Cooperative Supply Chain Strategist',
            category: 'Operations',
            progress: 0.40,
            requirement: 'Pass Sugar Mill 360° VR inspection assessment',
          ),
        ],
      ),
    );
  }

  Widget _buildTierCounter(String label, int count, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeDetailCard(SkillBadge badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.pureBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(badge.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.greySubtle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge.tier.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      badge.category,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      badge.dateAwarded,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  badge.name,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'NCCT ID: CERT-BG-${badge.id.toUpperCase()}-2024',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: AppTheme.textMuted,
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

  Widget _buildInProgressCard({
    required String title,
    required String category,
    required double progress,
    required String requirement,
  }) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.greySubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.pureBlack),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            requirement,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
