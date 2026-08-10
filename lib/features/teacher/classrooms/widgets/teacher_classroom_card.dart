import 'package:flutter/material.dart';

import '../models/teacher_assignment_model.dart';

class TeacherClassroomCard extends StatelessWidget {

  final TeacherAssignmentModel assignment;

  final VoidCallback? onTap;

  const TeacherClassroomCard({

    super.key,

    required this.assignment,

    this.onTap,

  });

  //----------------------------------------------------------

  Color get accentColor {

    switch (assignment.color) {

      case "green":
        return Colors.green;

      case "orange":
        return Colors.orange;

      case "purple":
        return Colors.deepPurple;

      case "teal":
        return Colors.teal;

      case "indigo":
        return Colors.indigo;

      case "cyan":
        return Colors.cyan;

      default:
        return Colors.blue;

    }

  }

  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 0,

      margin: const EdgeInsets.only(

        bottom: 18,

      ),

      shape: RoundedRectangleBorder(

        borderRadius:

            BorderRadius.circular(22),

      ),

      child: InkWell(

        borderRadius:

            BorderRadius.circular(22),

        onTap: onTap,

        child: Container(

          padding: const EdgeInsets.all(

            20,

          ),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:

                BorderRadius.circular(

              22,

            ),

          ),

          child: Row(

            crossAxisAlignment:

                CrossAxisAlignment.start,

            children: [

              //------------------------------------------------
              // COULEUR
              //------------------------------------------------

              Container(

                width: 6,

                height: 140,

                decoration: BoxDecoration(

                  color: accentColor,

                  borderRadius:

                      BorderRadius.circular(

                    50,

                  ),

                ),

              ),

              const SizedBox(

                width: 18,

              ),

              //------------------------------------------------
              // CONTENU
              //------------------------------------------------

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    //------------------------------------------------
                    // CLASSE
                    //------------------------------------------------

                    Text(

                      assignment.classroomName,

                      style: const TextStyle(

                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),

                    const SizedBox(

                      height: 10,

                    ),

                    //------------------------------------------------
                    // BADGES
                    //------------------------------------------------

                    Wrap(

                      spacing: 8,

                      runSpacing: 8,

                      children: [

                        _Badge(

                          text: assignment.isPrimary
                              ? "Primaire"
                              : "Secondaire",

                          color: accentColor,

                        ),

                        if (assignment
                            .isHomeroomTeacher)

                          const _Badge(

                            text:
                                "Professeur principal",

                            color: Colors.green,

                          ),

                      ],

                    ),

                    const SizedBox(

                      height: 16,

                    ),

                    //------------------------------------------------
                    // MATIERE
                    //------------------------------------------------

                    _InfoTile(

                      icon: Icons.menu_book,

                      title: "Matière",

                      value:
                          assignment.subjectName,

                    ),

                    if (assignment.hasGroup)

                      Padding(

                        padding:
                            const EdgeInsets.only(

                          top: 10,

                        ),

                        child: _InfoTile(

                          icon: Icons.group,

                          title: "Groupe",

                          value:
                              assignment.groupName!,

                        ),

                      ),

                    Padding(

                      padding:
                          const EdgeInsets.only(

                        top: 10,

                      ),

                      child: _InfoTile(

                        icon: Icons.people,

                        title: "Élèves",

                        value:
                            "${assignment.students}",

                      ),

                    ),

                    if (assignment.hasNextCourse)

                      Padding(

                        padding:
                            const EdgeInsets.only(

                          top: 10,

                        ),

                        child: _InfoTile(

                          icon: Icons.schedule,

                          title:
                              "Prochain cours",

                          value:

                              assignment.nextCourse!

                                  .period,

                        ),

                      ),

                  ],

                ),

              ),

              //------------------------------------------------
              // FLECHE
              //------------------------------------------------

              const Icon(

                Icons.chevron_right,

                color: Colors.grey,

              ),

            ],

          ),

        ),

      ),

    );

  }

}

//////////////////////////////////////////////////////////////
// BADGE
//////////////////////////////////////////////////////////////

class _Badge extends StatelessWidget {

  final String text;

  final Color color;

  const _Badge({

    required this.text,

    required this.color,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.symmetric(

        horizontal: 12,

        vertical: 6,

      ),

      decoration: BoxDecoration(

        color:

            color.withOpacity(.10),

        borderRadius:

            BorderRadius.circular(

          30,

        ),

      ),

      child: Text(

        text,

        style: TextStyle(

          color: color,

          fontWeight:
              FontWeight.w600,

          fontSize: 12,

        ),

      ),

    );

  }

}

//////////////////////////////////////////////////////////////
// LIGNE D'INFORMATION
//////////////////////////////////////////////////////////////

class _InfoTile extends StatelessWidget {

  final IconData icon;

  final String title;

  final String value;

  const _InfoTile({

    required this.icon,

    required this.title,

    required this.value,

  });

  @override
  Widget build(BuildContext context) {

    return Row(

      children: [

        Icon(

          icon,

          size: 18,

          color: Colors.grey.shade700,

        ),

        const SizedBox(

          width: 10,

        ),

        Text(

          "$title : ",

          style: TextStyle(

            color: Colors.grey.shade700,

            fontWeight:
                FontWeight.w600,

          ),

        ),

        Expanded(

          child: Text(

            value,

            style: const TextStyle(

              fontWeight:

                  FontWeight.w500,

            ),

          ),

        ),

      ],

    );

  }

}