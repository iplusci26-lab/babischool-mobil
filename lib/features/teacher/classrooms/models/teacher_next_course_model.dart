class TeacherNextCourseModel {

  final String scheduleId;

  final String weekday;

  final String startTime;

  final String endTime;

  final String? room;

  const TeacherNextCourseModel({

    required this.scheduleId,

    required this.weekday,

    required this.startTime,

    required this.endTime,

    this.room,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherNextCourseModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherNextCourseModel(

      scheduleId: json["schedule_id"],

      weekday: json["weekday"],

      startTime: json["start_time"],

      endTime: json["end_time"],

      room: json["room"],

    );

  }

  //----------------------------------------------------------
  // TO JSON
  //----------------------------------------------------------

  Map<String, dynamic> toJson() {

    return {

      "schedule_id": scheduleId,

      "weekday": weekday,

      "start_time": startTime,

      "end_time": endTime,

      "room": room,

    };

  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherNextCourseModel copyWith({

    String? scheduleId,

    String? weekday,

    String? startTime,

    String? endTime,

    String? room,

  }) {

    return TeacherNextCourseModel(

      scheduleId:
          scheduleId ?? this.scheduleId,

      weekday:
          weekday ?? this.weekday,

      startTime:
          startTime ?? this.startTime,

      endTime:
          endTime ?? this.endTime,

      room:
          room ?? this.room,

    );

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  String get period {

    return "$startTime - $endTime";

  }

  bool get hasRoom {

    return room != null &&
        room!.trim().isNotEmpty;

  }

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherNextCourseModel("
        "scheduleId: $scheduleId, "
        "weekday: $weekday, "
        "startTime: $startTime, "
        "endTime: $endTime, "
        "room: $room)";
  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) {

      return true;

    }

    return other is TeacherNextCourseModel &&
        other.scheduleId == scheduleId &&
        other.weekday == weekday &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.room == room;

  }

  @override
  int get hashCode {

    return Object.hash(

      scheduleId,

      weekday,

      startTime,

      endTime,

      room,

    );

  }

}