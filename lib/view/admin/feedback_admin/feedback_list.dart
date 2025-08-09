import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/search_field.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/feedback_admin/reply_feedback.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:giao_dien_1/widget/build_pdf_page.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaGY';
  String filterValue = '';
  Map<String, String> filters = {
    'MaGY': '',
    'MaKH': '',
    'MaNV': '',
  };
  bool showSearchOptions = false;

  List<Map<String, dynamic>> feedbacks = [];

  @override
  void initState() {
    super.initState();
    _fetchFeedbacks();
  }

  Future<void> _fetchFeedbacks() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/gopy'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            feedbacks = List<Map<String, dynamic>>.from(json['data']);
          });
        }
      } else {
        print('❌ Server lỗi khi lấy góp ý');
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi gọi API góp ý: $e');
    }
  }

Future<void> exportFeedbackToPDF(List<Map<String, dynamic>> data) async {
  try {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final logoBytes = await loadLogoBytes('assets/image/logovexekhach_1.png');

    final tableData = data.map((item) {
      return [
        item['MaGY']?.toString() ?? '',
        item['TieuDe']?.toString() ?? '',
        item['NoiDungGopY']?.toString() ?? '',
        item['PhanHoi']?.toString() ?? '',
        item['MaKH']?.toString() ?? '',
        item['MaNV']?.toString() ?? '',
      ];
    }).toList();

    final page = buildPdfPage(
      font: ttf,
      logoBytes: logoBytes,
      title: 'DANH SÁCH GÓP Ý',
      headers: ['Mã GY', 'Tiêu đề', 'Nội dung', 'Phản hồi', 'Mã KH', 'Mã NV'],
      data: tableData,
      totalCount: data.length,
    );

    pdf.addPage(page);

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  } catch (e, stacktrace) {
    print('Lỗi khi tạo PDF danh sách góp ý: $e');
    print('Stacktrace: $stacktrace');
  }
}

  Future<void> _filterFeedbacks() async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/gopy/loc'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'MaGY': filters['MaGY'] ?? '',
          'TieuDe': filters['TieuDe'] ?? '',
          'MaKH': filters['MaKH'] ?? '',
          'MaNV': filters['MaNV'] ?? '',
        })
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            feedbacks = List<Map<String, dynamic>>.from(json['data']);
          });
        }
      }
      else {
        print('❌ Server trả về lỗi khi lọc hỗ trợ');
      }
    }
    catch (e) {
      print('❌ Lỗi kết nối khi lọc hỗ trợ: $e');
    }
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
                          'GÓP Ý',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tìm kiếm
                      CustomSearchField(
                        controller: searchController,
                        onClear: () {
                          searchController.clear();
                          _fetchFeedbacks();
                        },
                        onChanged: (_) => _filterFeedbacks(),
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
                                  {'label': 'Mã góp ý', 'value': 'MaGY'},
                                  {'label': 'Tiêu đề', 'value': 'TieuDe'},
                                  {'label': 'Mã khách hàng', 'value': 'MaKH'},
                                  {'label': 'Mã nhân viên', 'value': 'MaNV'},
                                ], 
                                filterValues: filters, 
                                onFilterChanged: (updated) {
                                  setState(() => filters = updated);
                                  _filterFeedbacks(); 
                                },
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng số: ${feedbacks.length}',
                            style: const TextStyle(fontFamily: 'Inter'),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.print),
                                tooltip: 'Xuất PDF góp ý',
                                onPressed: () async {
                                  await exportFeedbackToPDF(feedbacks);
                                },
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: 'Không thể thêm góp ý trực tiếp',
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.grey),
                                  onPressed: null,
                                ),
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
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  child: Text('Mã GY', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 160,
                                  child: Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 250,
                                  child: Text('Nội dung', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 250,
                                  child: Text('Phản hồi', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text('Mã KH', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text('Mã NV', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  child: Text('Phản hồi', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                            ],
                            rows: feedbacks.map((feedback) {
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
                                              builder: (_) => ReplyFeedbackScreen(feedbackItem: feedback),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          feedback['MaGY'] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(SizedBox(width: 160, child: Text(feedback['TieuDe'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 250, child: Text(feedback['NoiDungGopY'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 250, child: Text(feedback['PhanHoi'] ?? '', style: const TextStyle(fontFamily: 'Inter', color: AppColors.greenDark)))),
                                  DataCell(SizedBox(width: 100, child: Text(feedback['MaKH'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 100, child: Text(feedback['MaNV'] ?? '-', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ReplyFeedbackScreen(feedbackItem: feedback),
                                            ),
                                          );
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