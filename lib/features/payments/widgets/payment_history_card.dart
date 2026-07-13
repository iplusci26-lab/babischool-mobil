import 'package:flutter/material.dart';

import '../models/payment_model.dart';

class PaymentHistoryCard extends StatelessWidget {

  final PaymentModel payment;

  const PaymentHistoryCard({

    super.key,

    required this.payment,

  });

  //----------------------------------------------------
  // Couleur de l'icône
  //----------------------------------------------------

  Color get iconColor {

    if (payment.reference
        .toLowerCase()
        .contains("inscription")) {

      return Colors.orange;

    }

    return const Color(0xff6214BE);

  }

  //----------------------------------------------------
  // Icône
  //----------------------------------------------------

  IconData get icon {

    if (payment.reference
        .toLowerCase()
        .contains("inscription")) {

      return Icons.how_to_reg_rounded;

    }

    return Icons.payments_rounded;

  }

  //----------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(

      duration: const Duration(

        milliseconds: 250,

      ),

      margin: const EdgeInsets.only(

        bottom: 14,

      ),

      padding: const EdgeInsets.all(

        18,

      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:

            BorderRadius.circular(

          22,

        ),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(

              .05,

            ),

            blurRadius: 12,

            offset: const Offset(

              0,

              5,

            ),

          ),

        ],

      ),

      child: Row(

        children: [

          /////////////////////////////////////////////
          ///
          /// Icône
          ///
          /////////////////////////////////////////////

          Container(

            width: 58,

            height: 58,

            decoration: BoxDecoration(

              color: iconColor.withOpacity(

                .12,

              ),

              borderRadius:

                  BorderRadius.circular(

                18,

              ),

            ),

            child: Icon(

              icon,

              color: iconColor,

              size: 30,

            ),

          ),

          const SizedBox(

            width: 16,

          ),

          /////////////////////////////////////////////
          ///
          /// Informations
          ///
          /////////////////////////////////////////////

          Expanded(

            child: Column(

              crossAxisAlignment:

                  CrossAxisAlignment.start,

              children: [

                Text(

                  payment.reference.isEmpty

                      ? "Paiement"

                      : payment.reference,

                  style:

                      const TextStyle(

                    fontSize: 17,

                    fontWeight:

                        FontWeight.bold,

                  ),

                ),

                const SizedBox(

                  height: 6,

                ),

                Text(

                  payment.notes.isEmpty

                      ? "Paiement enregistré"

                      : payment.notes,

                  maxLines: 2,

                  overflow:

                      TextOverflow.ellipsis,

                  style: TextStyle(

                    color: Colors

                        .grey

                        .shade600,

                    fontSize: 14,

                  ),

                ),

                const SizedBox(

                  height: 8,

                ),

                Row(

                  children: [

                    const Icon(

                      Icons.calendar_today,

                      size: 15,

                      color: Colors.grey,

                    ),

                    const SizedBox(

                      width: 5,

                    ),

                    Text(

                      payment.paymentDate,

                      style: TextStyle(

                        color: Colors

                            .grey

                            .shade500,

                        fontSize: 13,

                      ),

                    ),

                  ],

                ),

              ],

            ),

          ),

          /////////////////////////////////////////////
          ///
          /// Montant
          ///
          /////////////////////////////////////////////

          Column(

            crossAxisAlignment:

                CrossAxisAlignment.end,

            children: [

              Text(

                "${payment.amount.toStringAsFixed(0)} FCFA",

                style:

                    const TextStyle(

                  color: Colors.green,

                  fontSize: 18,

                  fontWeight:

                      FontWeight.bold,

                ),

              ),

              const SizedBox(

                height: 10,

              ),

              Container(

                padding:

                    const EdgeInsets.symmetric(

                  horizontal: 14,

                  vertical: 6,

                ),

                decoration: BoxDecoration(

                  color: Colors.green

                      .withOpacity(

                    .10,

                  ),

                  borderRadius:

                      BorderRadius.circular(

                    30,

                  ),

                ),

                child: const Row(

                  mainAxisSize:

                      MainAxisSize.min,

                  children: [

                    Icon(

                      Icons.check_circle,

                      size: 15,

                      color: Colors.green,

                    ),

                    SizedBox(

                      width: 5,

                    ),

                    Text(

                      "Payé",

                      style: TextStyle(

                        color: Colors.green,

                        fontWeight:

                            FontWeight.w600,

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}