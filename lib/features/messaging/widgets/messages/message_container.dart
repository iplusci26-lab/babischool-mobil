import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {

  final bool isMine;

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final double maxWidth;

  const MessageContainer({

    super.key,

    required this.isMine,

    required this.child,

    this.padding,

    this.maxWidth = 310,
  });

  @override
  Widget build(BuildContext context) {

    return Align(

      alignment: isMine

          ? Alignment.centerRight

          : Alignment.centerLeft,

      child: Container(

        margin: const EdgeInsets.only(
          bottom: 12,
        ),

        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),

        padding: padding,

        decoration: BoxDecoration(

          color: isMine

              ? const Color(0xff6214BE)

              : Colors.white,

          borderRadius: BorderRadius.only(

            topLeft:
                const Radius.circular(20),

            topRight:
                const Radius.circular(20),

            bottomLeft:

                isMine

                    ? const Radius.circular(20)

                    : const Radius.circular(4),

            bottomRight:

                isMine

                    ? const Radius.circular(4)

                    : const Radius.circular(20),
          ),

          boxShadow: [

            BoxShadow(

              color: Colors.black.withValues(
                alpha: .05,
              ),

              blurRadius: 8,

              offset: const Offset(
                0,
                2,
              ),
            ),
          ],
        ),

        child: child,
      ),
    );
  }
}