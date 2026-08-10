import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/realtime/payment_realtime_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_header.dart';

import '../payments/models/child_finance_model.dart';
import '../payments/models/finance_summary_model.dart';

import '../payments/services/payment_service.dart';

import '../payments/widgets/child_payment_card.dart';
import '../payments/widgets/finance_summary_card.dart';
import '../payments/widgets/payment_history_card.dart';

import 'payment_history_screen.dart';

class PaymentsScreen extends StatefulWidget {

  const PaymentsScreen({
    super.key,
  });

  @override
  State<PaymentsScreen> createState() =>
      _PaymentsScreenState();

}

class _PaymentsScreenState
    extends State<PaymentsScreen> {

  final PaymentService service =
      PaymentService();

  FinanceSummaryModel? summary;

  bool loading = true;

  StreamSubscription? _paymentSubscription;

  //-------------------------------------------------------
  // Chargement
  //-------------------------------------------------------

  Future<void> loadData() async {

    try {

      final data =
          await service.getFinanceSummary();

      if (!mounted) return;

      setState(() {

        summary = data;

        loading = false;

      });

    } catch (_) {

      if (!mounted) return;

      setState(() {

        loading = false;

      });

    }

  }

  //-------------------------------------------------------
  // Changement d'enfant
  //-------------------------------------------------------

  Future<void> changeChild(

    ChildFinanceModel child,

  ) async {

    setState(() {

      loading = true;

    });

    try {

      await service.changeActiveChild(

        child.id,

      );

      await loadData();

    } catch (_) {

      if (!mounted) return;

      setState(() {

        loading = false;

      });

    }

  }

  //-------------------------------------------------------
  // Temps réel
  //-------------------------------------------------------

  void _listenRealtime() {

    _paymentSubscription =

        PaymentRealtimeService.instance.stream.listen(

      (_) async {

        debugPrint(

          "========== PAYMENT REALTIME ==========",

        );

        await loadData();

      },

    );

  }

  //-------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

    _listenRealtime();

  }

  //-------------------------------------------------------

  @override
  void dispose() {

    _paymentSubscription?.cancel();

    super.dispose();

  }

  //-------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Scaffold(

        body: Center(

          child: CircularProgressIndicator(),

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
          AppColors.background,

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          physics:
              const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.only(
            bottom: 30,
          ),

          children: [

            //--------------------------------------------------
            // HEADER
            //--------------------------------------------------

            const AppHeader(

              title: "Paiements",

              subtitle:
                  "Suivez la scolarité de vos enfants",

            ),

            const SizedBox(height: 28),

            Padding(

              padding:
                  const EdgeInsets.symmetric(

                horizontal: 22,

              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    summary!.studentName,

                    style: const TextStyle(

                      fontSize: 24,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 20),

                  //--------------------------------------------------
                  // SYNTHÈSE
                  //--------------------------------------------------

                  AnimatedSwitcher(

                    duration:
                        const Duration(

                      milliseconds: 350,

                    ),

                    child:
                        FinanceSummaryCard(

                      key: ValueKey(

                        summary!.studentId,

                      ),

                      summary: summary!,

                    ),

                  ),

                  const SizedBox(height: 34),

                  //--------------------------------------------------
                  // ENFANTS
                  //--------------------------------------------------

                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(

                        "Mes enfants",

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                      TextButton.icon(

                        onPressed: () {

                          ScaffoldMessenger.of(context)

                              .showSnackBar(

                            const SnackBar(

                              content: Text(

                                "Tous vos enfants sont déjà affichés.",

                              ),

                            ),

                          );

                        },

                        icon: const Icon(

                          Icons.info_outline,

                          size: 15,

                        ),

                        label: const Text(

                          "Voir tout",

                        ),

                      ),

                    ],

                  ),

                  const SizedBox(height: 14),

                  ...summary!.children.map(

                    (child) =>

                        ChildPaymentCard(

                      child: child,

                      activeChildId:
                          summary!.studentId,

                      onTap: () {

                        changeChild(child);

                      },

                    ),

                  ),

                  const SizedBox(height: 30),

                  //--------------------------------------------------
                  // HISTORIQUE
                  //--------------------------------------------------

                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(

                        "Derniers paiements",

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                      if (summary!
                              .payments.length >
                          5)

                        TextButton.icon(

                          onPressed: () {

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>

                                    PaymentHistoryScreen(

                                  payments: summary!
                                      .payments,

                                ),

                              ),

                            );

                          },

                          icon: const Icon(

                            Icons.arrow_forward_ios,

                            size: 15,

                          ),

                          label: const Text(

                            "Voir tout",

                          ),

                        ),

                    ],

                  ),

                  const SizedBox(height: 16),

                  ...summary!.payments

                      .take(5)

                      .map(

                        (payment) => Padding(

                          padding:
                              const EdgeInsets.only(

                            bottom: 14,

                          ),

                          child:
                              PaymentHistoryCard(

                            payment: payment,

                          ),

                        ),

                      ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

}