import 'package:flutter/material.dart';

import '../models/child_finance_model.dart';

class ChildSelector
    extends StatelessWidget {

  final List<ChildFinanceModel> children;
  final String activeChildId;
  

  final Function(
    ChildFinanceModel child,
  ) onSelect;

  const ChildSelector({

    super.key,

    required this.children,
    
    required this.activeChildId,

    required this.onSelect,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return SizedBox(

      height: 95,

      child: ListView.builder(

        scrollDirection:
            Axis.horizontal,

        itemCount:
            children.length,

        itemBuilder:
            (context, index) {


          final child = children[index];

          final isActive = child.id == activeChildId;

          return GestureDetector(

            onTap: () {

              onSelect(
                child,
              );
            },

            child: Container(

              width: 220,

              margin:
                  const EdgeInsets.only(
                right: 12,
              ),

              padding:
                  const EdgeInsets.all(
                16,
              ),

              decoration: BoxDecoration(

                color: isActive
                ? const Color(
                    0xff6214BE,
                    )
                : Colors.white,

            borderRadius:
                BorderRadius.circular(
                20,
            ),

            border: Border.all(

                color: isActive
                    ? const Color(
                        0xff6214BE,
                    )
                    : Colors.grey.shade200,

                width: 2,
            ),

  boxShadow: [

    BoxShadow(

      color: Colors.black
          .withValues(
        alpha: 0.05,
      ),

      blurRadius: 8,
    ),
  ],
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    child.name,

                    style:
                        TextStyle(

                      fontWeight:
                          FontWeight.bold,

                      fontSize: 16,
                      color: isActive
                        ? Colors.white
                        : Colors.black,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    child.classroom,
                  ),

                  const Spacer(),

                  Text(

                    "Reste : ${child.balance.toInt()} FCFA",

                    style:
                        TextStyle(

                      color:isActive
                        ? Colors.white
                        : const Color(
                            0xff6214BE,
                        ),

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}