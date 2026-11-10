
import 'package:flutter/material.dart';

import '../absenteeism/staff_absenteeism_screen.dart';
import '../announcements/staff_announcements_screen.dart';
import '../classrooms/staff_classrooms_screen.dart';

import 'staff_dashboard_service.dart';
import 'models/staff_dashboard_model.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color backgroundColor = Color(0xFFF8F8FD);
  static const Color darkColor = Color(0xFF242044);
  static const Color mutedColor = Color(0xFF85839A);

  late Future<StaffDashboardModel> dashboardFuture;

  @override
  void initState() {
    super.initState();
    dashboardFuture = StaffDashboardService.getDashboard();
  }

  Future<void> refreshDashboard() async {
    final future = StaffDashboardService.getDashboard();

    setState(() {
      dashboardFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // L'erreur est gérée par le FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Espace administratif',
          style: TextStyle(
            color: darkColor,
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          IconButton(
            onPressed: refreshDashboard,
            icon: const Icon(
              Icons.refresh_rounded,
              color: primaryColor,
              size: 23,
            ),
            tooltip: 'Actualiser',
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: FutureBuilder<StaffDashboardModel>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2.5,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildError('Aucune donnée disponible.');
          }

          return _buildDashboard(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildDashboard(StaffDashboardModel data) {
    final attendance = data.attendance;

    final recorded = attendance.studentsRecorded;
    final attendanceRate = recorded > 0
        ? (attendance.present / recorded).clamp(0.0, 1.0)
        : 0.0;

    return RefreshIndicator(
      onRefresh: refreshDashboard,
      color: primaryColor,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _buildWelcomeCard(data.academicYear),

          const SizedBox(height: 26),

          _buildSectionHeader(
            'Vue d’ensemble',
            trailing: _buildDateChip(),
          ),

          const SizedBox(height: 15),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.48,
            children: [
              _buildStatCard(
                title: 'Élèves inscrits',
                value: data.totalStudents,
                icon: Icons.groups_rounded,
                color: const Color(0xFF792CE0),
                background: const Color(0xFFF2EAFE),
              ),
              _buildStatCard(
                title: 'Classes',
                value: data.totalClassrooms,
                icon: Icons.apartment_rounded,
                color: const Color(0xFF1684D8),
                background: const Color(0xFFE8F3FE),
              ),
              _buildStatCard(
                title: 'Sessions d’appel',
                value: attendance.sessions,
                icon: Icons.calendar_month_rounded,
                color: const Color(0xFF20A66A),
                background: const Color(0xFFE9F8EF),
              ),
              _buildStatCard(
                title: 'Taux de présence',
                value: (attendanceRate * 100).round(),
                suffix: '%',
                icon: Icons.show_chart_rounded,
                color: const Color(0xFFE39A22),
                background: const Color(0xFFFFF4E3),
              ),
            ],
          ),

          const SizedBox(height: 26),

          _buildAttendanceSection(attendance),

          const SizedBox(height: 26),

          _buildSectionHeader('Actions rapides'),

          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.apartment_rounded,
                  label: 'Classes',
                  color: primaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffClassroomsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.event_busy_rounded,
                  label: 'Absences',
                  color: const Color(0xFFE05265),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffAbsenteeismScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.campaign_rounded,
                  label: 'Annonces',
                  color: const Color(0xFF1684D8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffAnnouncementsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          _buildInformationCard(),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WELCOME
  // ------------------------------------------------------------

  Widget _buildWelcomeCard(String? academicYear) {
    return Container(
      height: 156,
      padding: const EdgeInsets.all(21),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6214BE),
            Color(0xFF873BE0),
            Color(0xFF9A50EE),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.17),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -24,
            child: Icon(
              Icons.school_rounded,
              size: 145,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            right: 85,
            top: 5,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 24,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bonjour 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Bienvenue dans votre espace administratif',
                style: TextStyle(
                  color: Color(0xFFE9D9FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      academicYear != null
                          ? 'Année scolaire : $academicYear'
                          : 'Aucune année scolaire active',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
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

  // ------------------------------------------------------------
  // SECTION HEADER
  // ------------------------------------------------------------

  Widget _buildSectionHeader(
    String title, {
    Widget? trailing,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: darkColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildDateChip() {
    final now = DateTime.now();

    final date =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E9FC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: primaryColor,
            size: 13,
          ),
          const SizedBox(width: 6),
          Text(
            date,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // STATISTICS
  // ------------------------------------------------------------

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required Color background,
    String suffix = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value$suffix',
                style: const TextStyle(
                  color: darkColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: mutedColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ATTENDANCE
  // ------------------------------------------------------------

  Widget _buildAttendanceSection(dynamic attendance) {
    final recorded = attendance.studentsRecorded;

    final rate = recorded > 0
        ? (attendance.present / recorded).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFF0EDF7),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF30205A).withValues(alpha: 0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.groups_rounded,
                color: primaryColor,
                size: 23,
              ),
              const SizedBox(width: 9),
              const Text(
                'Présence du jour',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EAFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${attendance.sessions} sessions',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              SizedBox(
                width: 112,
                height: 112,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: rate,
                        strokeWidth: 11,
                        strokeCap: StrokeCap.round,
                        backgroundColor: const Color(0xFFF0EAF9),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          primaryColor,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(rate * 100).round()}%',
                          style: const TextStyle(
                            color: darkColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Présence',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 22),

              Expanded(
                child: Column(
                  children: [
                    _buildAttendanceLegend(
                      'Présents',
                      attendance.present,
                      const Color(0xFF20A66A),
                    ),
                    const SizedBox(height: 15),
                    _buildAttendanceLegend(
                      'Absents',
                      attendance.absent,
                      const Color(0xFFE65C67),
                    ),
                    const SizedBox(height: 15),
                    _buildAttendanceLegend(
                      'Retards',
                      attendance.late,
                      const Color(0xFFE7A12A),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 19),

          Container(
            height: 1,
            color: const Color(0xFFF0EDF5),
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: mutedColor,
              ),
              const SizedBox(width: 7),
              Text(
                '$recorded élève(s) enregistré(s)',
                style: const TextStyle(
                  color: mutedColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceLegend(
    String label,
    int value,
    Color color,
  ) {
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
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF69677F),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            color: darkColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // QUICK ACTIONS
  // ------------------------------------------------------------

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFF0EDF7),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 23,
                ),
              ),
              const SizedBox(height: 11),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: darkColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM INFORMATION
  // ------------------------------------------------------------

  Widget _buildInformationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E9FC),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: primaryColor,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Gardez un œil sur les activités de votre établissement depuis votre espace administratif.',
              style: TextStyle(
                color: Color(0xFF62527C),
                fontSize: 11,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR
  // ------------------------------------------------------------

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: Color(0xFFF2EAFE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 34,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Impossible de charger le tableau de bord',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: mutedColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: refreshDashboard,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
