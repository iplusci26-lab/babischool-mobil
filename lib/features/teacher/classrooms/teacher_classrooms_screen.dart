import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import 'models/teacher_assignment_model.dart';
import 'models/teacher_classrooms_response_model.dart';

import 'services/teacher_classrooms_service.dart';

import 'widgets/teacher_classroom_card.dart';

import '../attendance/teacher_attendance_screen.dart';


class TeacherClassroomsScreen extends StatefulWidget {

  const TeacherClassroomsScreen({
    super.key,
  });

  @override
  State<TeacherClassroomsScreen> createState() =>
      _TeacherClassroomsScreenState();

}


class _TeacherClassroomsScreenState
    extends State<TeacherClassroomsScreen> {

  final TeacherClassroomsService service =
      const TeacherClassroomsService();

  TeacherClassroomsResponseModel? response;

  List<TeacherAssignmentModel> assignments = [];

  bool loading = true;

  String? error;

  final TextEditingController searchController =
      TextEditingController();


  //----------------------------------------------------------
  // CHARGEMENT
  //----------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      final data =
          await service.getClassrooms();

      if (!mounted) return;

      setState(() {

        response = data;

        assignments = data.classes;

        loading = false;

      });

    } catch (e) {

      if (!mounted) return;

      setState(() {

        loading = false;

        error = e.toString();

      });

    }

  }


  //----------------------------------------------------------
  // RECHERCHE
  //----------------------------------------------------------

  void search(
    String value,
  ) {

    if (response == null) {
      return;
    }

    final query =
        value.trim().toLowerCase();


    if (query.isEmpty) {

      setState(() {

        assignments =
            response!.classes;

      });

      return;

    }


    setState(() {

      assignments =
          response!.classes.where(

        (assignment) {

          return assignment
                  .classroomName
                  .toLowerCase()
                  .contains(query) ||

              assignment
                  .subjectName
                  .toLowerCase()
                  .contains(query);

        },

      ).toList();

    });

  }


  //----------------------------------------------------------
  // OUVRIR L'APPEL
  //----------------------------------------------------------

  void openAttendance(
    TeacherAssignmentModel assignment,
  ) {

    //--------------------------------------------------------
    // PRIMAIRE
    //
    // BY_PERIODS
    //--------------------------------------------------------

    if (assignment.isPeriodAttendance) {

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              TeacherAttendanceScreen(

            isPrimary:
                true,

            classroomId:
                assignment.classroom.id,

            scheduleId:
                null,

            title:
                "Appel • ${assignment.displayName}",

          ),

        ),

      );

      return;

    }


    //--------------------------------------------------------
    // SECONDAIRE
    //
    // BY_SCHEDULE
    //--------------------------------------------------------

    if (assignment.isScheduleAttendance) {

      final scheduleId =
          assignment.nextCourse?.scheduleId;


      //------------------------------------------------------
      // Aucun cours disponible
      //------------------------------------------------------

      if (scheduleId == null ||
          scheduleId.trim().isEmpty) {

        _showError(

          "Aucun cours disponible pour cette affectation.",

        );

        return;

      }


      //------------------------------------------------------
      // OUVERTURE DE L'APPEL DU COURS
      //------------------------------------------------------

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              TeacherAttendanceScreen(

            isPrimary:
                false,

            classroomId:
                null,

            scheduleId:
                scheduleId,

            title:
                "Appel • ${assignment.displayName}",

          ),

        ),

      );

      return;

    }


    //--------------------------------------------------------
    // MODE INCONNU
    //--------------------------------------------------------

    _showError(

      "Le mode de prise de présence de cette classe "
      "n'est pas reconnu.",

    );

  }


  //----------------------------------------------------------
  // MESSAGE ERREUR
  //----------------------------------------------------------

  void _showError(
    String message,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content:
            Text(message),

        backgroundColor:
            Colors.red,

      ),

    );

  }


  //----------------------------------------------------------
  // INIT
  //----------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }


  //----------------------------------------------------------
  // DISPOSE
  //----------------------------------------------------------

  @override
  void dispose() {

    searchController.dispose();

    super.dispose();

  }


  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    //--------------------------------------------------------
    // LOADING
    //--------------------------------------------------------

    if (loading) {

      return const LoadingView();

    }


    //--------------------------------------------------------
    // ERREUR
    //--------------------------------------------------------

    if (error != null) {

      return ErrorView(

        message:
            error!,

        onRetry: () {

          setState(() {

            loading = true;

          });

          loadData();

        },

      );

    }


    //--------------------------------------------------------
    // ÉCRAN
    //--------------------------------------------------------

    return Scaffold(

      backgroundColor:
          AppColors.background,

      body: RefreshIndicator(

        onRefresh:
            loadData,

        child: ListView(

          physics:
              const AlwaysScrollableScrollPhysics(),

          padding:
              EdgeInsets.zero,

          children: [

            //------------------------------------------------
            // HEADER
            //------------------------------------------------

            const AppHeader(

              title:
                  "Mes classes",

              subtitle:
                  "Retrouvez toutes vos affectations pédagogiques.",

            ),


            Padding(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  //------------------------------------------------
                  // STATISTIQUES
                  //------------------------------------------------

                  Row(

                    children: [

                      Expanded(

                        child: _StatCard(

                          title:
                              "Classes",

                          value:
                              response!
                                  .totalClasses
                                  .toString(),

                          icon:
                              Icons.class_,

                          color:
                              Colors.indigo,

                        ),

                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Expanded(

                        child: _StatCard(

                          title:
                              "Élèves",

                          value:
                              response!
                                  .totalStudents
                                  .toString(),

                          icon:
                              Icons.people,

                          color:
                              Colors.green,

                        ),

                      ),

                    ],

                  ),


                  const SizedBox(
                    height: 24,
                  ),


                  //------------------------------------------------
                  // RECHERCHE
                  //------------------------------------------------

                  TextField(

                    controller:
                        searchController,

                    onChanged:
                        search,

                    decoration:
                        InputDecoration(

                      hintText:
                          "Rechercher une classe...",

                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),

                      filled:
                          true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(

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


                  //------------------------------------------------
                  // TITRE
                  //------------------------------------------------

                  Text(

                    "${assignments.length} affectation(s)",

                    style:
                        const TextStyle(

                      fontSize:
                          20,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),


                  const SizedBox(
                    height: 18,
                  ),


                  //------------------------------------------------
                  // LISTE
                  //------------------------------------------------

                  if (assignments.isEmpty)

                    const Center(

                      child: Padding(

                        padding:
                            EdgeInsets.all(60),

                        child: Text(

                          "Aucune classe trouvée.",

                        ),

                      ),

                    )

                  else

                    ...assignments.map(

                      (assignment) =>

                          TeacherClassroomCard(

                        assignment:
                            assignment,

                        onTap: () {

                          //------------------------------------------------
                          // APPEL
                          //------------------------------------------------

                          openAttendance(
                            assignment,
                          );

                        },

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


//============================================================
// STAT CARD
//============================================================

class _StatCard
    extends StatelessWidget {

  final String title;

  final String value;

  final IconData icon;

  final Color color;


  const _StatCard({

    required this.title,

    required this.value,

    required this.icon,

    required this.color,

  });


  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(20),

      ),

      child: Column(

        children: [

          Icon(

            icon,

            color:
                color,

            size:
                32,

          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            value,

            style:
                const TextStyle(

              fontSize:
                  24,

              fontWeight:
                  FontWeight.bold,

            ),

          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            title,
          ),

        ],

      ),

    );

  }

}