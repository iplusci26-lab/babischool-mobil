import 'package:flutter/material.dart';

import '../../shared/models/notification_model.dart';

import 'notification_service.dart';

import 'widgets/notification_tile.dart';

class NotificationScreen
extends StatefulWidget {

  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen>
  createState() =>
  _NotificationScreenState();
}

class _NotificationScreenState
extends State<NotificationScreen> {

  List<NotificationModel>
  notifications = [];

  bool loading = true;

  Future<void> loadData()
  async {

    final data =

    await NotificationService()
    .getNotifications();

    notifications =

    data.map<NotificationModel>(
      (e) =>
      NotificationModel.fromJson(
        e,
      ),
    ).toList();

    setState(() {

      loading = false;
    });
  }

  @override
  void initState() {

    super.initState();

    loadData();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Notifications",
        ),

        centerTitle: false,

        elevation: 0,

        backgroundColor:
            const Color(
          0xffF7F8FC,
        ),
      ),

      body:

      loading

      ? const Center(
          child:
          CircularProgressIndicator(),
        )

      : RefreshIndicator(

          onRefresh:
          loadData,

          child: ListView.builder(

            itemCount:
            notifications.length,

            itemBuilder:
            (_, index) {

              return NotificationTile(

                notification:
                notifications[index],
              );
            },
          ),
        ),
    );
  }
}