import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class SolidBackground extends StatelessWidget {
  final Widget child;

  const SolidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutral50,
      child: child,
    );
  }
}
