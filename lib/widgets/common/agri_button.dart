import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

enum AgriButtonVariant { primary, secondary, outline, ghost, danger }
enum AgriButtonSize { small, medium, large }

/// AgriFarm standard button with multiple variants and sizes
class AgriButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AgriButtonVariant variant;
  final AgriButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Widget? suffixIcon;

  const AgriButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AgriButtonVariant.primary,
    this.size = AgriButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _height,
      child: _buildButton(),
    );
  }

  double get _height {
    switch (size) {
      case AgriButtonSize.small:
        return 36;
      case AgriButtonSize.medium:
        return 48;
      case AgriButtonSize.large:
        return 56;
    }
  }

  double get _fontSize {
    switch (size) {
      case AgriButtonSize.small:
        return 13;
      case AgriButtonSize.medium:
        return 15;
      case AgriButtonSize.large:
        return 16;
    }
  }

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case AgriButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16);
      case AgriButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24);
      case AgriButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32);
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: variant == AgriButtonVariant.outline || variant == AgriButtonVariant.ghost
              ? AppTheme.primaryGreen
              : Colors.white,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: _fontSize + 2),
          const SizedBox(width: 8),
        ],
        Text(label, style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600)),
        if (suffixIcon != null) ...[
          const SizedBox(width: 8),
          suffixIcon!,
        ],
      ],
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case AgriButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
            elevation: 0,
          ),
          child: _buildContent(),
        );
      case AgriButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.secondaryGold,
            foregroundColor: Colors.white,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
            elevation: 0,
          ),
          child: _buildContent(),
        );
      case AgriButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryGreen,
            side: const BorderSide(color: AppTheme.primaryGreen, width: 1.5),
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
          ),
          child: _buildContent(),
        );
      case AgriButtonVariant.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryGreen,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
          ),
          child: _buildContent(),
        );
      case AgriButtonVariant.danger:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.errorRed,
            foregroundColor: Colors.white,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
            elevation: 0,
          ),
          child: _buildContent(),
        );
    }
  }
}
