
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/staff_announcement_model.dart';
import 'services/staff_announcement_service.dart';
import 'screens/staff_announcement_form_screen.dart';

class StaffAnnouncementsScreen extends StatefulWidget {
  const StaffAnnouncementsScreen({super.key});

  @override
  State<StaffAnnouncementsScreen> createState() =>
      _StaffAnnouncementsScreenState();
}

class _StaffAnnouncementsScreenState
    extends State<StaffAnnouncementsScreen> {
  static const Color primaryColor = Color(0xFF6214BE);
  static const Color backgroundColor = Color(0xFFF8F8FD);
  static const Color darkColor = Color(0xFF292640);
  static const Color mutedColor = Color(0xFF85839A);

  late Future<List<StaffAnnouncementModel>> announcementsFuture;

  @override
  void initState() {
    super.initState();
    announcementsFuture = StaffAnnouncementService.getAnnouncements();
  }

  Future<void> _refresh() async {
    final future = StaffAnnouncementService.getAnnouncements();

    setState(() {
      announcementsFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // L'erreur est affichée dans FutureBuilder.
    }
  }

  Future<void> _openCreateForm() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const StaffAnnouncementFormScreen(),
      ),
    );

    if (result == true && mounted) {
      await _refresh();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date inconnue';

    return DateFormat(
      'dd/MM/yyyy à HH:mm',
      'fr_FR',
    ).format(date.toLocal());
  }

  // ------------------------------------------------------------
  // PRIORITY COLORS
  // ------------------------------------------------------------

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFE53945);
      case 'important':
        return const Color(0xFFE69A18);
      default:
        return const Color(0xFF269B55);
    }
  }

  Color _priorityBackground(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFFFEFF0);
      case 'important':
        return const Color(0xFFFFF6E8);
      default:
        return const Color(0xFFF0F9F1);
    }
  }

  Color _priorityBorder(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFE94B55);
      case 'important':
        return const Color(0xFFEBA324);
      default:
        return const Color(0xFF55B96B);
    }
  }

  // ------------------------------------------------------------
  // SUMMARY
  // ------------------------------------------------------------

  Widget _buildSummary(
    List<StaffAnnouncementModel> announcements,
  ) {
    final urgentCount = announcements
        .where((item) => item.priority.toLowerCase() == 'urgent')
        .length;

    return Container(
      height: 145,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6214BE),
            Color(0xFF7810D5),
            Color(0xFF9029E8),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.16),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -35,
            child: Icon(
              Icons.campaign_rounded,
              size: 145,
              color: Colors.white.withValues(alpha: 0.13),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  Icons.campaign_outlined,
                  announcements.length.toString(),
                  'Annonces publiées',
                ),
              ),
              Container(
                height: 65,
                width: 1,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              Expanded(
                child: _summaryItem(
                  Icons.priority_high_rounded,
                  urgentCount.toString(),
                  'Urgentes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFE9D9FF),
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PRIORITY BADGE
  // ------------------------------------------------------------

  Widget _buildPriorityBadge(
    StaffAnnouncementModel announcement,
  ) {
    final color = _priorityColor(announcement.priority);
    final background = _priorityBackground(
      announcement.priority,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            announcement.priorityLabel,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ANNOUNCEMENT CARD
  // ------------------------------------------------------------

  Widget _buildAnnouncementCard(
    StaffAnnouncementModel announcement,
  ) {
    final background = _priorityBackground(
      announcement.priority,
    );

    final borderColor = _priorityBorder(
      announcement.priority,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF30205A).withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                color: borderColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    15,
                    16,
                    15,
                    14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and priority
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.75,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.campaign_rounded,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 11),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  announcement.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: darkColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  announcement.categoryLabel,
                                  style: const TextStyle(
                                    color: mutedColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 5),
                          _buildPriorityBadge(announcement),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Content
                      Text(
                        announcement.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF666477),
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Target
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.65,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.people_outline_rounded,
                              color: primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                announcement.targetLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: darkColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 13),

                      // Date and options
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: mutedColor,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              _formatDate(announcement.publishAt),
                              style: const TextStyle(
                                color: mutedColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          if (announcement.sendNotification)
                            const Tooltip(
                              message: 'Notification activée',
                              child: Icon(
                                Icons.notifications_active_outlined,
                                color: primaryColor,
                                size: 19,
                              ),
                            ),

                          if (announcement.attachment != null &&
                              announcement.attachment!.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.only(left: 11),
                              child: Tooltip(
                                message: 'Pièce jointe disponible',
                                child: Icon(
                                  Icons.attach_file_rounded,
                                  color: primaryColor,
                                  size: 19,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: const BoxDecoration(
                color: Color(0xFFF0E9FC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                size: 39,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Aucune annonce publiée',
              style: TextStyle(
                color: darkColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Les annonces de votre établissement apparaîtront ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _openCreateForm,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Créer une annonce'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR
  // ------------------------------------------------------------

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                color: primaryColor,
                size: 35,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Impossible de charger les annonces',
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
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
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

  // ------------------------------------------------------------
  // MAIN SCREEN
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Annonces',
          style: TextStyle(
            color: darkColor,
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refresh,
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

      // Circular floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateForm,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
        tooltip: 'Nouvelle annonce',
        child: const Icon(
          Icons.add_rounded,
          size: 34,
        ),
      ),

      body: FutureBuilder<List<StaffAnnouncementModel>>(
        future: announcementsFuture,
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

          final announcements = snapshot.data ?? [];

          if (announcements.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              color: primaryColor,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: _buildEmptyState(),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            color: primaryColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),
              children: [
                _buildSummary(announcements),

                const SizedBox(height: 25),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Historique des annonces',
                        style: TextStyle(
                          color: darkColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E9FC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${announcements.length} annonce(s)',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                ...announcements.map(_buildAnnouncementCard),
              ],
            ),
          );
        },
      ),
    );
  }
}
