import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/ticket_admin/ticket_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class SupportAnswerSuccess extends StatelessWidget {
  const SupportAnswerSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Đã lưu thông tin vé thành công',
      nextScreen: const TicketListScreen(),
      routeName: '/support',
    );
  }
}
