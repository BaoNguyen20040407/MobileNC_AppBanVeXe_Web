class Ticket {
  final String seatCode;
  final String fullName;
  final String phone;
  final String email;
  final String route;
  final String time;
  final String date;
  final int totalPrice;
  final String pickupPoint;

  Ticket({
    required this.seatCode,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.route,
    required this.time,
    required this.date,
    required this.totalPrice,
    required this.pickupPoint, 
  });

  Map<String, dynamic> toJson() => {
        'seatCode': seatCode,
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'route': route,
        'time': time,
        'date': date,
        'totalPrice': totalPrice,
        'pickupPoint': pickupPoint,
      };

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        seatCode: json['seatCode'],
        fullName: json['fullName'],
        phone: json['phone'],
        email: json['email'],
        route: json['route'],
        time: json['time'],
        date: json['date'],
        totalPrice: json['totalPrice'],
        pickupPoint: json['pickupPoint'],
      );
}
