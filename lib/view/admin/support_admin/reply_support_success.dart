import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/support_admin/support_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class SupportAnswerSuccess extends StatelessWidget {
  const SupportAnswerSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Đã lưu câu trả lời hỗ trợ thành công',
      nextScreen: const SupportListScreen(),
      routeName: '/support',
    );
  }
}
