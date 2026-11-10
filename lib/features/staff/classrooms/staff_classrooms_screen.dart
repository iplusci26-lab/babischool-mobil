
import 'package:flutter/material.dart';

import 'students/staff_classroom_students_screen.dart';
import '../absenteeism/staff_class_absences_screen.dart';
import 'models/staff_classroom_model.dart';
import 'staff_classroom_service.dart';

class StaffClassroomsScreen extends StatefulWidget {
  final VoidCallback? onAddClassroom;

  const StaffClassroomsScreen({
    super.key,
    this.onAddClassroom,
  });

  @override
  State<StaffClassroomsScreen> createState() =>
      _StaffClassroomsScreenState();
}

class _StaffClassroomsScreenState
    extends State<StaffClassroomsScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color secondaryColor = Color(0xFF8A2BE2);
  static const Color backgroundColor = Color(0xFFF7F8FC);

  late Future<List<StaffClassroomModel>> classroomsFuture;

  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    classroomsFuture = StaffClassroomService.getClassrooms();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Actualisation des classes
  Future<void> refreshClassrooms() async {
    final future = StaffClassroomService.getClassrooms();

    setState(() {
      classroomsFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // L'erreur est gérée par le FutureBuilder.
    }
  }

  // Filtrage des classes
  List<StaffClassroomModel> filterClassrooms(
    List<StaffClassroomModel> classrooms,
  ) {
    if (searchQuery.trim().isEmpty) {
      return classrooms;
    }

    final query = searchQuery.trim().toLowerCase();

    return classrooms.where((classroom) {
      return classroom.name.toLowerCase().contains(query) ||
          classroom.classroomLevel.toLowerCase().contains(query) ||
          classroom.cycle.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // En-tête
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Gestion des classes',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        actions: [
          IconButton(
            onPressed: refreshClassrooms,
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

      // Bouton flottant d'ajout.
      // Il apparaît uniquement lorsqu'une action lui est fournie.
      floatingActionButton: widget.onAddClassroom == null
          ? null
          : FloatingActionButton(
              onPressed: widget.onAddClassroom,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 5,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 32,
              ),
            ),

      body: FutureBuilder<List<StaffClassroomModel>>(
        future: classroomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          final classrooms = snapshot.data ?? [];

          if (classrooms.isEmpty) {
            return _buildEmptyState();
          }

          final filteredClassrooms =
              filterClassrooms(classrooms);

          return RefreshIndicator(
            onRefresh: refreshClassrooms,
            color: primaryColor,
            backgroundColor: Colors.white,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // Statistiques générales
                _buildSummary(classrooms),

                const SizedBox(height: 20),

                // Recherche
                _buildSearchField(),

                const SizedBox(height: 24),

                // Titre de la liste
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        searchQuery.isEmpty
                            ? 'Liste des classes'
                            : 'Résultats de recherche',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '${filteredClassrooms.length} classe(s)',
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Liste des classes
                if (filteredClassrooms.isEmpty)
                  _buildNoSearchResults()
                else
                  ...filteredClassrooms.map(
                    (classroom) =>
                        _buildClassroomCard(classroom),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // BARRE DE RECHERCHE
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
        hintText: 'Rechercher une classe...',
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
          vertical: 16,
          horizontal: 16,
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
  // STATISTIQUES GÉNÉRALES
  // ============================================================

  Widget _buildSummary(
    List<StaffClassroomModel> classrooms,
  ) {
    final totalStudents = classrooms.fold<int>(
      0,
      (total, classroom) =>
          total + classroom.studentsCount,
    );

    return Container(
      height: 122,
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
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Décoration de fond
          Positioned(
            right: 12,
            bottom: 0,
            child: Icon(
              Icons.school_rounded,
              size: 85,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  'Classes',
                  classrooms.length.toString(),
                  Icons.meeting_room_outlined,
                ),
              ),

              Container(
                height: 60,
                width: 1,
                color: Colors.white.withValues(alpha: 0.35),
              ),

              Expanded(
                child: _summaryItem(
                  'Élèves',
                  totalStudents.toString(),
                  Icons.school_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),

        const SizedBox(height: 7),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARTE D'UNE CLASSE
  // ============================================================

  Widget _buildClassroomCard(
    StaffClassroomModel classroom,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          // Informations principales
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StaffClassroomStudentsScreen(
                    classroomId: classroom.id,
                    classroomName: classroom.name,
                  ),
                ),
              );
            },
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(17),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                17,
                12,
                17,
              ),
              child: Row(
                children: [
                  // Icône de classe
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.meeting_room_outlined,
                      color: primaryColor,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Nom et niveau
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classroom.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Niveau ${classroom.classroomLevel}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        if (classroom.cycle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            classroom.cycle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Séparateur vertical
                  Container(
                    height: 53,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),

                  const SizedBox(width: 10),

                  // Nombre d'élèves
                  SizedBox(
                    width: 75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_outline_rounded,
                          color: primaryColor,
                          size: 22,
                        ),

                        const SizedBox(height: 5),

                        Text(
                          classroom.studentsCount.toString(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),

                        Text(
                          'Élèves',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 2),

                  // Indicateur de navigation
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade500,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),

          // Séparateur
          Divider(
            height: 1,
            thickness: 0.7,
            color: Colors.grey.shade200,
          ),

          // Bouton des absences
          Padding(
            padding: const EdgeInsets.fromLTRB(
              11,
              8,
              11,
              8,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StaffClassAbsencesScreen(
                        classroomId: classroom.id,
                        classroomName: classroom.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.event_busy_outlined,
                  size: 17,
                ),
                label: const Text(
                  'Voir les absences',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(
                    color: primaryColor,
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AUCUN RÉSULTAT DE RECHERCHE
  // ============================================================

  Widget _buildNoSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 55,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 55,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 14),

          const Text(
            'Aucune classe trouvée',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Essayez avec un autre nom ou niveau scolaire.',
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
  // AUCUNE CLASSE DISPONIBLE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.meeting_room_outlined,
                size: 45,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Aucune classe disponible',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Aucune classe ne vous est actuellement attribuée.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
              size: 50,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 15),

            const Text(
              'Impossible de charger les classes',
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

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: refreshClassrooms,
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
