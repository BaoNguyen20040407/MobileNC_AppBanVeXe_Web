import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/save_button.dart';
import 'package:giao_dien_1/view/admin/feedback_admin/reply_feedback_success.dart';

class ReplyFeedbackScreen extends StatefulWidget {
  final Map<String, dynamic> feedbackItem;

  const ReplyFeedbackScreen({super.key, required this.feedbackItem});

  @override
  State<ReplyFeedbackScreen> createState() => _ReplyFeedbackScreenState();
}

class _ReplyFeedbackScreenState extends State<ReplyFeedbackScreen> {
  late TextEditingController _replyController;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(
      text: widget.feedbackItem['PhanHoi'] ?? '',
    );
  }

  void _handleSave() {
    final updatedReply = _replyController.text.trim();
    // TODO: Gửi dữ liệu cập nhật lên Firebase hoặc API tại đây
    print("Lưu phản hồi góp ý mới: $updatedReply");

    // Chuyển sang màn hình thông báo thành công
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const FeedbackReplySuccess(),
      ),
    );
  }

  Widget _buildReadOnlyInput(String label, String? value, IconData icon) {
    return CustomInputField(
      controller: TextEditingController(text: value ?? ''),
      labelText: label,
      prefixIcon: icon,
      keyboardType: TextInputType.text,
      readOnly: true,
      showToggleVisibility: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.feedbackItem;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBarAdmin(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'PHẢN HỒI GÓP Ý',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildReadOnlyInput('Mã góp ý', data['MaGY'], Icons.confirmation_number),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Tiêu đề', data['TieuDe'], Icons.title),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Nội dung góp ý', data['NoiDungGopY'], Icons.feedback),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Mã khách hàng', data['MaKH'], Icons.person),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Mã nhân viên', data['MaNV'], Icons.badge),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _replyController,
                labelText: "Phản hồi",
                prefixIcon: Icons.reply,
                keyboardType: TextInputType.multiline,
                showToggleVisibility: false,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: SaveButton(onPressed: _handleSave),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(child: ExitButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
