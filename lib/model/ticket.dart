import 'package:intl/intl.dart';

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

  factory Ticket.fromJson(Map<String, dynamic> json) {
    final thoiGianDi = DateTime.tryParse(json['ThoiGianDi'] ?? '');
    final date = thoiGianDi != null ? DateFormat('dd/MM/yyyy').format(thoiGianDi) : '';
    final time = thoiGianDi != null ? DateFormat('HH:mm').format(thoiGianDi) : '';

    return Ticket(
      seatCode: json['ViTriGheNgoi'] ?? '',
      fullName: json['HoTen'] ?? 'Không rõ',
      phone: json['SoDienThoai'] ?? '',
      email: json['Email'] ?? '',
      route: '${(json['DiemDi'] ?? '').toString().trim()} → ${(json['DiemDen'] ?? '').toString().trim()}',
      time: time,
      date: date,
      totalPrice: json['GiaVe'] ?? 0,
      pickupPoint: (json['DiemDi'] ?? '').toString().trim(), // gán DiemDi là điểm đón
  );
  }
}
