import 'package:flutter/material.dart';

import '../payments/models/finance_summary_model.dart';
import '../payments/models/child_finance_model.dart';


import '../payments/services/payment_service.dart';

import '../payments/widgets/finance_card.dart';
import '../payments/widgets/payment_tile.dart';
import '../payments/widgets/child_selector.dart';

class PaymentsScreen
    extends StatefulWidget {

  const PaymentsScreen({
    super.key,
  });

  @override
  State<PaymentsScreen>
  createState() =>
      _PaymentsScreenState();
}

class _PaymentsScreenState
    extends State<PaymentsScreen> {

  final PaymentService service =
      PaymentService();

  FinanceSummaryModel? summary;

  bool loading = true;

  Future<void> changeChild(
    ChildFinanceModel child,
  ) async {

    setState(() {
      loading = true;
    });

    try {

      await service
          .changeActiveChild(
        child.id,
      );

      await loadData();

    } catch (e) {

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> loadData()
  async {

    try {

      final data = await service.getFinanceSummary();

      setState(() {

        summary = data;

        loading = false;
      });

    } catch (e) {

      setState(() {

        loading = false;
      });
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

      return const Scaffold(

        body: Center(

          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (summary == null) {

      return const Scaffold(

        body: Center(

          child: Text(
            "Impossible de charger les paiements",
          ),
        ),
      );
    }

    return Scaffold(

      backgroundColor:
          const Color(
        0xffF7F8FC,
      ),

      appBar: AppBar(

        title: const Text(
          "Paiements",
        ),

        centerTitle: false,

        elevation: 0,
      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          padding:
              const EdgeInsets.all(
            20,
          ),

          children: [

            Text(

              summary!
                  .studentName,

              style:
                  const TextStyle(

                fontSize: 20,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ChildSelector(

              children:summary!.children,

              activeChildId:summary!.studentId,

              onSelect:changeChild,
            ),

            const SizedBox(
              height: 24,
            ),

            FinanceCard(

              tuitionFee:
                  summary!
                      .tuitionFee,

              amountPaid:
                  summary!
                      .amountPaid,

              balance:
                  summary!
                      .balance,
            ),

            const SizedBox(
              height: 30,
            ),

            const Text(

              "Historique des paiements",

              style: TextStyle(

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ...summary!
                .payments
                .map(

              (payment) =>
                  PaymentTile(
                payment:
                    payment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}