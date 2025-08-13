import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_ticket.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanFromImageScreen extends StatefulWidget {
  const QRScanFromImageScreen({Key? key}) : super(key: key);

  @override
  State<QRScanFromImageScreen> createState() => _QRScanFromImageScreenState();
}

class _QRScanFromImageScreenState extends State<QRScanFromImageScreen> {
  final ImagePicker _picker = ImagePicker();
  String? qrData;
  bool isLoading = false;

  Future<void> pickImageAndScanQR() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        isLoading = true;
        qrData = null;
      });

      final String? result = await QrCodeToolsPlugin.decodeFrom(image.path);

      setState(() {
        qrData = result ?? 'Không tìm thấy mã QR trong ảnh.';
      });
    } catch (e) {
      setState(() {
        qrData = 'Lỗi khi đọc mã QR: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> scanQRFromCamera() async {
  final String? scannedData = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: MobileScanner(
          onDetect: (barcodeCapture) {
            final List<Barcode> barcodes = barcodeCapture.barcodes;
            if (barcodes.isNotEmpty) {
              Navigator.pop(context, barcodes.first.rawValue ?? '');
            }
          },
        ),
      ),
    ),
  );

  if (scannedData != null && scannedData.isNotEmpty) {
    setState(() {
      isLoading = false;
      qrData = scannedData;
    });
  }
}

  void confirmTicket() {
    if (qrData == null || qrData!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có dữ liệu mã QR để xác nhận.')),
      );
      return;
    }
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0), // Giảm khoảng cách nội dung - nút
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // Giữ khoảng cách nhỏ gọn
      title: const Text(
        'Xác nhận vé',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.mainOrange,
          fontFamily: 'Inter',
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          'Thông tin vé:\n$qrData',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            color: Colors.black,
            height: 1.4,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Đóng',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              color: AppColors.mainOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Xác nhận vé thành công!', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),),
                backgroundColor: AppColors.greenDark,
              ),
            );
          },
          child: const Text('Xác nhận'),
        ),
      ],
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'QUÉT VÉ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onPressed: pickImageAndScanQR,
                    icon: const Icon(Icons.photo_library, size: 24),
                    label: const Text(
                      'Chọn ảnh',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onPressed: scanQRFromCamera,
                    icon: const Icon(Icons.qr_code_scanner, size: 24),
                    label: const Text(
                      'Quét camera',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (isLoading) ...[
              const CircularProgressIndicator(color: AppColors.mainOrange),
              const SizedBox(height: 16),
              const Text(
                'Đang xử lý ảnh...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ] else if (qrData != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainOrange, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.mainOrange.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin mã QR:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.mainOrange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 165,
                      child: SingleChildScrollView(
                        child: SelectableText(
                          qrData!,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onPressed: confirmTicket,
                      icon: const Icon(Icons.check_circle_outline, size: 24),
                      label: const Text('Xác nhận với khách'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ExitButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => ManageTicketScreen()),
                      );
                    },
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'Chưa có dữ liệu. Vui lòng chọn ảnh để quét mã QR.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 16),
              ExitButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ManageTicketScreen()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
