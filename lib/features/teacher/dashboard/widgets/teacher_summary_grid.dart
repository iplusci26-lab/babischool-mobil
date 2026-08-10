import 'package:flutter/material.dart';

import '../models/teacher_dashboard_model.dart';


class TeacherSummaryGrid extends StatelessWidget {

  final TeacherSummaryModel summary;

  final VoidCallback? onCoursesTap;

  final VoidCallback? onClassesTap;

  final VoidCallback? onStudentsTap;

  final VoidCallback? onHomeworksTap;

  final VoidCallback? onAssessmentsTap;

  final VoidCallback? onMessagesTap;


  const TeacherSummaryGrid({

    super.key,

    required this.summary,

    this.onCoursesTap,

    this.onClassesTap,

    this.onStudentsTap,

    this.onHomeworksTap,

    this.onAssessmentsTap,

    this.onMessagesTap,

  });


  @override
  Widget build(BuildContext context) {

    return GridView.count(

      shrinkWrap:
          true,

      physics:
          const NeverScrollableScrollPhysics(),

      crossAxisCount:
          2,

      crossAxisSpacing:
          14,

      mainAxisSpacing:
          14,

      // -----------------------------------------------------
      // IMPORTANT
      //
      // 1.45 donnait des cartes trop basses sur Web.
      //
      // On donne maintenant une hauteur suffisante
      // pour le contenu de la carte.
      // -----------------------------------------------------

      childAspectRatio:
          1.25,

      children: [

        //----------------------------------------------------
        // COURS
        //----------------------------------------------------

        _SummaryCard(

          title:
              "Cours",

          value:
              summary.todayCourses.toString(),

          icon:
              Icons.schedule,

          color:
              Colors.blue,

          onTap:
              onCoursesTap,

        ),


        //----------------------------------------------------
        // CLASSES
        //----------------------------------------------------

        _SummaryCard(

          title:
              "Classes",

          value:
              summary.classes.toString(),

          icon:
              Icons.groups,

          color:
              Colors.orange,

          onTap:
              onClassesTap,

        ),


        //----------------------------------------------------
        // ÉLÈVES
        //----------------------------------------------------

        _SummaryCard(

          title:
              "Élèves",

          value:
              summary.students.toString(),

          icon:
              Icons.school,

          color:
              Colors.green,

          onTap:
              onStudentsTap,

        ),


        //----------------------------------------------------
        // DEVOIRS
        //----------------------------------------------------

        _SummaryCard(

          title:
              "Devoirs",

          value:
              summary.pendingHomeworks.toString(),

          icon:
              Icons.assignment,

          color:
              Colors.deepPurple,

          onTap:
              onHomeworksTap,

        ),


        //----------------------------------------------------
        // ÉVALUATIONS
        //----------------------------------------------------

        _SummaryCard(

          title:
              "Évaluations",

          value:
              summary.pendingAssessments.toString(),

          icon:
              Icons.fact_check,

          color:
              Colors.red,

          onTap:
              onAssessmentsTap,

        ),


        //----------------------------------------------------
        // MESSAGES
        //----------------------------------------------------

        _SummaryCard(

          title:
              "Messages",

          value:
              summary.unreadMessages.toString(),

          icon:
              Icons.chat,

          color:
              Colors.teal,

          onTap:
              onMessagesTap,

        ),

      ],

    );

  }

}


//============================================================
// CARD
//============================================================

class _SummaryCard extends StatelessWidget {

  final String title;

  final String value;

  final IconData icon;

  final Color color;

  final VoidCallback? onTap;


  const _SummaryCard({

    required this.title,

    required this.value,

    required this.icon,

    required this.color,

    this.onTap,

  });


  @override
  Widget build(BuildContext context) {

    return Material(

      color:
          Colors.transparent,

      child: InkWell(

        onTap:
            onTap,

        borderRadius:
            BorderRadius.circular(22),

        child: Ink(

          padding:
              const EdgeInsets.all(16),

          decoration:
              BoxDecoration(

            color:
                Colors.white,

            borderRadius:
                BorderRadius.circular(22),

            boxShadow:
                const [

              BoxShadow(

                color:
                    Colors.black12,

                blurRadius:
                    12,

                offset:
                    Offset(0, 4),

              ),

            ],

          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              //------------------------------------------------
              // ICÔNE
              //------------------------------------------------

              Container(

                padding:
                    const EdgeInsets.all(9),

                decoration:
                    BoxDecoration(

                  color:
                      color.withOpacity(.12),

                  borderRadius:
                      BorderRadius.circular(14),

                ),

                child: Icon(

                  icon,

                  color:
                      color,

                  size:
                      24,

                ),

              ),


              //------------------------------------------------
              // VALEUR + TITRE
              //------------------------------------------------

              Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  Text(

                    value,

                    maxLines:
                        1,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(

                      fontSize:
                          28,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(

                    title,

                    maxLines:
                        1,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        TextStyle(

                      color:
                          Colors.grey.shade600,

                      fontSize:
                          14,

                    ),

                  ),

                ],

              ),

            ],

          ),

        ),

      ),

    );

  }

}