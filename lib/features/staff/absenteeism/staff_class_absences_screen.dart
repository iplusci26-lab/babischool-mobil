
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/staff_class_absences_model.dart';
import 'staff_class_absences_service.dart';

class StaffClassAbsencesScreen extends StatefulWidget {
  final String classroomId;
  final String classroomName;

  const StaffClassAbsencesScreen({
    super.key,
    required this.classroomId,
    required this.classroomName,
  });

  @override
  State<StaffClassAbsencesScreen> createState() =>
      _StaffClassAbsencesScreenState();
}

class _StaffClassAbsencesScreenState
    extends State<StaffClassAbsencesScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color backgroundColor = Color(0xFFF7F5FC);

  static const Color redColor = Color(0xFFE53935);
  static const Color greenColor = Color(0xFF55AD49);
  static const Color orangeColor = Color(0xFFF39A16);

  late Future<StaffClassAbsencesModel> _future;

  int _selectedPeriod = 30;

  String? _justificationStatus;

  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  // ============================================================
  // CHARGEMENT DES DONNÉES
  // ============================================================

  Future<StaffClassAbsencesModel> _fetchData() {
    final now = DateTime.now();

    final startDate = _customStartDate ??
        DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(
          Duration(days: _selectedPeriod - 1),
        );

    final endDate = _customEndDate ?? now;

    return StaffClassAbsencesService.getClassAbsences(
      classroomId: widget.classroomId,
      startDate: startDate,
      endDate: endDate,
      justificationStatus: _justificationStatus,
    );
  }

  Future<void> _refresh() async {
    final future = _fetchData();

    setState(() {
      _future = future;
    });

    try {
      await future;
    } catch (_) {
      // L'erreur sera affichée dans FutureBuilder.
    }
  }

  void _reloadData() {
    setState(() {
      _future = _fetchData();
    });
  }

  // ============================================================
  // FILTRES DE PÉRIODE
  // ============================================================

  Future<void> _selectCustomDates() async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: _customStartDate ??
            DateTime(
              now.year,
              now.month,
              now.day,
            ).subtract(const Duration(days: 29)),
        end: _customEndDate ?? now,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _customStartDate = picked.start;
      _customEndDate = picked.end;
      _selectedPeriod = 0;
      _future = _fetchData();
    });
  }

  void _selectPeriod(int days) {
    setState(() {
      _selectedPeriod = days;
      _customStartDate = null;
      _customEndDate = null;
      _future = _fetchData();
    });
  }

  void _selectStatus(String? status) {
    setState(() {
      _justificationStatus = status;
      _future = _fetchData();
    });
  }

  // ============================================================
  // FORMATS
  // ============================================================

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _justificationLabel(String status) {
    switch (status.trim().toUpperCase()) {
      case 'JUSTIFIED':
        return 'Justifiée';

      case 'PENDING':
        return 'En attente';

      case 'REJECTED':
        return 'Refusée';

      default:
        return status;
    }
  }

  Color _justificationColor(String status) {
    switch (status.trim().toUpperCase()) {
      case 'JUSTIFIED':
        return greenColor;

      case 'REJECTED':
        return redColor;

      default:
        return orangeColor;
    }
  }

  IconData _justificationIcon(String status) {
    switch (status.trim().toUpperCase()) {
      case 'JUSTIFIED':
        return Icons.check_circle_outline_rounded;

      case 'REJECTED':
        return Icons.cancel_outlined;

      default:
        return Icons.access_time_rounded;
    }
  }

  String _getInitials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();

    if (parts.isEmpty) return '?';

    return parts
        .map((part) => part[0].toUpperCase())
        .join();
  }

  // ============================================================
  // BUILD PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: primaryColor,
        title: const Text(
          'Absences de la classe',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),

      body: RefreshIndicator(
        color: primaryColor,
        backgroundColor: Colors.white,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 25),
          children: [
            // En-tête de la classe
            _buildHeader(),

            // Filtres
            _buildFilters(),

            // Résultats
            FutureBuilder<StaffClassAbsencesModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _buildError(snapshot.error);
                }

                final data = snapshot.data;

                if (data == null) {
                  return _buildEmpty();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // Statistiques
                      _buildStatistics(data),

                      const SizedBox(height: 20),

                      // Titre de la liste
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Liste des absences',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFE2FF),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${data.totalAbsences} absence(s)',
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      // Liste des absences
                      if (data.absences.isEmpty)
                        _buildEmpty()
                      else
                        ...data.absences.map(
                          _buildAbsenceCard,
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EN-TÊTE DE LA CLASSE
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        19,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6200C9),
            Color(0xFF7100D8),
            Color(0xFF8A16E8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.school_rounded,
              size: 90,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),

          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(width: 15),

              Container(
                width: 1,
                height: 55,
                color: Colors.white.withValues(alpha: 0.40),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Classe sélectionnée',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      widget.classroomName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTRES
  // ============================================================

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        16,
        18,
      ),
      child: Column(
        children: [
          // Périodes et calendrier
          Row(
            children: [
              Expanded(
                child: _periodButton('7 jours', 7),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: _periodButton('30 jours', 30),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: _periodButton('90 jours', 90),
              ),

              const SizedBox(width: 5),

              SizedBox(
                height: 39,
                child: OutlinedButton(
                  onPressed: _selectCustomDates,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(
                      color: _selectedPeriod == 0
                          ? primaryColor
                          : Colors.grey.shade400,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Filtre de justification
          DropdownButtonFormField<String?>(
            value: _justificationStatus,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Statut de justification',
              labelStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              prefixIcon: const Icon(
                Icons.filter_alt_outlined,
                color: primaryColor,
                size: 21,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.3,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem<String?>(
                value: null,
                child: Text('Tous les statuts'),
              ),
              DropdownMenuItem<String?>(
                value: 'PENDING',
                child: Text('En attente'),
              ),
              DropdownMenuItem<String?>(
                value: 'JUSTIFIED',
                child: Text('Justifiées'),
              ),
              DropdownMenuItem<String?>(
                value: 'REJECTED',
                child: Text('Refusées'),
              ),
            ],
            onChanged: _selectStatus,
          ),
        ],
      ),
    );
  }

  Widget _periodButton(String label, int days) {
    final selected = _selectedPeriod == days;

    return SizedBox(
      height: 39,
      child: OutlinedButton(
        onPressed: () => _selectPeriod(days),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selected ? const Color(0xFFE9D8F8) : Colors.white,
          foregroundColor:
              selected ? primaryColor : Colors.black87,
          side: BorderSide(
            color: selected
                ? const Color(0xFFE9D8F8)
                : Colors.grey.shade300,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              const Icon(
                Icons.check_rounded,
                size: 14,
              ),
              const SizedBox(width: 3),
            ],

            Flexible(
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STATISTIQUES
  // ============================================================

  Widget _buildStatistics(StaffClassAbsencesModel data) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            'Absences',
            data.totalAbsences.toString(),
            Icons.event_busy_outlined,
            redColor,
            const Color(0xFFFFF0F0),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            'Élèves concernés',
            data.totalStudentsAbsent.toString(),
            Icons.people_outline_rounded,
            primaryColor,
            const Color(0xFFF3EBFC),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color background,
  ) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARTE D'UNE ABSENCE
  // ============================================================

  Widget _buildAbsenceCard(
    StaffClassAbsenceModel absence,
  ) {
    final color = _justificationColor(
      absence.justificationStatus,
    );

    final initials = _getInitials(absence.fullName);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.025),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identité de l'élève
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFE2FF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      absence.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Matricule : ${absence.studentNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade500,
                size: 25,
              ),
            ],
          ),

          const SizedBox(height: 11),

          Divider(
            height: 1,
            color: const Color(0xFFE2D6EF),
          ),

          const SizedBox(height: 11),

          // Date
          _infoRow(
            Icons.calendar_today_outlined,
            'Date',
            _formatDate(absence.date),
          ),

          // Matière
          if (absence.subject != null)
            _infoRow(
              Icons.menu_book_outlined,
              'Matière',
              absence.subject!,
            ),

          // Horaire
          if (absence.startTime != null &&
              absence.endTime != null)
            _infoRow(
              Icons.access_time_rounded,
              'Heure',
              '${absence.startTime} – ${absence.endTime}',
            ),

          // Période
          if (absence.periodDisplay != null)
            _infoRow(
              Icons.schedule_rounded,
              'Période',
              absence.periodDisplay!,
            ),

          const SizedBox(height: 7),

          // Statut de justification
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: [
              const Text(
                'Justification :',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _justificationIcon(
                        absence.justificationStatus,
                      ),
                      color: color,
                      size: 13,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      _justificationLabel(
                        absence.justificationStatus,
                      ),
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Motif
          if (absence.justificationReason.isNotEmpty) ...[
            const SizedBox(height: 11),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FC),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                'Motif : ${absence.justificationReason}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],

          // Observation
          if (absence.remarks.isNotEmpty) ...[
            const SizedBox(height: 7),

            Text(
              'Observation : ${absence.remarks}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATIONS D'UNE ABSENCE
  // ============================================================

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.grey.shade600,
          ),

          const SizedBox(width: 8),

          Text(
            '$label : ',
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey.shade600,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11.5,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AUCUNE ABSENCE
  // ============================================================

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        45,
        20,
        45,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 27,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: const BoxDecoration(
                color: Color(0xFFF3EBFC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_available_rounded,
                size: 34,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Aucune absence trouvée',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Aucune absence ne correspond aux filtres sélectionnés.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERREURS
  // ============================================================

  Widget _buildError(Object? error) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: redColor,
            size: 48,
          ),

          const SizedBox(height: 13),

          const Text(
            'Impossible de charger les absences',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 17),

          ElevatedButton.icon(
            onPressed: _reloadData,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
