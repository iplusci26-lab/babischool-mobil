import 'package:flutter/material.dart';

import 'models/finance_summary_model.dart';

import 'services/payment_service.dart';

import 'widgets/finance_card.dart';

import 'widgets/payment_tile.dart';

import '../../shared/widgets/section_title.dart';

class FinanceTab
    extends StatefulWidget {

  final String studentId;

  const FinanceTab({

    super.key,

    required this.studentId,
  });

  @override
  State<FinanceTab> createState() =>
      _FinanceTabState();
}

class _FinanceTabState
    extends State<FinanceTab> {

  final PaymentService service =
      PaymentService();

  FinanceSummaryModel? summary;

  bool loading = true;

  Future<void> loadData() async {

    try {

      summary =

          await service
              .getStudentFinanceSummary(

        widget.studentId,
      );

    } finally {

      if (mounted) {

        setState(() {

          loading = false;
        });
      }
    }
  }

  @override
  void initState() {

    super.initState();

    loadData();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    if (loading) {

      return const Center(

        child:
            CircularProgressIndicator(),
      );
    }

    if (summary == null) {

      return const Center(

        child: Text(
          "Impossible de charger les finances",
        ),
      );
    }

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        children: [

          FinanceCard(

            tuitionFee:
                summary!.tuitionFee,

            amountPaid:
                summary!.amountPaid,

            balance:
                summary!.balance,
          ),

          const SizedBox(
            height: 24,
          ),

          const SectionTitle(

            title:
                "Historique des paiements",
          ),

          const SizedBox(
            height: 16,
          ),

          ...summary!
              .payments
              .map(

                (payment) =>

                    Padding(

                  padding:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: PaymentTile(

                    payment: payment,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}