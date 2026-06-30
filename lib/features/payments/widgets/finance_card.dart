import 'package:flutter/material.dart';

class FinanceCard
    extends StatelessWidget {

  final double tuitionFee;

  final double amountPaid;

  final double balance;

  const FinanceCard({
    super.key,
    required this.tuitionFee,
    required this.amountPaid,
    required this.balance,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    final progress =
        tuitionFee == 0
            ? 0.0
            : amountPaid /
                tuitionFee;

    return Container(

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration:
          BoxDecoration(

        color: const Color(
          0xff6214BE,
        ),

        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(

            "Situation financière",

            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Text(

            "${balance.toInt()} FCFA",

            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          LinearProgressIndicator(

            value: progress,

            minHeight: 8,

            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              _InfoItem(
                title: "Scolarité",
                value:
                    tuitionFee.toInt(),
              ),

              _InfoItem(
                title: "Payé",
                value:
                    amountPaid.toInt(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem
    extends StatelessWidget {

  final String title;

  final int value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(

          title,

          style: const TextStyle(
            color:
                Colors.white70,
          ),
        ),

        Text(

          "$value FCFA",

          style: const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}