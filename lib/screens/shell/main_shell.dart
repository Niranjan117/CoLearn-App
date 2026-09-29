import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';
import '../home/home_screen.dart';
import '../courses/courses_screen.dart';
import '../vr/vr_learning_screen.dart';
import '../careers/careers_screen.dart';
import '../profile/profile_screen.dart';

/// CoLearn main shell with redesigned premium monochrome bottom nav
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static MainShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainShellState>();

  void navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  late final List<Widget> _screens = const [
    CoLearnHomeScreen(),
    CoursesScreen(),
    VRLearningScreen(),
    CareersScreen(),
    LearnersProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CoLearnBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─── Bottom Navigation Bar ─────────────────────────────────────
class CoLearnBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CoLearnBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavDef> _items = [
    _NavDef(Icons.home_rounded, Icons.home_outlined, 'Home'),
    _NavDef(Icons.menu_book_rounded, Icons.menu_book_outlined, 'Courses'),
    _NavDef(Icons.vrpano_rounded, Icons.vrpano_outlined, '360° / VR'),
    _NavDef(Icons.work_rounded, Icons.work_outline_rounded, 'Careers'),
    _NavDef(Icons.person_rounded, Icons.person_outline_rounded, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        border: const Border(
          top: BorderSide(color: AppTheme.borderColor, width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final def = _items[i];
              final isActive = currentIndex == i;
              if (i == 2) {
                return _VRNavButton(isActive: isActive, onTap: () => onTap(i));
              }
              return _NavButton(
                activeIcon: def.activeIcon,
                inactiveIcon: def.inactiveIcon,
                label: def.label,
                isActive: isActive,
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavDef {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavDef(this.activeIcon, this.inactiveIcon, this.label);
}

class _NavButton extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.pureBlack : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isActive ? activeIcon : inactiveIcon,
                color: isActive ? Colors.white : AppTheme.greyLight,
                size: 21,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppTheme.pureBlack : AppTheme.greyLight,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _VRNavButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _VRNavButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 34,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.pureBlack : AppTheme.greySubtle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: isActive
                  ? [BoxShadow(color: Colors.black.withValues(alpha: 0.28), blurRadius: 10, offset: const Offset(0, 3))]
                  : [],
            ),
            child: Icon(
              Icons.vrpano_rounded,
              color: isActive ? Colors.white : AppTheme.greyMedium,
              size: 20,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? AppTheme.pureBlack : AppTheme.greyLight,
            ),
            child: const Text('360° / VR'),
          ),
        ],
      ),
    );
  }
}
