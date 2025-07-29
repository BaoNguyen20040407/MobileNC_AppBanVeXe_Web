import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/view/main/homepage.dart';
import 'package:giao_dien_1/model/ticket.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TicketDetails extends StatefulWidget {
  final String maVe;

  const TicketDetails({super.key, required this.maVe});

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _pickupPoint = '';
  String _dropoffPoint = '';
  String _ngayDi = '';
  String _startTime = '';
  int _totalPrice = 0;
  List<String> _selectedSeats = [];
  String _diemDi = '';
  String _diemDen = '';
  String _phuongThucThanhToan = '';
  String _trangThaiThanhToan = '';

  String formatDate(String rawDate) {
  try {
    final parsedDate = DateTime.parse(rawDate);
    final formatter = DateFormat('dd/MM/yyyy'); // định dạng ngày/tháng/năm
    return formatter.format(parsedDate);
  } catch (e) {
    return rawDate; // Nếu lỗi thì trả về nguyên bản
  }
}

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadAndProcessData());
  }


  Future<void> _loadAndProcessData() async {
  final url = Uri.parse('$baseURL/api/ve/${widget.maVe}');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        _name = data['HoTen'] ?? '';
        _phone = data['DienThoai'] ?? '';
        _email = data['Email'] ?? '';
        _pickupPoint = 'BX Nam Hải - TP. HCM'; // Tuỳ chỉnh nếu API có
        _dropoffPoint = data['DiemDen'] ?? '';
        _ngayDi = data['NgayDi'] ?? '';
        _startTime = data['GioDi'] ?? '';
        _totalPrice = data['GiaVe'] ?? 0;
        _selectedSeats = [data['ViTriGheNgoi'] ?? ''];
        _diemDi = data['DiemDi'] ?? '';
        _diemDen = data['DiemDen'] ?? '';
        _phuongThucThanhToan = data['HinhThucThanhToan'] ?? '---';
        _trangThaiThanhToan = data['TrangThai'] ?? '---';
      });

    } else {
      debugPrint('Lỗi API: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Lỗi gọi API: $e');
  }
}


  Future<void> _saveTicketToPrefs() async {
  if (_selectedSeats.isEmpty) return;

  final prefs = await SharedPreferences.getInstance();

  final ticket = Ticket(
  maVe: _selectedSeats.first,
  seatCode: _selectedSeats.first,
  fullName: _name,
  phone: _phone,
  email: _email,
  time: _startTime,
  date: _ngayDi,
  route: '$_diemDi - $_diemDen',
  totalPrice: _totalPrice,
  pickupPoint: _pickupPoint,
);


  // 1. Lưu theo key riêng (tuỳ chọn, nếu cần phân loại từng vé)
  final ticketKey = 'ticket_${_phone}_${_selectedSeats.first}';
  final ticketJson = jsonEncode(ticket.toJson());
  await prefs.setString(ticketKey, ticketJson);

  // 2. Lưu thêm vào danh sách 'tickets' để các trang lọc đọc được
  final List<String> ticketList = prefs.getStringList('tickets') ?? [];
  ticketList.add(ticketJson);
  await prefs.setStringList('tickets', ticketList);
}

