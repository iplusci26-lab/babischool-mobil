import 'package:flutter/material.dart';

import '../models/payment_model.dart';

class PaymentTile
    extends StatelessWidget {

  final PaymentModel payment;

  const PaymentTile({
    super.key,
    required this.payment,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 12,
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

            color: Colors.black
                .withValues(alpha: 0.05),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Row(

        children: [

          Container(

            width: 48,

            height: 48,

            decoration:
                BoxDecoration(

              color: const Color(
                0xff6214BE,
              ).withValues(alpha: 0.1),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: const Icon(

              Icons.payments,

              color: Color(
                0xff6214BE,
              ),
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  "${payment.amount.toInt()} FCFA",

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

                  payment.paymentDate,

                  style:
                      TextStyle(

                    color: Colors.grey
                        .shade600,
                  ),
                ),

                if (payment.reference
                    .isNotEmpty)

                  Padding(

                    padding:
                        const EdgeInsets
                            .only(
                      top: 4,
                    ),

                    child: Text(

                      "Réf : ${payment.reference}",

                      style:
                          TextStyle(

                        color:
                            Colors.grey
                                .shade500,

                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Icon(

            Icons.check_circle,

            color: Colors.green,
          ),
        ],
      ),
    );
  }
}