import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/config.dart';
import 'package:intl/intl.dart';

class RevenueDialog extends StatefulWidget {
  const RevenueDialog({super.key});

  @override
  State<RevenueDialog> createState() => _RevenueDialogState();
}

class _RevenueDialogState extends State<RevenueDialog> {
  DateTime? startDate;
  DateTime? endDate;
  Map<String, dynamic>? revenueData;
  bool isLoading = false;

String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}-"
         "${date.month.toString().padLeft(2, '0')}-"
         "${date.year}";
}

Future<void> _fetchRevenue() async {
  if (startDate == null || endDate == null) {
    print("⚠️ Chưa chọn đủ ngày bắt đầu và ngày kết thúc");
    return;
  }

  setState(() => isLoading = true);

  final startStr = _formatDate(startDate!);
  final endStr = _formatDate(endDate!);

  final url = '$baseURL/thongke/doanhthu?startDate=$startStr&endDate=$endStr';
  print("🔍 Fetch doanh thu: $url");

  try {
    final resp = await http.get(Uri.parse(url));

    print("📥 Status code: ${resp.statusCode}");
    print("📥 Response body: ${resp.body}");

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);

      if (data['success'] == true) {
        print("✅ Dữ liệu doanh thu: ${data['data']}");
        setState(() => revenueData = data['data']);
      } else {
        print("⚠️ API trả về success=false: ${data['message']}");
      }
    } else {
      print("❌ HTTP Error: ${resp.statusCode} - ${resp.reasonPhrase}");
    }
  } catch (e, s) {
    print('❌ Lỗi fetchRevenue: $e');
    print('📌 Stack trace:\n$s');
  }

  setState(() => isLoading = false);
}

  Future<DateTime?> _pickDate(BuildContext context, DateTime? initial) {
  return showDatePicker(
    context: context,
    initialDate: initial ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFFF5722), // Màu tiêu đề & nút OK
            onPrimary: Colors.white, // Màu chữ trên nền primary
            onSurface: Colors.black, // Màu chữ ngày
          ),
          dialogBackgroundColor: Colors.white, // Nền DatePicker
        ),
        child: child!,
      );
    },
  );
}

  Widget _orangeButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)),
      ),
    );
  }

  Widget _orangeButton2(String text, VoidCallback? onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainOrange.withOpacity(onPressed == null ? 0.5 : 1),
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Thống kê doanh thu',
        style: TextStyle(
          color: Color(0xFFFF5722),
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _orangeButton(
              startDate == null
                  ? 'Chọn ngày bắt đầu'
                  : 'Bắt đầu: ${_formatDate(startDate!)}',
              () async {
                final picked = await _pickDate(context, startDate);
                if (picked != null) setState(() => startDate = picked);
              },
            ),
            const SizedBox(height: 8),
            _orangeButton(
              endDate == null
                  ? 'Chọn ngày kết thúc'
                  : 'Kết thúc: ${_formatDate(endDate!)}',
              () async {
                final picked = await _pickDate(context, endDate);
                if (picked != null) setState(() => endDate = picked);
              },
            ),
            const SizedBox(height: 12),
            _orangeButton2('Xem thống kê', _fetchRevenue),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(color: Color(0xFFFF5722)),
            if (!isLoading && revenueData != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDE5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFF5722)),
                ),
                child: Text(
                  'Tổng doanh thu: ${NumberFormat('#,###', 'vi_VN').format(revenueData!['tongDoanhThu'] ?? 0)} VNĐ\n'
                  'Tổng vé: ${revenueData!['tongVe']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.redRevenue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: _orangeButton(
                'Hủy',
                () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _orangeButton2(
                'Xuất PDF',
                startDate != null && endDate != null && revenueData != null
                    ? () => Navigator.pop(context, {
                          'start': startDate,
                          'end': endDate,
                          'revenue': revenueData
                        })
                    : null, // null để disable nút
              ),
            ),
          ],
        ),
      ],

    );
  }
}