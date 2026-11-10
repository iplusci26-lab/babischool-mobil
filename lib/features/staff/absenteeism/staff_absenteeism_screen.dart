
import 'package:flutter/material.dart';

import 'models/staff_absenteeism_model.dart';
import 'staff_absenteeism_service.dart';

class StaffAbsenteeismScreen extends StatefulWidget {
  const StaffAbsenteeismScreen({super.key});

  @override
  State<StaffAbsenteeismScreen> createState() =>
      _StaffAbsenteeismScreenState();
}

class _StaffAbsenteeismScreenState
    extends State<StaffAbsenteeismScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color backgroundColor = Color(0xFFF7F6FC);

  static const Color redColor = Color(0xFFE05252);
  static const Color orangeColor = Color(0xFFE5A126);
  static const Color greenColor = Color(0xFF39A56B);

  late Future<StaffAbsenteeismModel> absenteeismFuture;

  int selectedPeriod = 30;

  DateTime? customStartDate;
  DateTime? customEndDate;

  @override
  void initState() {
    super.initState();
    absenteeismFuture = _fetchData();
  }

  // ============================================================
  // CHARGEMENT DES DONNÉES
  // ============================================================

  Future<StaffAbsenteeismModel> _fetchData() {
    final now = DateTime.now();

    final startDate = customStartDate ??
        DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(
          Duration(days: selectedPeriod - 1),
        );

    final endDate = customEndDate ?? now;

    return StaffAbsenteeismService.getAbsenteeism(
      startDate: startDate,
      endDate: endDate,
    );
  }

  void _loadData() {
    absenteeismFuture = _fetchData();
  }

  Future<void> _refresh() async {
    final future = _fetchData();

    setState(() {
      absenteeismFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // L'erreur est affichée dans FutureBuilder.
    }
  }

  // ============================================================
  // SÉLECTION DE LA PÉRIODE
  // ============================================================

  void _changePeriod(int days) {
    setState(() {
      selectedPeriod = days;
      customStartDate = null;
      customEndDate = null;
      _loadData();
    });
  }

  Future<void> _selectCustomPeriod() async {
    final now = DateTime.now();

    final initialRange = DateTimeRange(
      start: customStartDate ??
          now.subtract(const Duration(days: 29)),
      end: customEndDate ?? now,
    );

    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: initialRange,
      helpText: 'Sélectionner une période',
      saveText: 'Appliquer',
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

    if (result == null || !mounted) return;

    setState(() {
      customStartDate = result.start;
      customEndDate = result.end;
      selectedPeriod = 0;
      _loadData();
    });
  }

  // ============================================================
  // BUILD PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(
          color: primaryColor,
        ),
        title: const Text(
          'Suivi des absences',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(
              Icons.refresh_rounded,
              color: primaryColor,
            ),
            tooltip: 'Actualiser',
          ),
        ],
      ),

      body: FutureBuilder<StaffAbsenteeismModel>(
        future: absenteeismFuture,
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
            return _buildError(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildError(
              'Aucune donnée disponible.',
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            color: primaryColor,
            backgroundColor: Colors.white,
            child: _buildContent(snapshot.data!),
          );
        },
      ),
    );
  }

  // ============================================================
  // CONTENU DE LA PAGE
  // ============================================================

  Widget _buildContent(StaffAbsenteeismModel data) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 25),
      children: [
        // Bannière
        _buildHeader(),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Période d'analyse
              _buildPeriodSelector(),

              const SizedBox(height: 22),

              // Vue générale
              _buildSectionTitle('Vue générale'),

              const SizedBox(height: 13),

              _buildStatistics(data),

              const SizedBox(height: 25),

              // Volume des absences
              _buildSectionTitle('Volume des absences'),

              const SizedBox(height: 13),

              _buildVolumeCard(data),

              const SizedBox(height: 25),

              // Retards
              _buildSectionTitle('Retards'),

              const SizedBox(height: 13),

              _buildLateCard(data),

              const SizedBox(height: 25),

              // Évolution quotidienne
              _buildSectionTitle('Évolution quotidienne'),

              const SizedBox(height: 13),

              _buildDailyStatistics(data),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BANNIÈRE PRINCIPALE
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Container(
        height: 118,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 17),
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
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Décoration graphique
            Positioned(
              right: 0,
              bottom: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildDecorationBar(32),
                  const SizedBox(width: 7),
                  _buildDecorationBar(52),
                  const SizedBox(width: 7),
                  _buildDecorationBar(72),
                ],
              ),
            ),

            Row(
              children: [
                Container(
                  width: 57,
                  height: 57,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.17),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 14),

                Container(
                  width: 1,
                  height: 65,
                  color: Colors.white.withValues(alpha: 0.45),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suivi des absences',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 7),

                      Text(
                        'Analyse et statistiques des absences',
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorationBar(double height) {
    return Container(
      width: 17,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(6),
        ),
      ),
    );
  }

  // ============================================================
  // SÉLECTEUR DE PÉRIODE
  // ============================================================

  Widget _buildPeriodSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: primaryColor,
                size: 21,
              ),
              SizedBox(width: 9),
              Text(
                "Période d'analyse",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 8,
            runSpacing: 9,
            children: [
              _periodChip('7 jours', 7),
              _periodChip('30 jours', 30),
              _periodChip('90 jours', 90),
            ],
          ),

          const SizedBox(height: 9),

          OutlinedButton.icon(
            onPressed: _selectCustomPeriod,
            icon: const Icon(
              Icons.calendar_month_rounded,
              size: 17,
            ),
            label: const Text('Personnalisée'),
            style: OutlinedButton.styleFrom(
              backgroundColor: selectedPeriod == 0
                  ? const Color(0xFFEFE1FC)
                  : const Color(0xFFF4F4F5),
              foregroundColor: primaryColor,
              side: BorderSide(
                color: selectedPeriod == 0
                    ? const Color(0xFFDCC0F5)
                    : Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 9,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          if (selectedPeriod == 0 &&
              customStartDate != null &&
              customEndDate != null) ...[
            const SizedBox(height: 8),
            Text(
              '${_formatDate(customStartDate!)} - '
              '${_formatDate(customEndDate!)}',
              style: const TextStyle(
                fontSize: 11,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _periodChip(String label, int days) {
    final selected = selectedPeriod == days;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) ...[
            const Icon(
              Icons.check_rounded,
              size: 16,
              color: primaryColor,
            ),
            const SizedBox(width: 5),
          ],
          Text(label),
        ],
      ),
      selected: selected,
      showCheckmark: false,
      selectedColor: const Color(0xFFE8D6F8),
      backgroundColor: const Color(0xFFF7F7F8),
      side: BorderSide(
        color: selected
            ? const Color(0xFFE8D6F8)
            : Colors.grey.shade300,
      ),
      labelStyle: TextStyle(
        color: selected ? primaryColor : Colors.black87,
        fontWeight: selected
            ? FontWeight.w700
            : FontWeight.w500,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onSelected: (_) => _changePeriod(days),
    );
  }

  // ============================================================
  // TITRES DES SECTIONS
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }

  // ============================================================
  // VUE GÉNÉRALE - 4 STATISTIQUES
  // ============================================================

  Widget _buildStatistics(StaffAbsenteeismModel data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Absences',
                value: data.totalAbsences,
                icon: Icons.person_off_outlined,
                color: redColor,
                background: const Color(0xFFFFF0F0),
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: _buildStatCard(
                title: 'Retards',
                value: data.totalLates,
                icon: Icons.access_time_rounded,
                color: orangeColor,
                background: const Color(0xFFFFF8E9),
              ),
            ),
          ],
        ),

        const SizedBox(height: 11),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Justifiées',
                value: data.justifiedAbsences,
                icon: Icons.verified_outlined,
                color: greenColor,
                background: const Color(0xFFEEFAF2),
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: _buildStatCard(
                title: 'En attente',
                value: data.pendingJustifications,
                icon: Icons.pending_actions_outlined,
                color: primaryColor,
                background: const Color(0xFFF4EDFC),
              ),
            ),
          ],
        ),
      ],
    );
  }




