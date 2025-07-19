import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/save_button.dart';
import 'package:giao_dien_1/view/admin/support_admin/reply_support_success.dart';

class ReplySupportScreen extends StatefulWidget {
  final Map<String, dynamic> supportItem;

  const ReplySupportScreen({super.key, required this.supportItem});

  @override
  State<ReplySupportScreen> createState() => _ReplySupportScreenState();
}

class _ReplySupportScreenState extends State<ReplySupportScreen> {
  late TextEditingController _replyController;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(
      text: widget.supportItem['CauTraLoi'] ?? '',
    );
  }

  void _handleSave() {
    final updatedReply = _replyController.text.trim();
    // TODO: Gửi dữ liệu cập nhật lên Firebase hoặc API ở đây
    print("Lưu câu trả lời mới: $updatedReply");

    // TODO: Sau khi cập nhật xong, có thể pop hoặc navigate khác
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const SupportAnswerSuccess(),
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
    final data = widget.supportItem;

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
                  'TRẢ LỜI HỖ TRỢ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildReadOnlyInput('Mã hỗ trợ', data['MaHT'], Icons.confirmation_number),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Tiêu đề', data['TieuDe'], Icons.title),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Câu hỏi', data['CauHoi'], Icons.question_answer),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Mã khách hàng', data['MaKH'], Icons.person),
              const SizedBox(height: 16),

              _buildReadOnlyInput('Mã nhân viên', data['MaNV'], Icons.badge),
              const SizedBox(height: 16),

              CustomInputField(
                controller: _replyController,
                labelText: "Câu trả lời",
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