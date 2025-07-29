import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/ticket_admin/edit_ticket.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/config.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaVe';
  bool showSearchOptions = false;
  Timer? _debounce;

  List<Map<String, dynamic>> ticketList = [];
  List<Map<String, dynamic>> filteredList = [];

  Map<String, String> filters = {
    'MaVe': '',
    'LoaiVe': '',
    'ViTriGheNgoi': '',
    'GiaVe': '',
    'TrangThai': '',
    'HinhThucThanhToan': '',
    'MaCX': '',
    'MaKH': '',
  };

  @override
  void initState() {
    super.initState();
    fetchTickets();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        filters[selectedColumn] = searchController.text.trim();
        fetchTickets();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchTickets() async {
  final payload = <String, dynamic>{};
  
  filters.forEach((key, value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      // Các trường cần ép kiểu số
      if (key == 'GiaVe') {
        final number = double.tryParse(trimmed);
        if (number != null) payload[key] = number;
      } else {
        payload[key] = trimmed;
      }
    }
  });

  try {
    final resp = await http.post(
      Uri.parse('$baseURL/ve/loc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode == 200) {
      final jsonResp = jsonDecode(resp.body);
      if (jsonResp['success'] == true) {
        final list = List<Map<String, dynamic>>.from(
          (jsonResp['data'] as List).map((e) => Map<String, dynamic>.from(e)),
        );
        setState(() {
          ticketList = list;
          filteredList = list;
        });
      } else {
        print('❌ Lỗi từ server: ${jsonResp['message']}');
      }
    } else {
      print('❌ Lỗi HTTP khi gọi /ve/loc: ${resp.statusCode}');
    }
  } catch (e) {
    print('❌ Exception khi fetchTickets: $e');
  }
}

  Future<void> exportTicketsToPDF(List<dynamic> tickets) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Table.fromTextArray(
          headers: [
            'Mã vé',
            'SĐT',
            'Tên khách',
            'Tuyến',
            'Ngày đi',
            'Chỗ',
          ],
          data: tickets.map((ticket) {
            return [
              ticket['MaVe'] ?? '',
              ticket['SDT'] ?? '',
              ticket['HoTenKH'] ?? '',
              '${ticket['DiemDi']} - ${ticket['DiemDen']}',
              ticket['NgayDi'] ?? '',
              ticket['GheNgoi'] ?? '',
            ];
          }).toList(),
          cellStyle: pw.TextStyle(font: ttf, fontSize: 11),
          headerStyle: pw.TextStyle(
              font: ttf, fontSize: 13, fontWeight: pw.FontWeight.bold),
          border: pw.TableBorder.all(width: 0.5),
          headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.centerLeft,
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mainOrange),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'DANH SÁCH VÉ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ô tìm kiếm
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Nhập từ khóa...',
                          hintStyle: const TextStyle(fontFamily: 'Inter'),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              filters[selectedColumn] = '';
                              fetchTickets();
                            }),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.mainOrange, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.mainOrange, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) {
                          filters[selectedColumn] = value.trim();
                        },
                      ),

                      const SizedBox(height: 16),

                      // Tùy chọn tìm kiếm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tìm kiếm theo:", style: TextStyle(fontFamily: 'Inter')),
                          IconButton(
                            icon: Icon(showSearchOptions
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() => showSearchOptions = !showSearchOptions);
                            },
                          ),
                        ],
                      ),
                      if (showSearchOptions)
                        FilterChipWithInputInline(
                          filters: [
                            {'label': 'Mã vé', 'value': 'MaVe'},
                            {'label': 'Loại vé', 'value': 'LoaiVe'},
                            {'label': 'Vị trí ghế ngồi', 'value': 'ViTriGheNgoi'},
                            {'label': 'Giá vé', 'value': 'GiaVe'},
                            {'label': 'Trạng thái', 'value': 'TrangThai'},
                            {'label': 'Hình thức thanh toán', 'value': 'HinhThucThanhToan'},
                            {'label': 'Mã CX', 'value': 'MaCX'},
                            {'label': 'Mã NV', 'value': 'MaNV'},
                          ], 
                          filterValues: filters, 
                          onFilterChanged: (upd) {
                            setState(() {
                              filters = upd;
                              fetchTickets();
                            });
                          }),

                      const SizedBox(height: 8),

                      // Thống kê + nút thêm (vô hiệu)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng số: ${filteredList.length}',
                            style: const TextStyle(fontFamily: 'Inter'),
                          ),
                          Row(
                            children: [
                              Tooltip(
                                message: 'In danh sách vé PDF',
                                child: IconButton(
                                  icon: const Icon(Icons.print),
                                  onPressed: () => exportTicketsToPDF(filteredList),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: 'Không thể thêm vé thủ công',
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.grey),
                                  onPressed: null, // Vô hiệu hóa
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dữ liệu hoặc thông báo trống
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mainOrange),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(AppColors.softOrange),
                            columnSpacing: 8,
                            columns: const [
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Mã vé',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Loại vé',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Ghế ngồi',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Giá vé',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Trạng thái',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 130,
                                  child: Text(
                                    'Thanh toán',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Mã CX',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Mã KH',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                            ],
                            rows: filteredList.map((ve) {
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditTicket(ticket: ve),
                                      ),
                                    ).then((_) => fetchTickets());
                                  },
                                  child: Text(
                                    ve['MaVe'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(SizedBox(
                              width: 100,
                              child: Text(ve['LoaiVe'] ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Inter')),
                            )),
                            DataCell(SizedBox(
                              width: 100,
                              child: Text(ve['ViTriGheNgoi'] ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Inter')),
                            )),
                            DataCell(SizedBox(
                              width: 100,
                              child: Text(
                                ve['GiaVe'] != null ? '${ve['GiaVe'].toStringAsFixed(0)}đ' : '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: 'Inter'),
                              ),
                            )),
                            DataCell(SizedBox(
                              width: 120,
                              child: Text(ve['TrangThai'] ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Inter')),
                            )),
                            DataCell(SizedBox(
                              width: 130,
                              child: Text(ve['HinhThucThanhToan'] ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Inter')),
                            )),
                            DataCell(SizedBox(
                              width: 100,
                              child: Text(ve['MaCX'] ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Inter')),
                            )),
                            DataCell(SizedBox(
                              width: 100,
                              child: Text(ve['MaKH'] ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Inter')),
                            )),
                          ],
                        );
                      }).toList(),

                          ),
                        ),
                      ),

                      // Phân trang
                      PaginationControls(
                        currentPage: 1,
                        onFirstPressed: () => print("Go to first page"),
                        onLastPressed: () => print("Go to last page"),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            ExitButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeAdmin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
