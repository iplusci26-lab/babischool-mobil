import 'package:flutter/material.dart';

class DashboardHeader
    extends StatelessWidget {

  final String parentName;

  final int unreadCount;

  final VoidCallback onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.parentName,
    required this.unreadCount,
    required this.onNotificationTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Row(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Expanded(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(

                children: [

                  const Icon(

                    Icons.school,

                    color: Color(
                      0xff6214BE,
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Text(

                    "BabiSchool",

                    style: Theme.of(
                      context,
                    )
                        .textTheme
                        .titleLarge
                        ?.copyWith(

                          fontWeight:
                              FontWeight.bold,

                          color:
                              const Color(
                            0xff6214BE,
                          ),
                        ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Text(

                "Bonjour $parentName 👋",

                style:
                    const TextStyle(

                  fontSize: 24,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(

                "Restez informé sur la scolarité\n"
                "de vos enfants",

                style: TextStyle(

                  color:
                      Colors.grey.shade600,

                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        Stack(

          children: [

            IconButton(

              onPressed:
                  onNotificationTap,

              icon: const Icon(
                Icons.notifications_outlined,
              ),
            ),

            if (unreadCount > 0)

              Positioned(

                right: 8,

                top: 8,

                child: Container(

                  padding:
                      const EdgeInsets.all(
                    5,
                  ),

                  decoration:
                      const BoxDecoration(

                    color: Colors.red,

                    shape:
                        BoxShape.circle,
                  ),

                  child: Text(

                    unreadCount
                        .toString(),

                    style:
                        const TextStyle(

                      color:
                          Colors.white,

                      fontSize: 10,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}