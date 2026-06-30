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

      color:
          Colors.transparent,

      child: InkWell(

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        onTap: onTap,

        child: Container(

          padding:
              padding ??
              const EdgeInsets.all(
                20,
              ),

          decoration:
              BoxDecoration(

            color:
                color ??
                Colors.white,

            borderRadius:
                BorderRadius.circular(
              22,
            ),

            boxShadow: [

              BoxShadow(

                color: Colors.black
                    .withValues(
                  alpha: 0.05,
                ),

                blurRadius: 14,

                offset:
                    const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: child,
        ),
      ),
    );
  }
}