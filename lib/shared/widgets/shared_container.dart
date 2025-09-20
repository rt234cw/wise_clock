import 'package:flutter/material.dart';
import 'package:wise_clock/core/theme/color_code.dart';

class SharedContainer extends StatelessWidget {
  final Widget child;
  const SharedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      // Use transparent to avoid background color issues
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.15)),
          // color: colorScheme.onSurface.withValues(alpha: 0.05),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorCode.darkGrey, ColorCode.lightGrey],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