Future<void> _exportTicketToPDF() async {
  final pdf = pw.Document();

  // Load font hỗ trợ tiếng Việt
  final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  final fontData1 = await rootBundle.load('assets/font/inter_18pt_bold.ttf');
  final ttf1 = pw.Font.ttf(fontData1);

  // Load logo
  final logoBytes = await rootBundle.load('assets/image/logovexekhach_1.png');
  final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

  // Tạo QR code
  final qrCodeData = '''
    Họ tên: $_name
    SĐT: $_phone
    Email: $_email
    Tuyến: $_diemDi - $_diemDen
    Ngày đi: $_ngayDi $_startTime
    Ghế: ${_selectedSeats.join(', ')}
    Giá vé: ${formatCurrency(_totalPrice)}
    ''';

  final barcode = Barcode.qrCode();
  final qrSvg = barcode.toSvg(qrCodeData, width: 150, height: 150);

  // Trang PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // Logo căn giữa
            pw.Center(
              child: pw.Image(logoImage, width: 100),
            ),
            pw.SizedBox(height: 16),

            // Tiêu đề căn giữa
            pw.Center(
              child: pw.Text(
                'THÔNG TIN VÉ XE',
                style: pw.TextStyle(font: ttf1, fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 16),

            // Thông tin vé
            pw.Text('Họ tên: $_name', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 8),
            pw.Text('SĐT: $_phone', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 8),
            pw.Text('Email: $_email', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 8),
            pw.Text('Tuyến: $_diemDi - $_diemDen', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 8),
            pw.Text('Thời gian: $_startTime ${formatDate(_ngayDi)}', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 8),
            pw.RichText(
              text: pw.TextSpan(
                text: 'Ghế: ',
                style: pw.TextStyle(
                  font: ttf1,
                  color: PdfColor.fromInt(0xFF006400),
                ),
                children: [
                  pw.TextSpan(
                    text: _selectedSeats.join(', '),
                    style: pw.TextStyle(
                      font: ttf1,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF006400),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text('Giá vé: ${formatCurrency(_totalPrice)}', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 8),
            pw.Text('PTTT: $_phuongThucThanhToan', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 8),
            pw.Text('Trạng thái: $_trangThaiThanhToan', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 24),

            // QR code căn giữa
            pw.Text('Mã QR kiểm tra vé:', style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.SvgImage(svg: qrSvg, width: 150, height: 150),
            ),
          ],
        );
      },
    ),
  );

  try {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi tạo PDF')),
      );
    }
    debugPrint('Lỗi tạo PDF: $e');
  }
}

  Future<void> _loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _name = prefs.getString('full_name') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _email = prefs.getString('email') ?? '';
    _pickupPoint = prefs.getString('pickupPoint') ?? '';
    _dropoffPoint = prefs.getString('dropoffPoint') ?? '';
    _ngayDi = prefs.getString('ngayDi') ?? '';
    _startTime = prefs.getString('startTime') ?? '';
    _totalPrice = prefs.getInt('totalPrice') ?? 0;
    _selectedSeats = prefs.getStringList('selectedSeats') ?? [];
    _diemDi = prefs.getString('diemDi') ?? '';
    _diemDen = prefs.getString('diemDen') ?? '';

  });
}


  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return '${formatter.format(amount)} VND';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.mainOrange, width: 5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'THÔNG TIN VÉ XE',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nhà Xe Nam Hải đã gửi thông tin vé xe qua\ngmail của người dùng',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontFamily: 'Inter', 
                    fontSize: 14,),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vé ${_selectedSeats.isNotEmpty ? _selectedSeats.first : ''}',
                  style: const TextStyle(
                    color: AppColors.greenDark, 
                    fontWeight: FontWeight.bold, 
                    fontFamily: 'Inter'
                  ),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/image/qrcode.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Quý khách vui lòng trình mã QR trên hoặc\nchụp màn hình này để trình trạm soát vé',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14, 
                    fontFamily: 'Inter'
                  ),
                ),
                const SizedBox(height: 16),

                // Thông tin cá nhân
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'THÔNG TIN CÁ NHÂN',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                infoRow('Họ tên:', _name),
                infoRow('SĐT:', _phone),
                infoRow('Email:', _email),
                const SizedBox(height: 16),

                // Thông tin chuyến xe
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'THÔNG TIN CHUYẾN XE',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                infoRow('Tuyến xe:', '$_diemDi - $_diemDen'),
                infoRow('Thời gian:', '$_startTime ${formatDate(_ngayDi)}'),
                infoRow('Số ghế:', _selectedSeats.join(', ')),
                infoRow('Điểm lên xe:', 'BX Nam Hải - TP. HCM'),
                infoRow('Giá vé:', formatCurrency(_totalPrice)),
                const SizedBox(height: 16),

                // Thông tin chuyển khoản
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'THÔNG TIN CHUYỂN KHOẢN',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                infoRow('Giá vé:', formatCurrency(_totalPrice)),
                infoRow('PTTT:', _phuongThucThanhToan),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Trạng thái:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _trangThaiThanhToan,
                          style: TextStyle(
                            color: AppColors.greenDark,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nút In vé PDF
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportTicketToPDF,
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                        label: const Text(
                          'In vé PDF',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenDark,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), // khoảng cách giữa 2 nút

                    // Nút Về trang chủ
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomePage(),
                              settings: const RouteSettings(name: '/home'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.home, color: Colors.white),
                        label: const Text(
                          'Về trang chủ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainOrange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const FooterNavigation(),
    );
  }

  // Widget helper để hiển thị một dòng thông tin
  static Widget infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(width: 4), // khoảng cách giữa tiêu đề và nội dung
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}