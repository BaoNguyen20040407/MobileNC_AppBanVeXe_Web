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
              _infoRow('Tuyến xe', ticket.route),
              const SizedBox(height: 4),
              _infoRow('Thời gian', '${ticket.time} ${ticket.date}'),
              const SizedBox(height: 4),
              _infoRow('Điểm đi', 'BX Nam Hải - ${ticket.pickupPoint}'),
              const SizedBox(height: 4),
              _infoRow('Giá vé', '${formatCurrency(ticket.totalPrice)} VND'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
