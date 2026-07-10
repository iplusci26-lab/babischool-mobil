import 'package:flutter/material.dart';

import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/loading_view.dart';

import 'models/teacher_student_profile_model.dart';
import 'services/teacher_student_profile_service.dart';

class TeacherStudentProfileScreen extends StatefulWidget {

  final String studentId;

  const TeacherStudentProfileScreen({

    super.key,

    required this.studentId,

  });

  @override
  State<TeacherStudentProfileScreen> createState() =>
      _TeacherStudentProfileScreenState();

}

class _TeacherStudentProfileScreenState
    extends State<TeacherStudentProfileScreen> {

  final TeacherStudentProfileService _service =
      TeacherStudentProfileService();

  TeacherStudentProfileModel? profile;

  bool loading = true;

  String? error;

  //--------------------------------------------------------
  // LOAD
  //--------------------------------------------------------

  Future<void> loadProfile() async {

    try {

      error = null;

      profile = await _service.getProfile(

        widget.studentId,

      );

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }

  //--------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadProfile();

  }

  //--------------------------------------------------------

  Widget buildTile({

    required IconData icon,

    required String title,

    required String value,

  }) {

    return Card(

      elevation: 0,

      margin: const EdgeInsets.only(

        bottom: 14,

      ),

      shape: RoundedRectangleBorder(

        borderRadius:

            BorderRadius.circular(16),

      ),

      child: ListTile(

        leading: CircleAvatar(

          backgroundColor: const Color(

            0xff6214BE,

          ).withValues(

            alpha: .10,

          ),

          child: Icon(

            icon,

            color: const Color(

              0xff6214BE,

            ),

          ),

        ),

        title: Text(title),

        subtitle: Text(

          value,

          style: const TextStyle(

            fontWeight: FontWeight.w600,

          ),

        ),

      ),

    );

  }

  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Scaffold(

        body: LoadingView(),

      );

    }

    if (error != null) {

      return Scaffold(

        body: ErrorView(

          message: error!,

          onRetry: () {

            setState(() {

              loading = true;

            });

            loadProfile();

          },

        ),

      );

    }

    return Scaffold(

      appBar: AppBar(

        title: const Text(

          "Profil de l'élève",

        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadProfile,

        child: ListView(

          padding: const EdgeInsets.all(20),

          children: [

            const CircleAvatar(

              radius: 48,

              backgroundColor: Color(

                0xff6214BE,

              ),

              child: Icon(

                Icons.person,

                color: Colors.white,

                size: 50,

              ),

            ),

            const SizedBox(

              height: 20,

            ),

            Center(

              child: Text(

                profile!.name,

                style: const TextStyle(

                  fontSize: 22,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ),

            const SizedBox(

              height: 30,

            ),

            buildTile(

              icon: Icons.badge,

              title: "Matricule",

              value: profile!.registration,

            ),

            buildTile(

              icon: Icons.wc,

              title: "Sexe",

              value: profile!.gender,

            ),

            buildTile(

              icon: Icons.school,

              title: "Classe",

              value: profile!.classroom,

            ),

          ],

        ),

      ),

    );

  }

}