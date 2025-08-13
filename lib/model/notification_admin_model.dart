class Meeting {
  final String department;
  final String topic;
  final String code;
  final String start;
  final String end;
  final String location;

  Meeting({
    required this.department,
    required this.topic,
    required this.code,
    required this.start,
    required this.end,
    required this.location,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        department: json['department'],
        topic: json['topic'],
        code: json['code'],
        start: json['start'],
        end: json['end'],
        location: json['location'],
      );

  Map<String, dynamic> toJson() => {
        'department': department,
        'topic': topic,
        'code': code,
        'start': start,
        'end': end,
        'location': location,
      };
}

class TripAdminInfo {
  final String title;
  final String sender;
  final String time;
  final Meeting? meeting;

  TripAdminInfo({
    required this.title,
    required this.sender,
    required this.time,
    this.meeting,
  });

  factory TripAdminInfo.fromJson(Map<String, dynamic> json) => TripAdminInfo(
        title: json['title'],
        sender: json['sender'],
        time: json['time'],
        meeting:
            json['meeting'] != null ? Meeting.fromJson(json['meeting']) : null,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'sender': sender,
        'time': time,
        if (meeting != null) 'meeting': meeting!.toJson(),
      };
}