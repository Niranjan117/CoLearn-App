import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/app_theme.dart';
import '../../models/mock_data_service.dart';
import '../../models/ncct_models.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Diploma', 'PG Diploma', 'Certificate', 'Enrolled'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<CourseModel> get _filteredCourses {
    final all = MockDataService.courses;
    if (_selectedCategory == 'All') return all;
    if (_selectedCategory == 'Enrolled') return all.where((c) => c.isEnrolled).toList();
    return all.where((c) => c.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            backgroundColor: AppTheme.surfaceWhite,
            elevation: 0,
            pinned: true,
            automaticallyImplyLeading: false,
            title: const Text(
              'Programmes',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                height: 48,
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  labelStyle: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: AppTheme.pureBlack,
                  unselectedLabelColor: AppTheme.textMuted,
                  indicatorColor: AppTheme.pureBlack,
                  indicatorWeight: 2,
                  tabs: const [
                    Tab(text: 'Discover'),
                    Tab(text: 'My Enrolments'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _DiscoverTab(
              categories: _categories,
              selectedCategory: _selectedCategory,
              courses: _filteredCourses,
              onCategoryChanged: (c) => setState(() => _selectedCategory = c),
            ),
            _EnrolmentsTab(courses: MockDataService.courses.where((c) => c.isEnrolled).toList()),
          ],
        ),
      ),
    );
  }
}

// ─── Discover Tab ──────────────────────────────────────────────
class _DiscoverTab extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final List<CourseModel> courses;
  final ValueChanged<String> onCategoryChanged;

  const _DiscoverTab({
    required this.categories,
    required this.selectedCategory,
    required this.courses,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Category chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final active = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () => onCategoryChanged(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? AppTheme.pureBlack : AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? AppTheme.pureBlack : AppTheme.borderColor,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : AppTheme.textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // Course cards
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _CourseBrowserCard(course: courses[i]),
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Enrolments Tab ────────────────────────────────────────────
class _EnrolmentsTab extends StatelessWidget {
  final List<CourseModel> courses;
  const _EnrolmentsTab({required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: courses.length,
      itemBuilder: (ctx, i) => _EnrolmentProgressCard(course: courses[i]),
    );
  }
}

// ─── Course Browser Card ───────────────────────────────────────
class _CourseBrowserCard extends StatelessWidget {
  final CourseModel course;
  const _CourseBrowserCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/course/detail', arguments: course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: course.featured ? AppTheme.pureBlack.withValues(alpha: 0.25) : AppTheme.borderColor,
            width: course.featured ? 1.2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Banner Image with Badges ─────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusMedium)),
              child: Stack(
                children: [
                  if (course.bannerImageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: course.bannerImageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 140,
                        color: AppTheme.greyDark,
                        child: const Center(
                          child: Icon(Icons.school_outlined, color: Colors.white24, size: 36),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 140,
                        color: AppTheme.greyDark,
                        child: const Center(
                          child: Icon(Icons.school_outlined, color: Colors.white24, size: 36),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 140,
                      color: AppTheme.pureBlack,
                      child: const Center(
                        child: Icon(Icons.school_outlined, color: Colors.white30, size: 40),
                      ),
                    ),
                  // Dark gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.75),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Top Tags
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            course.category.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (course.featured) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.pureBlack,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '★ FEATURED',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${course.credits} CREDITS',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.pureBlack,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom course code on image
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        course.code,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Card Details ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.account_balance_outlined, size: 13, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          course.institute,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.5,
                            color: AppTheme.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: AppTheme.textPrimary),
                      const SizedBox(width: 3),
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${course.enrolledLearners.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} learners',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11.5,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/course/detail', arguments: course),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.pureBlack,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                course.isEnrolled ? 'View Programme' : 'Enrol Now (Sponsored)',
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
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

// ─── Enrolment Progress Card ───────────────────────────────────
class _EnrolmentProgressCard extends StatelessWidget {
  final CourseModel course;
  const _EnrolmentProgressCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner preview
          if (course.bannerImageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusMedium)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: course.bannerImageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course.shortCode,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          course.enrolledBatch ?? '',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
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
                Text(
                  course.title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  course.institute,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11.5,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                // Module progress tiles
                Column(
                  children: course.modules
                      .take(4)
                      .map((m) => _ModuleProgressRow(module: m))
                      .toList(),
                ),
                const SizedBox(height: 12),
                // Overall progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Curriculum Progress',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '${(course.progressPercent * 100).round()}%',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: course.progressPercent,
                    backgroundColor: AppTheme.greySubtle,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.pureBlack),
                    minHeight: 7,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/course/player', arguments: course),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.pureBlack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Resume Learning',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

class _ModuleProgressRow extends StatelessWidget {
  final CourseModule module;
  const _ModuleProgressRow({required this.module});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: module.isCompleted ? AppTheme.pureBlack : AppTheme.greySubtle,
              border: Border.all(
                color: module.isCompleted ? AppTheme.pureBlack : AppTheme.borderColor,
              ),
            ),
            child: Icon(
              module.isCompleted ? Icons.check_rounded : Icons.circle_outlined,
              size: 13,
              color: module.isCompleted ? Colors.white : AppTheme.textHint,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Week ${module.weekNumber}: ${module.title}',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: module.isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary,
                decoration: module.isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: AppTheme.textHint,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            module.duration,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10.5,
              color: AppTheme.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
