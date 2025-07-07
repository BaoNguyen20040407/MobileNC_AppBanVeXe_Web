class TripInfo {
  final String from;
  final String to;
  final String seat;
  final String code;
  final String departure;
  final String arrival;

  TripInfo({
    required this.from,
    required this.to,
    required this.seat,
    required this.code,
    required this.departure,
    required this.arrival,
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        from: json['from'],
        to: json['to'],
        seat: json['seat'],
        code: json['code'],
        departure: json['departure'],
        arrival: json['arrival'],
      );
}

class AppNotification {
  final String title;
  final String sender;
  final String time;
  final TripInfo? trip;

  AppNotification({
    required this.title,
    required this.sender,
    required this.time,
    this.trip,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        title: json['title'],
        sender: json['sender'],
        time: json['time'],
        trip: json['trip'] != null ? TripInfo.fromJson(json['trip']) : null,
      );
}
