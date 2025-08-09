import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Hàm load ảnh logo (async)
Future<Uint8List> loadLogoBytes(String path) async {
  final data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}

// Hàm tạo trang PDF, nhận logoBytes đã load sẵn
pw.Page buildPdfPage({
  required pw.Font font,
  required Uint8List logoBytes,
  required String title,
  required List<String> headers,
  required List<List<String>> data,
  required int totalCount,
}) {
  final now = DateTime.now();
  final formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

  return pw.Page(
    build: (context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header: logo + title (logo trái, title căn giữa phần còn lại)
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 100),
              pw.SizedBox(width: 12),
              // Dùng Expanded và Center để tiêu đề căn giữa phần còn lại của hàng
              pw.Expanded(
                child: pw.Center(
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 8),

          // Tổng số bản ghi và thời gian xuất
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Tổng số: $totalCount',
                  style: pw.TextStyle(font: font, fontSize: 12)),
              pw.Text('Xuất lúc: $formattedDate',
                  style: pw.TextStyle(font: font, fontSize: 12)),
            ],
          ),

          pw.SizedBox(height: 12),

          // Bảng dữ liệu với header căn giữa
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            cellStyle: pw.TextStyle(font: font, fontSize: 11),
            headerStyle: pw.TextStyle(
              font: font,
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
            border: pw.TableBorder.all(width: 0.5),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            headerAlignment: pw.Alignment.center, // Căn giữa tiêu đề cột
          ),
        ],
      );
    },
  );
}