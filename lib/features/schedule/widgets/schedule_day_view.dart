import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_view.dart';

import '../models/schedule_day_model.dart';
import 'schedule_card.dart';

class ScheduleDayView extends StatelessWidget {

  final ScheduleDayModel day;

  const ScheduleDayView({

    super.key,

    required this.day,

  });

  @override
  Widget build(BuildContext context) {

    if (day.courses.isEmpty) {

      return const EmptyView(

        title: "Aucun cours",

        message:
            "Aucun cours programmé pour cette journée.",

        icon: Icons.event_busy,

      );

    }

    return ListView.builder(

      padding: const EdgeInsets.only(

        top: 12,

        left: 20,

        right: 20,

        bottom: 30,

      ),

      itemCount: day.courses.length,

      itemBuilder: (context, index) {

        return ScheduleCard(

          course: day.courses[index],

        );

      },

    );

  }

}