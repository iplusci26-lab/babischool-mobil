import 'package:flutter/material.dart';

import '../models/finance_summary_model.dart';

class FinanceSummaryCard extends StatelessWidget {

  final FinanceSummaryModel summary;

  const FinanceSummaryCard({

    super.key,

    required this.summary,

  });

  @override
  Widget build(BuildContext context) {

    final double percent =

        summary.tuitionFee == 0

            ? 0.0

            : (summary.amountPaid /

                    summary.tuitionFee)

                .clamp(

                  0.0,

                  1.0,

                ).toDouble();

    String message;

    if (percent == 1) {

      message =

          "Scolarité entièrement réglée 🎉";

    } else if (percent >= .70) {

      message =

          "Vous êtes presque à jour.";

    } else if (percent >= .40) {

      message =

          "Continuez vos versements.";

    } else {

      message =

          "Pensez au prochain paiement.";

    }

    return AnimatedContainer(

      duration: const Duration(

        milliseconds: 400,

      ),

      padding: const EdgeInsets.all(

        24,

      ),

      decoration: BoxDecoration(

        gradient: const LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            Color(0xff6214BE),

            Color(0xff8B53F8),

          ],

        ),

        borderRadius:

            BorderRadius.circular(

          30,

        ),

        boxShadow: [

          BoxShadow(

            color: const Color(

              0xff6214BE,

            ).withValues(

              alpha: .30,

            ),

            blurRadius: 20,

            offset: const Offset(

              0,

              10,

            ),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment:

            CrossAxisAlignment.start,

        children: [

          //--------------------------------
          // TITRE
          //--------------------------------

          const Text(

            "Solde restant",

            style: TextStyle(

              color: Colors.white70,

              fontSize: 16,

            ),

          ),

          const SizedBox(

            height: 8,

          ),

          //--------------------------------
          // SOLDE + CERCLE
          //--------------------------------

          Row(

            children: [

              Expanded(

                child: Column(

                  crossAxisAlignment:

                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "${summary.balance.toStringAsFixed(0)} FCFA",

                      style:

                          const TextStyle(

                        color: Colors.white,

                        fontWeight:

                            FontWeight.bold,

                        fontSize: 34,

                      ),

                    ),

                    const SizedBox(

                      height: 6,

                    ),

                    Text(

                      "Sur ${summary.tuitionFee.toStringAsFixed(0)} FCFA",

                      style:

                          const TextStyle(

                        color: Colors.white70,

                        fontSize: 16,

                      ),

                    ),

                  ],

                ),

              ),

              PaymentProgressCircle(

                percent: percent,

              ),

            ],

          ),

          const SizedBox(

            height: 24,

          ),

          Divider(

            color: Colors.white.withValues(

              alpha: .25,

            ),

          ),

          const SizedBox(

            height: 18,

          ),

                    //--------------------------------
          // MONTANTS
          //--------------------------------

          Row(

            children: [

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Montant payé",

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 15,

                      ),

                    ),

                    const SizedBox(

                      height: 8,

                    ),

                    Text(

                      "${summary.amountPaid.toStringAsFixed(0)} FCFA",

                      style: const TextStyle(

                        color: Color(0xff56F2A5),

                        fontWeight: FontWeight.bold,

                        fontSize: 22,

                      ),

                    ),

                  ],

                ),

              ),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.end,

                  children: [

                    const Text(

                      "Montant total",

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 15,

                      ),

                    ),

                    const SizedBox(

                      height: 8,

                    ),

                    Text(

                      "${summary.tuitionFee.toStringAsFixed(0)} FCFA",

                      style: const TextStyle(

                        color: Colors.white,

                        fontWeight: FontWeight.bold,

                        fontSize: 22,

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

          const SizedBox(

            height: 18,

          ),

          //--------------------------------
          // MESSAGE
          //--------------------------------

          Container(

            width: double.infinity,

            padding: const EdgeInsets.all(

              14,

            ),

            decoration: BoxDecoration(

              color: Colors.white.withValues(

                alpha: .10,

              ),

              borderRadius:
                  BorderRadius.circular(

                14,

              ),

            ),

            child: Text(

              message,

              textAlign: TextAlign.center,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 15,

                fontWeight: FontWeight.w500,

              ),

            ),

          ),

        ],

      ),

    );

  }

}

////////////////////////////////////////////////////////
///
/// Cercle de progression
///
////////////////////////////////////////////////////////

class PaymentProgressCircle extends StatelessWidget {

  final double percent;

  const PaymentProgressCircle({

    super.key,

    required this.percent,

  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: 105,

      height: 105,

      child: Stack(

        alignment: Alignment.center,

        children: [

          SizedBox(

            width: 105,

            height: 105,

            child: CircularProgressIndicator(

              value: percent,

              strokeWidth: 9,

              strokeCap: StrokeCap.round,

              backgroundColor:
                  Colors.white24,

              valueColor:

                  const AlwaysStoppedAnimation(

                Colors.white,

              ),

            ),

          ),

          Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Text(

                "${(percent * 100).round()}%",

                style: const TextStyle(

                  color: Colors.white,

                  fontWeight: FontWeight.bold,

                  fontSize: 23,

                ),

              ),

              const SizedBox(

                height: 2,

              ),

              const Text(

                "Payé",

                style: TextStyle(

                  color: Colors.white70,

                  fontSize: 13,

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}