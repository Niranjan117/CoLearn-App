import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/disease_result_model.dart';

/// Animated confidence score bar
class ConfidenceBar extends StatefulWidget {
  final double value; // 0.0 – 1.0
  final String label;
  final bool animate;

  const ConfidenceBar({
    super.key,
    required this.value,
    required this.label,
    this.animate = true,
  });

  @override
  State<ConfidenceBar> createState() => _ConfidenceBarState();
}

class _ConfidenceBarState extends State<ConfidenceBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _barColor(double val) {
    if (val >= 0.80) return AppTheme.successGreen;
    if (val >= 0.60) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Text(
                '${(_animation.value * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _barColor(widget.value),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => LinearProgressIndicator(
              value: _animation.value,
              minHeight: 8,
              backgroundColor: AppTheme.surfaceGrey,
              valueColor: AlwaysStoppedAnimation<Color>(_barColor(widget.value)),
            ),
          ),
        ),
      ],
    );
  }
}

/// Severity badge chip
class SeverityBadge extends StatelessWidget {
  final DiseaseSeverity severity;

  const SeverityBadge({super.key, required this.severity});

  Color get _color {
    switch (severity) {
      case DiseaseSeverity.healthy:
        return AppTheme.successGreen;
      case DiseaseSeverity.mild:
        return AppTheme.infoBlue;
      case DiseaseSeverity.moderate:
        return AppTheme.warningAmber;
      case DiseaseSeverity.severe:
        return AppTheme.errorRed;
    }
  }

  IconData get _icon {
    switch (severity) {
      case DiseaseSeverity.healthy:
        return Icons.check_circle_rounded;
      case DiseaseSeverity.mild:
        return Icons.info_rounded;
      case DiseaseSeverity.moderate:
        return Icons.warning_amber_rounded;
      case DiseaseSeverity.severe:
        return Icons.dangerous_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _color),
          const SizedBox(width: 4),
          Text(
            severity.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
