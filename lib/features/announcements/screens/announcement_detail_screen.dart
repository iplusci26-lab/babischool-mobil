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

  final AnnouncementService service =
      AnnouncementService();

  AnnouncementModel? announcement;

  bool loading = true;

  //--------------------------------------------------

  Future<void> loadAnnouncement() async {

    try {

      announcement =
          await service.getAnnouncement(
        widget.announcementId,
      );

    } catch (e) {

      debugPrint(e.toString());

    }

    if (mounted) {

      setState(() {

        loading = false;

      });

    }

  }

  //--------------------------------------------------

  Future<void> openAttachment() async {

    if (announcement?.attachmentUrl == null) {
      return;
    }

    final uri = Uri.parse(
      announcement!.attachmentUrl!,
    );

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

    }

  }

  //--------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadAnnouncement();

  }

  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Scaffold(

        body: Center(

          child:
              CircularProgressIndicator(),

        ),

      );

    }

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

    return Scaffold(

      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            Colors.transparent,

        foregroundColor:
            Colors.black,

        title: const Text(

          "Annonce",

          style: TextStyle(

            fontWeight:
                FontWeight.bold,

          ),

        ),

      ),

      body: RefreshIndicator(

        onRefresh:
            loadAnnouncement,

        child: ListView(

          padding:
              const EdgeInsets.all(20),

          children: [

            //------------------------------------------------

            Align(

              alignment:
                  Alignment.centerLeft,

              child: PriorityBadge(

                priority:
                    announcement!.priority,

              ),

            ),

            const SizedBox(
              height: 18,
            ),

            //------------------------------------------------

            Text(

              announcement!.title,

              style: const TextStyle(

                fontSize: 28,

                fontWeight:
                    FontWeight.bold,

              ),

            ),

            const SizedBox(
              height: 10,
            ),

            //------------------------------------------------

            Row(

              children: [

                const Icon(

                  Icons.person,

                  size: 18,

                  color: Colors.grey,

                ),

                const SizedBox(
                  width: 6,
                ),

                Expanded(

                  child: Text(

                    announcement!.createdBy,

                    style: TextStyle(

                      color:
                          Colors.grey.shade700,

                    ),

                  ),

                ),

              ],

            ),

            const SizedBox(
              height: 6,
            ),

            Row(

              children: [

                const Icon(

                  Icons.schedule,

                  size: 18,

                  color: Colors.grey,

                ),

                const SizedBox(
                  width: 6,
                ),

                Text(

                  DateFormat(

                    "dd/MM/yyyy à HH:mm",

                  ).format(

                    announcement!
                        .publishAt,

                  ),

                  style: TextStyle(

                    color:
                        Colors.grey.shade700,

                  ),

                ),

              ],

            ),

            const SizedBox(
              height: 24,
            ),

            //------------------------------------------------

            Container(

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),

              ),

              child: Text(

                announcement!.content,

                style: const TextStyle(

                  height: 1.6,

                  fontSize: 16,

                ),

              ),

            ),

            //------------------------------------------------

            if (announcement!
                    .attachmentUrl !=
                null) ...[

              const SizedBox(
                height: 28,
              ),

              const Text(

                "Pièce jointe",

                style: TextStyle(

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

              const SizedBox(
                height: 14,
              ),

              AttachmentTile(

                fileName:
                    announcement!
                        .attachmentUrl!
                        .split("/")
                        .last,

                onTap:
                    openAttachment,

              ),

            ],

            const SizedBox(
              height: 30,
            ),

          ],

        ),

      ),

    );

  }

}