
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../absenteeism/models/staff_student_absences_model.dart';
import '../../absenteeism/staff_student_absences_service.dart';
import 'models/staff_student_detail_model.dart';
import 'staff_student_detail_service.dart';

class StaffStudentDetailScreen extends StatefulWidget {
  final String studentId;

  const StaffStudentDetailScreen({
    super.key,
    required this.studentId,
  });

  @override
  State<StaffStudentDetailScreen> createState() =>
      _StaffStudentDetailScreenState();
}

class _StaffStudentDetailScreenState
    extends State<StaffStudentDetailScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color backgroundColor = Color(0xFFF7F5FC);

  static const Color redColor = Color(0xFFE53935);
  static const Color greenColor = Color(0xFF55AD49);
  static const Color orangeColor = Color(0xFFF39A16);

  late Future<StaffStudentDetailModel> _studentFuture;
  late Future<StaffStudentAbsencesModel> _absencesFuture;

  int _absencePeriod = 30;

  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    _loadStudent();
    _loadAbsences(widget.studentId);
  }

  // ============================================================
  // CHARGEMENT DES DONNÉES
  // ============================================================

  void _loadStudent() {
    _studentFuture =
        StaffStudentDetailService.getStudentDetail(
      widget.studentId,
    );
  }

  void _loadAbsences(String studentId) {
    final now = DateTime.now();

    final startDate = _customStartDate ??
        DateTime(now.year, now.month, now.day)
            .subtract(
          Duration(days: _absencePeriod - 1),
        );

    final endDate = _customEndDate ??
        DateTime(now.year, now.month, now.day);

    _absencesFuture =
        StaffStudentAbsencesService.getStudentAbsences(
      studentId: studentId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _loadStudent();
      _loadAbsences(widget.studentId);
    });

    await Future.wait([
      _studentFuture,
      _absencesFuture,
    ]);
  }

  // ============================================================
  // DATES ET FORMATS
  // ============================================================

  String _formatAbsenceDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Non renseigné';
    }

    try {
      final date = DateTime.parse(value);

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value;
    }
  }

  String _formatAmount(double value) {
    final formatter = NumberFormat('#,##0', 'fr_FR');
    return '${formatter.format(value)} FCFA';
  }

  String _genderLabel(String gender) {
    switch (gender.trim().toLowerCase()) {
      case 'male':
      case 'm':
      case 'masculin':
        return 'Masculin';

      case 'female':
      case 'f':
      case 'féminin':
      case 'feminin':
        return 'Féminin';

      default:
        return gender.isEmpty ? 'Non renseigné' : gender;
    }
  }

  // ============================================================
  // SÉLECTION DE LA PÉRIODE DES ABSENCES
  // ============================================================

  Future<void> _selectAbsenceDates() async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: _customStartDate ??
            DateTime(now.year, now.month, now.day)
                .subtract(const Duration(days: 29)),
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
      _absencePeriod = 0;

      _loadAbsences(widget.studentId);
    });
  }

  void _changeAbsencePeriod(int days) {
    setState(() {
      _absencePeriod = days;
      _customStartDate = null;
      _customEndDate = null;

      _loadAbsences(widget.studentId);
    });
  }

  // ============================================================
  // TITRE DES SECTIONS
  // ============================================================

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF0E5FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 23,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARTE DE SECTION
  // ============================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(title, icon),

          const SizedBox(height: 10),

          Divider(
            height: 1,
            thickness: 0.8,
            color: const Color(0xFFD9CBEA),
          ),

          const SizedBox(height: 8),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // LIGNE D'INFORMATION
  // ============================================================

  Widget _infoRow(
    String label,
    String value, {
    Color? valueColor,
    FontWeight valueWeight = FontWeight.w500,
  }) {
    final displayValue =
        value.trim().isEmpty ? 'Non renseigné' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            flex: 5,
            child: Text(
              displayValue,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontSize: 12.5,
                fontWeight: valueWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BADGE DE STATUT
  // ============================================================

  Widget _statusBadge(
    String label, {
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _genderRow(String gender) {
    final label = _genderLabel(gender);

    final isMale = label == 'Masculin';
    final isFemale = label == 'Féminin';

    final color = isMale
        ? const Color(0xFF2684E8)
        : isFemale
            ? const Color(0xFFE83E8C)
            : primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Sexe',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.5,
              ),
            ),
          ),

          _statusBadge(
            label,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _booleanRow(
    String label,
    bool value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.5,
              ),
            ),
          ),

          _statusBadge(
            value ? 'Oui' : 'Non',
            color: value ? greenColor : redColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EN-TÊTE DE LA FICHE ÉLÈVE
  // ============================================================


Widget _buildStudentHeader(
  StaffStudentDetailModel student,
) {
  final initials = student.fullName
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  return Container(
    width: double.infinity,
    height: 74,
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF6200C9),
          Color(0xFF7100D8),
          Color(0xFF8A16E8),
        ],
      ),
      borderRadius: BorderRadius.circular(13),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.12),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Icône décorative à droite
        Positioned(
          right: 0,
          child: Icon(
            Icons.school_rounded,
            size: 67,
            color: Colors.white.withValues(alpha: 0.10),
          ),
        ),

        // Contenu horizontal
        Row(
          children: [
            // Avatar
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFEFE2FF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initials.isEmpty ? '?' : initials,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Séparateur vertical
            Container(
              height: 48,
              width: 1,
              color: Colors.white.withValues(alpha: 0.45),
            ),

            const SizedBox(width: 12),

            // Informations de l'élève
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom
                    Text(
                      student.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Matricule
                    Row(
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          color: Colors.white70,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Matricule : ${student.studentNumber}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Classe
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.school_outlined,
                            color: Colors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            student.classroom,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  // ============================================================
  // HISTORIQUE DES ABSENCES
  // ============================================================

  Widget _buildAbsenceHistory() {
    return FutureBuilder<StaffStudentAbsencesModel>(
      future: _absencesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(25),
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text(
                  'Impossible de charger les absences.',
                  style: TextStyle(fontSize: 13),
                ),

                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _loadAbsences(widget.studentId);
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data;

        if (data == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtres de période
            Row(
              children: [
                _absenceFilter('7 jours', 7),

                const SizedBox(width: 5),

                _absenceFilter('30 jours', 30),

                const SizedBox(width: 5),

                _absenceFilter('90 jours', 90),

                const Spacer(),

                IconButton(
                  tooltip: 'Choisir les dates',
                  onPressed: _selectAbsenceDates,
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: primaryColor,
                    size: 23,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Statistiques
            Row(
              children: [
                Expanded(
                  child: _absenceStat(
                    'Absences',
                    data.totalAbsences,
                    redColor,
                    Icons.people_outline,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _absenceStat(
                    'Justifiées',
                    data.justifiedAbsences,
                    greenColor,
                    Icons.check_circle_outline,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _absenceStat(
                    'En attente',
                    data.pendingJustifications,
                    orangeColor,
                    Icons.error_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Absences enregistrées
            if (data.absences.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 23,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3FC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available_rounded,
                      size: 37,
                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'Aucune absence sur cette période.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...data.absences.map(
                _buildStudentAbsenceCard,
              ),
          ],
        );
      },
    );
  }

  Widget _absenceFilter(
    String label,
    int days,
  ) {
    final selected = _absencePeriod == days;

    return Expanded(
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: true,
        checkmarkColor: primaryColor,
        selectedColor: const Color(0xFFE9D9FA),
        backgroundColor: const Color(0xFFFAF8FD),
        side: BorderSide(
          color: selected
              ? const Color(0xFFE0CCF5)
              : Colors.grey.shade300,
        ),
        labelStyle: TextStyle(
          color: selected ? primaryColor : Colors.grey.shade700,
          fontSize: 10,
          fontWeight:
              selected ? FontWeight.w700 : FontWeight.w400,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3),
        onSelected: (_) => _changeAbsencePeriod(days),
      ),
    );
  }

  Widget _absenceStat(
    String label,
    int value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DÉTAIL D'UNE ABSENCE
  // ============================================================

  Widget _buildStudentAbsenceCard(
    StaffStudentAbsenceModel absence,
  ) {
    Color statusColor;

    switch (absence.justificationStatus) {
      case 'JUSTIFIED':
        statusColor = greenColor;
        break;

      case 'REJECTED':
        statusColor = redColor;
        break;

      default:
        statusColor = orangeColor;
    }

    final statusLabel =
        switch (absence.justificationStatus) {
      'JUSTIFIED' => 'Justifiée',
      'REJECTED' => 'Refusée',
      'PENDING' => 'En attente',
      _ => absence.justificationStatus,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_busy_rounded,
                color: redColor,
                size: 20,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  _formatAbsenceDate(absence.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),

              _statusBadge(
                statusLabel,
                color: statusColor,
              ),
            ],
          ),

          if (absence.subject != null)
            _infoRow('Matière', absence.subject!),

          if (absence.periodDisplay != null)
            _infoRow('Période', absence.periodDisplay!),

          if (absence.startTime != null &&
              absence.endTime != null)
            _infoRow(
              'Horaire',
              '${absence.startTime} – ${absence.endTime}',
            ),

          if (absence.justificationReason.isNotEmpty)
            _infoRow(
              'Motif',
              absence.justificationReason,
            ),

          if (absence.remarks.isNotEmpty)
            _infoRow(
              'Observation',
              absence.remarks,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATIONS FINANCIÈRES
  // ============================================================

  Widget _buildFinancialSection(
    StaffStudentDetailModel student,
  ) {
    final balanceColor = student.balance > 0
        ? redColor
        : greenColor;

    return _sectionCard(
      title: 'Situation financière',
      icon: Icons.account_balance_wallet_outlined,
      children: [
        _infoRow(
          'Frais de scolarité',
          _formatAmount(student.tuitionFee),
        ),

        Divider(
          height: 1,
          color: Colors.grey.shade100,
        ),

        _infoRow(
          'Montant payé',
          _formatAmount(student.amountPaid),
        ),

        const SizedBox(height: 5),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E6FC),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Solde restant',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),

              Text(
                _formatAmount(student.balance),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: balanceColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PARENTS ET TUTEURS
  // ============================================================

  Widget _buildParentsSection(
    StaffStudentDetailModel student,
  ) {
    return _sectionCard(
      title: 'Parents et tuteurs',
      icon: Icons.family_restroom_rounded,
      children: [
        if (student.parents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                'Aucun parent ou tuteur renseigné.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ...student.parents.map(
            (parent) {
              final parentName = parent.fullName.isNotEmpty
                  ? parent.fullName
                  : '${parent.firstName} ${parent.lastName}';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7FD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFECE4F5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFE2FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: primaryColor,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                parentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 3),

                              Text(
                                parent.relationshipTypeDisplay,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (parent.isPrimaryContact)
                          const Icon(
                            Icons.verified_rounded,
                            color: primaryColor,
                            size: 20,
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),

                    const SizedBox(height: 5),

                    _infoRow(
                      'Téléphone',
                      parent.phone,
                    ),

                    _infoRow(
                      'Téléphone secondaire',
                      parent.alternatePhone ?? '',
                    ),

                    _infoRow(
                      'Profession',
                      parent.occupation ?? '',
                    ),

                    _infoRow(
                      'Adresse',
                      parent.address ?? '',
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.5,
                              ),
                            ),
                          ),

                          _statusBadge(
                            parent.receivesNotifications
                                ? 'Activées'
                                : 'Désactivées',
                            color: parent.receivesNotifications
                                ? greenColor
                                : redColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // ============================================================
  // FICHE COMPLÈTE DE L'ÉLÈVE
  // ============================================================

  Widget _buildStudent(
    StaffStudentDetailModel student,
  ) {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: primaryColor,
      backgroundColor: Colors.white,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          15,
          16,
          15,
          28,
        ),
        children: [
          // En-tête
          _buildStudentHeader(student),

          // Informations personnelles
          _sectionCard(
            title: 'Informations personnelles',
            icon: Icons.person_outline_rounded,
            children: [
              _infoRow(
                'Prénom',
                student.firstName,
              ),

              _infoRow(
                'Nom',
                student.lastName,
              ),

              _genderRow(student.gender),

              _infoRow(
                'Date de naissance',
                _formatDate(student.dateOfBirth),
              ),

              _infoRow(
                'Lieu de naissance',
                student.birthPlace ?? '',
              ),

              _infoRow(
                'Date d’admission',
                _formatDate(student.admissionDate),
              ),
            ],
          ),

          // Informations scolaires
          _sectionCard(
            title: 'Informations scolaires',
            icon: Icons.school_outlined,
            children: [
              _infoRow(
                'Classe',
                student.classroom,
              ),

              _infoRow(
                'Niveau',
                student.classroomLevel,
              ),

              _infoRow(
                'Cycle',
                student.cycle,
              ),

              _infoRow(
                'Année scolaire',
                student.academicYear,
              ),

              _infoRow(
                'Statut',
                student.status,
                valueColor: student.status.toLowerCase() == 'active'
                    ? greenColor
                    : Colors.black87,
                valueWeight: FontWeight.w700,
              ),

              _booleanRow(
                'Inscription active',
                student.isActive,
              ),

              _booleanRow(
                'Redoublant',
                student.isRepeating,
              ),

              _booleanRow(
                'Affecté',
                student.isAssigned,
              ),
            ],
          ),

          // Historique des absences
          _sectionCard(
            title: 'Historique des absences',
            icon: Icons.event_busy_outlined,
            children: [
              _buildAbsenceHistory(),
            ],
          ),

          // Situation financière
          _buildFinancialSection(student),

          // Parents et tuteurs
          _buildParentsSection(student),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Fiche de l’élève',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: false,
      ),

      body: FutureBuilder<StaffStudentDetailModel>(
        future: _studentFuture,
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
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 45,
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Impossible de charger la fiche de l’élève.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _loadStudent();
                          _loadAbsences(widget.studentId);
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
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

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Aucune donnée disponible.'),
            );
          }

          return _buildStudent(snapshot.data!);
        },
      ),
    );
  }
}
