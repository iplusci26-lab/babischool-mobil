import 'package:flutter/material.dart';

import '../models/child_finance_model.dart';

class ChildFinanceTile
extends StatelessWidget {

  final ChildFinanceModel child;

  const ChildFinanceTile({

    super.key,

    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      width: 220,

      margin:
      const EdgeInsets.only(
        right: 12,
      ),

      padding:
      const EdgeInsets.all(
        16,
      ),

      decoration:
      BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 8,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            child.name,

            style:
            const TextStyle(

              fontSize: 16,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            child.classroom,
          ),

          const Spacer(),

          Text(

            "${child.balance.toInt()} FCFA",

            style:
            const TextStyle(

              fontSize: 18,

              fontWeight:
              FontWeight.bold,

              color:
              Color(
                0xff6214BE,
              ),
            ),
          ),

          const Text(
            "Reste à payer",
          ),
        ],
      ),
    );
  }
}