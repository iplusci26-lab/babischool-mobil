
import 'package:flutter/material.dart';

import 'staff_student_detail_screen.dart';
import 'models/staff_student_model.dart';
import 'staff_classroom_students_service.dart';

class StaffClassroomStudentsScreen extends StatefulWidget {
  final String classroomId;
  final String classroomName;

  const StaffClassroomStudentsScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  State<StaffClassroomStudentsScreen> createState() =>
      _StaffClassroomStudentsScreenState();
}

class _StaffClassroomStudentsScreenState
    extends State<StaffClassroomStudentsScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color backgroundColor = Color(0xFFF7F8FC);

  // Couleurs selon le sexe
  static const Color maleColor = Color(0xFF2684E8);
  static const Color maleBackground = Color(0xFFEAF3FF);
  static const Color maleBorder = Color(0xFFB9D8FF);

  static const Color femaleColor = Color(0xFFE83E8C);
  static const Color femaleBackground = Color(0xFFFFEFF6);
  static const Color femaleBorder = Color(0xFFFFC3DE);

  final TextEditingController searchController =
      TextEditingController();

  late Future<Map<String, dynamic>> studentsFuture;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    studentsFuture =
        StaffClassroomStudentsService.getStudents(
      widget.classroomId,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Actualisation des élèves
  Future<void> refreshStudents() async {
    final future =
        StaffClassroomStudentsService.getStudents(
      widget.classroomId,
    );

    setState(() {
      studentsFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // L'erreur est affichée par FutureBuilder.
    }
  }

  // Filtrage et tri alphabétique
  List<StaffStudentModel> filterStudents(
    List<StaffStudentModel> students,
  ) {
    final query = searchQuery.trim().toLowerCase();

    final filtered = students.where((student) {
      if (query.isEmpty) return true;

      return student.firstName.toLowerCase().contains(query) ||
          student.lastName.toLowerCase().contains(query) ||
          student.fullName.toLowerCase().contains(query) ||
          student.studentNumber.toLowerCase().contains(query);
    }).toList();

    filtered.sort((a, b) {
      final lastNameComparison = a.lastName
          .toLowerCase()
          .compareTo(b.lastName.toLowerCase());

      if (lastNameComparison != 0) {
        return lastNameComparison;
      }

      final firstNameComparison = a.firstName
          .toLowerCase()
          .compareTo(b.firstName.toLowerCase());

      if (firstNameComparison != 0) {
        return firstNameComparison;
      }

      return a.studentNumber.compareTo(b.studentNumber);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // En-tête
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Text(
          widget.classroomName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: refreshStudents,
            icon: const Icon(
              Icons.refresh_rounded,
              color: primaryColor,
              size: 25,
            ),
            tooltip: 'Actualiser',
          ),
          const SizedBox(width: 4),
        ],
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildError(
              snapshot.error.toString(),
            );
          }

          if (!snapshot.hasData) {
            return _buildError(
              'Aucune donnée disponible.',
            );
          }

          final data = snapshot.data!;

          final students =
              data['students'] as List<StaffStudentModel>;

          final totalStudents =
              (data['total_students'] as num?)?.toInt() ??
                  students.length;

          final filteredStudents =
              filterStudents(students);

          return RefreshIndicator(
            onRefresh: refreshStudents,
            color: primaryColor,
            backgroundColor: Colors.white,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                14,
                16,
                14,
                24,
              ),
              children: [
                // En-tête de la classe
                _buildHeader(totalStudents),

                const SizedBox(height: 20),

                // Recherche
                _buildSearchField(),

                const SizedBox(height: 24),

                // Titre de la liste
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Liste des élèves',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    Text(
                      '${filteredStudents.length} résultat(s)',
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Liste des élèves
                if (filteredStudents.isEmpty)
                  _buildEmptyState(
                    hasSearch: searchQuery.trim().isNotEmpty,
                  )
                else
                  ...filteredStudents.map(
                    _buildStudentCard,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // EN-TÊTE DE LA CLASSE
  // ============================================================

  Widget _buildHeader(int totalStudents) {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6200C9),
            Color(0xFF7100D8),
            Color(0xFF8A16E8),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.13),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12,
            bottom: 5,
            child: Icon(
              Icons.school_rounded,
              size: 75,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 13,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.class_outlined,
                    color: Colors.white,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.classroomName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        '$totalStudents élève(s) inscrit(s)',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECHERCHE
  // ============================================================

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Nom, prénom ou matricule...',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: primaryColor,
          size: 23,
        ),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                tooltip: 'Effacer',
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.grey,
                ),
                onPressed: () {
                  searchController.clear();

                  setState(() {
                    searchQuery = '';
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONFIGURATION DES COULEURS SELON LE SEXE
  // ============================================================

  Color _getGenderColor(String gender) {
    switch (_formatGender(gender)) {
      case 'Masculin':
        return maleColor;

      case 'Féminin':
        return femaleColor;

      default:
        return primaryColor;
    }
  }

  Color _getGenderBackground(String gender) {
    switch (_formatGender(gender)) {
      case 'Masculin':
        return maleBackground;

      case 'Féminin':
        return femaleBackground;

      default:
        return primaryColor.withValues(alpha: 0.07);
    }
  }

  Color _getGenderBorder(String gender) {
    switch (_formatGender(gender)) {
      case 'Masculin':
        return maleBorder;

      case 'Féminin':
        return femaleBorder;

      default:
        return primaryColor.withValues(alpha: 0.20);
    }
  }

  IconData _getGenderIcon(String gender) {
    switch (_formatGender(gender)) {
      case 'Masculin':
        return Icons.male_rounded;

      case 'Féminin':
        return Icons.female_rounded;

      default:
        return Icons.person_outline_rounded;
    }
  }

  // ============================================================
  // CARTE D'UN ÉLÈVE
  // ============================================================

  Widget _buildStudentCard(StaffStudentModel student) {
    final fullName =
        '${student.lastName} ${student.firstName}'.trim();

    final initials = _getInitials(student);

    final gender = _formatGender(student.gender);

    final genderColor = _getGenderColor(student.gender);
    final genderBackground =
        _getGenderBackground(student.gender);
    final genderBorder = _getGenderBorder(student.gender);
    final genderIcon = _getGenderIcon(student.gender);

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: genderBackground,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: genderBorder,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Bande colorée sur le côté gauche
          Positioned(
            left: 0,
            top: 19,
            bottom: 19,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: genderColor,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(5),
                ),
              ),
            ),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StaffStudentDetailScreen(
                      studentId: student.studentId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  15,
                  11,
                  15,
                ),
                child: Row(
                  children: [
                    // Avatar avec initiales
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: genderColor.withValues(
                          alpha: 0.13,
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: genderColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                        ),
                      ),
                    ),

                    const SizedBox(width: 13),

                    // Informations de l'élève
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName.isEmpty
                                ? 'Élève sans nom'
                                : fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Matricule
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Text(
                                  student.studentNumber.isEmpty
                                      ? 'Matricule non renseigné'
                                      : student.studentNumber,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Badge du sexe
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 15,
                                color: Colors.grey.shade600,
                              ),

                              const SizedBox(width: 6),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: genderColor.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      gender,
                                      style: TextStyle(
                                        color: genderColor,
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(width: 4),

                                    Icon(
                                      genderIcon,
                                      size: 15,
                                      color: genderColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Navigation vers les détails
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade600,
                      size: 26,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INITIALES
  // ============================================================

  String _getInitials(StaffStudentModel student) {
    final lastName = student.lastName.trim();
    final firstName = student.firstName.trim();

    final first = lastName.isNotEmpty
        ? lastName[0].toUpperCase()
        : '';

    final second = firstName.isNotEmpty
        ? firstName[0].toUpperCase()
        : '';

    final initials = '$first$second';

    return initials.isEmpty ? '?' : initials;
  }

  // ============================================================
  // NORMALISATION DU SEXE
  // ============================================================

  String _formatGender(String gender) {
    switch (gender.trim().toLowerCase()) {
      case 'm':
      case 'male':
      case 'masculin':
        return 'Masculin';

      case 'f':
      case 'female':
      case 'féminin':
      case 'feminin':
        return 'Féminin';

      default:
        return gender.trim().isEmpty
            ? 'Sexe non renseigné'
            : gender.trim();
    }
  }

  // ============================================================
  // ÉTAT VIDE
  // ============================================================

  Widget _buildEmptyState({
    required bool hasSearch,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 55,
        horizontal: 15,
      ),
      child: Column(
        children: [
          Icon(
            hasSearch
                ? Icons.search_off_rounded
                : Icons.people_outline_rounded,
            size: 58,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 14),

          Text(
            hasSearch
                ? 'Aucun élève trouvé'
                : 'Aucun élève dans cette classe',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            hasSearch
                ? 'Essayez un autre nom, prénom ou matricule.'
                : 'Aucun élève actif n’est enregistré dans cette classe.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GESTION DES ERREURS API
  // ============================================================

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: Colors.redAccent,
              size: 48,
            ),

            const SizedBox(height: 14),

            const Text(
              'Impossible de charger les élèves',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: refreshStudents,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
