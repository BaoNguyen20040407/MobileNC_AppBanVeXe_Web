import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/feedback_admin/feedback_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class FeedbackReplySuccess extends StatelessWidget {
  const FeedbackReplySuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Đã lưu phản hồi góp ý thành công',
      nextScreen: const FeedbackListScreen(),
      routeName: '/feedback',
    );
  }
}
