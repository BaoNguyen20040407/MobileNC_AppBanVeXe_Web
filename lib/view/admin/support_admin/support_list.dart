import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/search_field.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/support_admin/reply_support.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';

class SupportListScreen extends StatefulWidget {
  const SupportListScreen({super.key});

  @override
  State<SupportListScreen> createState() => _SupportListScreenState();
}

class _SupportListScreenState extends State<SupportListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaHT';
  String filterValue = '';
  Map<String, String> filters = {
  'MaHT': '',
  'TieuDe': '',
  'MaKH': '',
  'MaNV': '',
  };
  bool showSearchOptions = false;

  List<Map<String, dynamic>> supports = [];

  @override
  void initState() {
    super.initState();
    _fetchSupports();
  }

  Future<void> _fetchSupports() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/hotro'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            supports = List<Map<String, dynamic>>.from(json['data']);
          });
        }
      } else {
        print('❌ Server lỗi khi lấy hỗ trợ');
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi gọi API hỗ trợ: $e');
    }
  }

  Future<void> _filterSupports() async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/hotro/loc'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'MaHT': filters['MaHT'] ?? '',
          'TieuDe': filters['TieuDe'] ?? '',
          'CauHoi': '',
          'CauTraLoi': '',
          'MaKH': filters['MaKH'] ?? '',
          'MaNV': filters['MaNV'] ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            supports = List<Map<String, dynamic>>.from(json['data']);
          });
        }
      } else {
        print('❌ Server trả về lỗi khi lọc hỗ trợ');
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi lọc hỗ trợ: $e');
    }
  }

  Future<void> exportSupportsToPDF(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text(
              'Danh sách hỗ trợ',
              style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.Table.fromTextArray(
              headers: ['Mã HT', 'Tiêu đề', 'Câu hỏi', 'Trả lời', 'Mã KH', 'Mã NV'],
              data: data.map((item) {
                return [
                  item['MaHT'] ?? '',
                  item['TieuDe'] ?? '',
                  item['CauHoi'] ?? '',
                  item['CauTraLoi'] ?? '',
                  item['MaKH'] ?? '',
                  item['MaNV'] ?? '',
                ];
              }).toList(),
              cellStyle: pw.TextStyle(font: ttf, fontSize: 10),
              headerStyle: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(width: 0.5),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
                          'HỖ TRỢ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomSearchField(
                        controller: searchController,
                        onClear: () {
                          searchController.clear();
                          _fetchSupports();
                        },
                        onChanged: (_) => _filterSupports(),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tìm kiếm theo:", style: TextStyle(fontFamily: 'Inter')),
                          IconButton(
                            icon: Icon(showSearchOptions ? Icons.expand_less : Icons.expand_more),
                            onPressed: () => setState(() => showSearchOptions = !showSearchOptions),
                          ),
                        ],
                      ),

                      if (showSearchOptions)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilterChipWithInputInline(
                                filters: [
                                  {'label': 'Mã hỗ trợ', 'value': 'MaHT'},
                                  {'label': 'Tiêu đề', 'value': 'TieuDe'},
                                  {'label': 'Khách hàng', 'value': 'MaKH'},
                                  {'label': 'Nhân viên', 'value': 'MaNV'},
                                ],
                                filterValues: filters,
                                onFilterChanged: (updated) {
                                  setState(() => filters = updated);
                                  _filterSupports(); // cập nhật dữ liệu luôn
                                },
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng số: ${supports.length}', style: const TextStyle(fontFamily: 'Inter')),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.print),
                                tooltip: 'Xuất PDF',
                                onPressed: () => exportSupportsToPDF(supports),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Không thể thêm hỗ trợ trực tiếp',
                                onPressed: null,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

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
                            dataRowMinHeight: 44,
                            dataRowMaxHeight: 52,
                            columns: const [
                              DataColumn(label: SizedBox(width: 80, child: Text('Mã HT', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 160, child: Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 250, child: Text('Câu hỏi', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 250, child: Text('Trả lời', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 100, child: Text('Mã KH', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 100, child: Text('Mã NV', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 80, child: Text('Phản hồi', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                            ],
                            rows: supports.map((support) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ReplySupportScreen(supportItem: support),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          support['MaHT'] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(SizedBox(width: 160, child: Text(support['TieuDe'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 250, child: Text(support['CauHoi'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 250, child: Text(support['CauTraLoi'] ?? '', style: const TextStyle(fontFamily: 'Inter', color: AppColors.greenDark)))),
                                  DataCell(SizedBox(width: 100, child: Text(support['MaKH'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 100, child: Text(support['MaNV'] ?? '-', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: InkWell(
                                        onTap: () async {
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ReplySupportScreen(supportItem: support),
                                            ),
                                          );
                                          if (updated == true) {
                                            _fetchSupports(); // refresh lại sau khi phản hồi
                                          }
                                        },
                                        child: const Icon(Icons.reply, color: AppColors.mainOrange),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeAdmin()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
