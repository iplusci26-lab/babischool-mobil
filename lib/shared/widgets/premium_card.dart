import 'package:flutter/material.dart';

class PremiumCard
    extends StatelessWidget {

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Color? color;

  const PremiumCard({

    super.key,

    required this.child,

    this.padding,

    this.onTap,

    this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Material(

      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.05),

      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
      