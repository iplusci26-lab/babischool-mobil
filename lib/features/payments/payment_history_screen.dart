import 'package:flutter/material.dart';

import '../payments/models/payment_model.dart';
import '../payments/widgets/payment_history_card.dart';

class PaymentHistoryScreen extends StatefulWidget {

  final List<PaymentModel> payments;

  const PaymentHistoryScreen({

    super.key,

    required this.payments,

  });

  @override
  State<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();

}

class _PaymentHistoryScreenState
    extends State<PaymentHistoryScreen> {

  late List<PaymentModel> payments;

  final TextEditingController searchController =
      TextEditingController();

  @override
  void initState() {

    super.initState();

    payments = widget.payments;

  }

  //--------------------------------------------------------
  // RECHERCHE
  //--------------------------------------------------------

  void search(String value) {

    final query =
        value.toLowerCase();

    setState(() {

      payments = widget.payments.where(

        (payment) {

          return payment.reference
                  .toLowerCase()
                  .contains(query) ||

              payment.notes
                  .toLowerCase()
                  .contains(query) ||

              payment.paymentDate
                  .toLowerCase()
                  .contains(query);

        },

      ).toList();

    });

  }

  //--------------------------------------------------------

  double get totalPaid {

    return payments.fold(

      0,

      (sum, payment) =>

          sum + payment.amount,

    );

  }

  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            Colors.transparent,

        foregroundColor: Colors.black,

        title: const Text(

          "Historique",

          style: TextStyle(

            fontWeight: FontWeight.bold,

          ),

        ),

      ),

      body: ListView(

        padding: const EdgeInsets.all(

          20,

        ),

        children: [

          //--------------------------------------------------
          // TITRE
          //--------------------------------------------------

          const Text(

            "Toutes vos transactions",

            style: TextStyle(

              fontSize: 28,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(

            height: 6,

          ),

          Text(

            "Retrouvez l'ensemble des paiements effectués.",

            style: TextStyle(

              color: Colors.grey.shade600,

              fontSize: 15,

            ),

          ),

          const SizedBox(

            height: 25,

          ),

          //--------------------------------------------------
          // STATISTIQUES
          //--------------------------------------------------

          Row(

            children: [

              Expanded(

                child: Container(

                  padding:
                      const EdgeInsets.all(

                    18,

                  ),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(

                      20,

                    ),

                  ),

                  child: Column(

                    children: [

                      const Icon(

                        Icons.receipt_long,

                        color:
                            Color(0xff6214BE),

                      ),

                      const SizedBox(

                        height: 10,

                      ),

                      Text(

                        payments.length.toString(),

                        style: const TextStyle(

                          fontSize: 26,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                      const SizedBox(

                        height: 5,

                      ),

                      const Text(

                        "Paiements",

                      ),

                    ],

                  ),

                ),

              ),

              const SizedBox(

                width: 16,

              ),

              Expanded(

                child: Container(

                  padding:
                      const EdgeInsets.all(

                    18,

                  ),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(

                      20,

                    ),

                  ),

                  child: Column(

                    children: [

                      const Icon(

                        Icons.payments,

                        color:
                            Colors.green,

                      ),

                      const SizedBox(

                        height: 10,

                      ),

                      Text(

                        "${totalPaid.toStringAsFixed(0)}",

                        style: const TextStyle(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                      const SizedBox(

                        height: 5,

                      ),

                      const Text(

                        "FCFA payés",

                      ),

                    ],

                  ),

                ),

              ),

            ],

          ),

          const SizedBox(

            height: 28,

          ),

          //--------------------------------------------------
          // RECHERCHE
          //--------------------------------------------------

          TextField(

            controller:
                searchController,

            onChanged: search,

            decoration: InputDecoration(

              hintText:

                  "Rechercher un paiement...",

              prefixIcon: const Icon(

                Icons.search,

              ),

              filled: true,

              fillColor: Colors.white,

              border: OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(

                  18,

                ),

                borderSide:
                    BorderSide.none,

              ),

            ),

          ),

          const SizedBox(

            height: 26,

          ),

          const Text(

            "Historique",

            style: TextStyle(

              fontWeight: FontWeight.bold,

              fontSize: 22,

            ),

          ),

          const SizedBox(

            height: 16,

          ),

                    //--------------------------------------------------
          // LISTE DES PAIEMENTS
          //--------------------------------------------------

          AnimatedSwitcher(

            duration: const Duration(

              milliseconds: 300,

            ),

            child: payments.isEmpty

                ? Container(

                    key: const ValueKey(

                      "empty",

                    ),

                    padding:

                        const EdgeInsets.symmetric(

                      vertical: 60,

                    ),

                    child: Column(

                      children: [

                        Icon(

                          Icons.receipt_long,

                          size: 90,

                          color: Colors.grey.shade300,

                        ),

                        const SizedBox(

                          height: 20,

                        ),

                        const Text(

                          "Aucun paiement trouvé",

                          style: TextStyle(

                            fontSize: 22,

                            fontWeight:

                                FontWeight.bold,

                          ),

                        ),

                        const SizedBox(

                          height: 8,

                        ),

                        Text(

                          "Essayez une autre recherche.",

                          style: TextStyle(

                            color: Colors.grey.shade600,

                          ),

                        ),

                      ],

                    ),

                  )

                : Column(

                    key: ValueKey(

                      payments.length,

                    ),

                    children: [

                      ...payments.map(

                        (payment) => PaymentHistoryCard(

                          payment: payment,

                        ),

                      ),

                    ],

                  ),

          ),

          const SizedBox(

            height: 40,

          ),

        ],

      ),

    );

  }

  //--------------------------------------------------------

  @override
  void dispose() {

    searchController.dispose();

    super.dispose();

  }

}