Widget _buildStatCard({
  required String title,
  required int value,
  required IconData icon,
  required Color color,
  required Color background,
}) {
  return Container(
    height: 108,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 13,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white,
        width: 2.5,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 22,
        ),

        const SizedBox(height: 2),

        Text(
          value.toString(),
          style: TextStyle(
            color: color,
            fontSize: 23,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 11,
            height: 1.1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

  // ============================================================
  // VOLUME DES ABSENCES
  // ============================================================

  Widget _buildVolumeCard(StaffAbsenteeismModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          _buildVolumeItem(
            'Périodes manquées (primaire)',
            data.totalAbsencePeriods.toString(),
            'périodes',
            Icons.view_week_outlined,
            primaryColor,
            const Color(0xFFF0E5FC),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),

          _buildVolumeItem(
            'Durée des absences (secondaire)',
            _formatDuration(data.totalAbsenceMinutes),
            'heures et minutes',
            Icons.access_time_rounded,
            redColor,
            const Color(0xFFFFEEEE),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeItem(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    Color background,
  ) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RETARDS
  // ============================================================

  Widget _buildLateCard(StaffAbsenteeismModel data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3DC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: orangeColor,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Text(
              'Temps total de retard',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          Text(
            _formatDuration(data.totalLateMinutes),
            style: const TextStyle(
              color: orangeColor,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ÉVOLUTION QUOTIDIENNE
  // ============================================================

  Widget _buildDailyStatistics(
    StaffAbsenteeismModel data,
  ) {
    final daily = data.dailyStatistics;

    if (daily.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 45,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 10),

            const Text(
              'Aucune statistique disponible.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    final maxValue = daily.fold<int>(
      1,
      (previous, item) {
        final current = item.absent + item.late;
        return current > previous ? current : previous;
      },
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Légende
          Row(
            children: [
              _buildLegend('Absences', redColor),
              const SizedBox(width: 20),
              _buildLegend('Retards', orangeColor),
            ],
          ),

          const SizedBox(height: 22),

          // Données quotidiennes
          ...daily.map((item) {
            final dateLabel =
                '${item.date.day.toString().padLeft(2, '0')}/'
                '${item.date.month.toString().padLeft(2, '0')}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 17),
              child: Row(
                children: [
                  SizedBox(
                    width: 55,
                    child: Text(
                      dateLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        _buildBar(
                          item.absent,
                          maxValue,
                          redColor,
                        ),

                        const SizedBox(height: 5),

                        _buildBar(
                          item.late,
                          maxValue,
                          orangeColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  SizedBox(
                    width: 22,
                    child: Text(
                      '${item.absent + item.late}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBar(
    int value,
    int maxValue,
    Color color,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = value == 0
            ? 0.0
            : constraints.maxWidth * value / maxValue;

        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 8,
            width: width.clamp(
              0.0,
              constraints.maxWidth,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FORMATAGE DES DURÉES ET DATES
  // ============================================================

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '${remainingMinutes}min';
    }

    if (remainingMinutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${remainingMinutes}min';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // GESTION DES ERREURS
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
              size: 48,
              color: redColor,
            ),

            const SizedBox(height: 12),

            const Text(
              'Impossible de charger les statistiques',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
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

            const SizedBox(height: 17),

            ElevatedButton.icon(
              onPressed: _refresh,
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
      ),
    );
  }
}
