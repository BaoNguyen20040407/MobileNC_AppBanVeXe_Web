import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/ticket.dart';
import 'package:giao_dien_1/config/default.dart';

class TicketInfoWidget extends StatelessWidget {
  final Ticket ticket;

  const TicketInfoWidget({super.key, required this.ticket});

  String formatCurrency(num amount) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
    return format.format(amount).replaceAll('\u00A0', '');
  }

  String _add7HoursToTime(String rawTime) {
  try {
    // Giả sử `rawTime` là định dạng "HH:mm"
    final parts = rawTime.split(':');
    if (parts.length != 2) return rawTime;

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final originalTime = DateTime(0, 1, 1, hour, minute);
    final adjustedTime = originalTime.add(const Duration(hours: 7));

    final formatted = DateFormat('HH:mm').format(adjustedTime);
    return formatted;
  } catch (e) {
    return rawTime;
  }
}

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final parts = ticket.route.split(' - ');
    final diemDi = parts.isNotEmpty ? parts[0] : '';
    final diemDen = parts.length > 1 ? parts[1] : '';

    return Row(
      children: [
        Column(
          children: [
            Image.asset(
              'assets/image/qrcode.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(height: 4),
            const Text(
              'Số ghế',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.greenDark,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.seatCode,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Tuyến xe', '$diemDi $diemDen'),
              const SizedBox(height: 4),
              _infoRow('Thời gian', '${_add7HoursToTime(ticket.time)} ${ticket.date}'),
              const SizedBox(height: 4),
              _infoRow('Điểm lên xe', ticket.pickupPoint),
              const SizedBox(height: 4,),
              _infoRow('Giá vé', '${formatCurrency(ticket.totalPrice)} VND'),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }
}
