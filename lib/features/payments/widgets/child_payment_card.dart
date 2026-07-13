import 'package:flutter/material.dart';

import '../models/child_finance_model.dart';

class ChildPaymentCard extends StatelessWidget {

  final ChildFinanceModel child;

  final String activeChildId;

  final VoidCallback onTap;

  const ChildPaymentCard({

    super.key,

    required this.child,

    required this.activeChildId,

    required this.onTap,

  });

  bool get isActive =>

      child.id == activeChildId;

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(

      duration: const Duration(

        milliseconds: 300,

      ),

      margin: const EdgeInsets.only(

        bottom: 16,

      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:

            BorderRadius.circular(22),

        border: Border.all(

          color: isActive

              ? const Color(0xff6214BE)

              : Colors.transparent,

          width: 2,

        ),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(

              alpha: .05,

            ),

            blurRadius: 12,

            offset: const Offset(

              0,

              5,

            ),

          ),

        ],

      ),

      child: InkWell(

        borderRadius:

            BorderRadius.circular(22),

        onTap: onTap,

        child: Padding(

          padding: const EdgeInsets.all(

            18,

          ),

          child: Row(

            children: [

              ////////////////////////////////////////
              ///
              /// Avatar
              ///
              ////////////////////////////////////////

              Hero(

                tag: child.id,

                child: CircleAvatar(

                  radius: 30,

                  backgroundColor:

                      const Color(

                    0xffEEE6FF,

                  ),

                  child: Text(

                    child.name

                        .substring(

                          0,

                          1,

                        )

                        .toUpperCase(),

                    style: const TextStyle(

                      color:

                          Color(

                        0xff6214BE,

                      ),

                      fontSize: 24,

                      fontWeight:

                          FontWeight.bold,

                    ),

                  ),

                ),

              ),

              const SizedBox(

                width: 18,

              ),

              ////////////////////////////////////////
              ///
              /// Nom + Classe
              ///
              ////////////////////////////////////////

              Expanded(

                child: Column(

                  crossAxisAlignment:

                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      child.name,

                      style:

                          const TextStyle(

                        fontSize: 18,

                        fontWeight:

                            FontWeight.bold,

                      ),

                    ),

                    const SizedBox(

                      height: 6,

                    ),

                    Row(

                      children: [

                        const Icon(

                          Icons.school,

                          size: 16,

                          color: Colors.grey,

                        ),

                        const SizedBox(

                          width: 5,

                        ),

                        Text(

                          child.classroom,

                          style: TextStyle(

                            color: Colors

                                .grey

                                .shade600,

                            fontSize: 15,

                          ),

                        ),

                      ],

                    ),

                  ],

                ),

              ),

              ////////////////////////////////////////
              ///
              /// Solde
              ///
              ////////////////////////////////////////

              Container(

                padding:

                    const EdgeInsets.symmetric(

                  horizontal: 16,

                  vertical: 12,

                ),

                decoration: BoxDecoration(

                  color: child.balance == 0

                      ? Colors.green.shade50

                      : const Color(

                          0xffF3ECFF,

                        ),

                  borderRadius:

                      BorderRadius.circular(

                    16,

                  ),

                ),

                child: Column(

                  crossAxisAlignment:

                      CrossAxisAlignment.end,

                  children: [

                    Text(

                      "${child.balance.toStringAsFixed(0)}",

                      style: TextStyle(

                        color:

                            child.balance == 0

                                ? Colors.green

                                : const Color(

                                    0xff6214BE,

                                  ),

                        fontWeight:

                            FontWeight.bold,

                        fontSize: 18,

                      ),

                    ),

                    const SizedBox(

                      height: 4,

                    ),

                    Text(

                      "FCFA",

                      style: TextStyle(

                        color:

                            Colors.grey.shade600,

                        fontSize: 12,

                      ),

                    ),

                    const SizedBox(

                      height: 4,

                    ),

                    Text(

                      child.balance == 0

                          ? "Soldé"

                          : "À payer",

                      style: TextStyle(

                        color:

                            child.balance == 0

                                ? Colors.green

                                : const Color(

                                    0xff6214BE,

                                  ),

                        fontWeight:

                            FontWeight.w600,

                        fontSize: 12,

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}