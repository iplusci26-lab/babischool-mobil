import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/announcement_model.dart';
import '../services/announcement_service.dart';
import '../widgets/attachment_tile.dart';
import '../widgets/priority_badge.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final String announcementId;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcementId,
  });

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState
    extends State<AnnouncementDetailScreen> {
  final AnnouncementService service = AnnouncementService();

  AnnouncementModel? announcement;

  bool loading = true;

  // ============================================================
  // CHARGEMENT DE L'ANNONCE
  // ============================================================

  Future<void> loadAnnouncement() async {
    try {
      announcement = await service.getAnnouncement(
        widget.announcementId,
      );
    } catch (e) {
      debugPrint(
        "Erreur lors du chargement de l'annonce : $e",
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  // ============================================================
  // DÉTERMINE SI LA PIÈCE JOINTE EST UNE IMAGE
  // ============================================================

  bool get isImageAttachment {
    final url = announcement?.attachmentUrl;

    if (url == null || url.isEmpty) {
      return false;
    }

    final cleanUrl = url.split("?").first.toLowerCase();

    return cleanUrl.endsWith(".jpg") ||
        cleanUrl.endsWith(".jpeg") ||
        cleanUrl.endsWith(".png") ||
        cleanUrl.endsWith(".webp") ||
        cleanUrl.endsWith(".gif");
  }

  // ============================================================
  // NOM DU FICHIER
  // ============================================================

  String get attachmentFileName {
    final url = announcement?.attachmentUrl;

    if (url == null || url.isEmpty) {
      return "Pièce jointe";
    }

    final cleanUrl = url.split("?").first;

    return Uri.decodeComponent(
      cleanUrl.split("/").last,
    );
  }

  // ============================================================
  // OUVRIR UNE PIÈCE JOINTE NON IMAGE
  // ============================================================

  Future<void> openAttachment() async {
    final attachmentUrl = announcement?.attachmentUrl;

    if (attachmentUrl == null || attachmentUrl.isEmpty) {
      return;
    }

    final uri = Uri.parse(attachmentUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Impossible d'ouvrir cette pièce jointe.",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint(
        "Erreur lors de l'ouverture de la pièce jointe : $e",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Impossible d'ouvrir cette pièce jointe.",
          ),
        ),
      );
    }
  }

  // ============================================================
  // AFFICHER L'IMAGE EN GRAND
  // ============================================================

  void openImagePreview() {
    final attachmentUrl = announcement?.attachmentUrl;

    if (attachmentUrl == null || attachmentUrl.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.92),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              // ==================================================
              // IMAGE
              // ==================================================

              Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Image.network(
                    attachmentUrl,

                    // ------------------------------------------------
                    // CHARGEMENT DE L'IMAGE
                    // ------------------------------------------------

                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      final expected =
                          loadingProgress.expectedTotalBytes;

                      final loaded =
                          loadingProgress.cumulativeBytesLoaded;

                      final progress = expected != null
                          ? loaded / expected
                          : null;

                      return SizedBox(
                        width: 80,
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },

                    // ------------------------------------------------
                    // ERREUR DE CHARGEMENT
                    // ------------------------------------------------

                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 60,
                              color: Colors.red,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Impossible de charger l'image.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ==================================================
              // BOUTON FERMER
              // ==================================================

              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.black.withOpacity(0.55),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder:
                        const CircleBorder(),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // INITIALISATION
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadAnnouncement();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // CHARGEMENT DE L'ANNONCE
    // ==========================================================

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xff6214BE),
          ),
        ),
      );
    }

    // ==========================================================
    // ERREUR
    // ==========================================================

    if (announcement == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text(
            "Impossible de charger cette annonce.",
          ),
        ),
      );
    }

    // ==========================================================
    // CONTENU
    // ==========================================================

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,

        title: const Text(
          "Annonce",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: RefreshIndicator(
        onRefresh: loadAnnouncement,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            // ====================================================
            // PRIORITÉ
            // ====================================================

            Align(
              alignment: Alignment.centerLeft,
              child: PriorityBadge(
                priority: announcement!.priority,
              ),
            ),

            const SizedBox(height: 18),

            // ====================================================
            // TITRE
            // ====================================================

            Text(
              announcement!.title,

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ====================================================
            // AUTEUR
            // ====================================================

            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    announcement!.createdBy,

                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ====================================================
            // DATE
            // ====================================================

            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 18,
                  color: Colors.grey,
                ),

                const SizedBox(width: 6),

                Text(
                  DateFormat(
                    "dd/MM/yyyy à HH:mm",
                  ).format(
                    announcement!.publishAt,
                  ),

                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ====================================================
            // CONTENU
            // ====================================================

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: Text(
                announcement!.content,

                style: const TextStyle(
                  height: 1.6,
                  fontSize: 16,
                ),
              ),
            ),

            // ====================================================
            // PIÈCE JOINTE
            // ====================================================

            if (announcement!.attachmentUrl != null &&
                announcement!.attachmentUrl!.isNotEmpty) ...[
              const SizedBox(height: 28),

              const Text(
                "Pièce jointe",

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // IMAGE
              // ==================================================

              if (isImageAttachment)
                GestureDetector(
                  onTap: openImagePreview,

                  child: Container(
                    width: double.infinity,

                    height: 230,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(18),

                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),

                    clipBehavior:
                        Clip.antiAlias,

                    child: Stack(
                      alignment:
                          Alignment.center,

                      children: [
                        // ----------------------------------------
                        // IMAGE AVEC CHARGEMENT
                        // ----------------------------------------

                        Image.network(
                          announcement!.attachmentUrl!,

                          width: double.infinity,
                          height: double.infinity,

                          fit: BoxFit.cover,

                          loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                          ) {
                            if (loadingProgress ==
                                null) {
                              return child;
                            }

                            final expected =
                                loadingProgress
                                    .expectedTotalBytes;

                            final loaded =
                                loadingProgress
                                    .cumulativeBytesLoaded;

                            final progress =
                                expected != null
                                    ? loaded / expected
                                    : null;

                            return Center(
                              child: SizedBox(
                                width: 45,
                                height: 45,

                                child:
                                    CircularProgressIndicator(
                                  value: progress,
                                  color:
                                      const Color(
                                    0xff6214BE,
                                  ),
                                ),
                              ),
                            );
                          },

                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,

                                children: [
                                  Icon(
                                    Icons
                                        .broken_image_outlined,
                                    size: 50,
                                    color:
                                        Colors.grey,
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Text(
                                    "Impossible de charger l'image.",
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // ----------------------------------------
                        // ICÔNE POUR INDIQUER QUE L'IMAGE
                        // EST CLIQUABLE
                        // ----------------------------------------

                        Positioned(
                          right: 12,
                          bottom: 12,

                          child: Container(
                            padding:
                                const EdgeInsets.all(
                              9,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors.black
                                  .withOpacity(
                                0.55,
                              ),

                              shape:
                                  BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons
                                  .fullscreen,
                              color:
                                  Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              // ==================================================
              // AUTRE TYPE DE FICHIER
              // ==================================================

              else
                AttachmentTile(
                  fileName:
                      attachmentFileName,

                  onTap:
                      openAttachment,
                ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}