import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_trip.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/assignment_admin/add_assignment.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/edit_assignment.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/search_field.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'dart:async';

class AssignmentList extends StatefulWidget {
  const AssignmentList({super.key});

  @override
  State<AssignmentList> createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  List<Map<String, dynamic>> assignmentList = [];
  List<Map<String, dynamic>> filteredList = [];
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaCX';
  Timer? _debounce;
  bool showSearchOptions = false;

  Map<String, String> filters = {
    'MaCX': '',
    'MaNV': '',
    'ViTri': '',
    'NgayPhanCong': '',
  };

  @override
  void initState() {
    super.initState();
    fetchAssignments();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        filters[selectedColumn] = searchController.text.trim();
        fetchAssignments();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchAssignments() async {
  final payload = <String, dynamic>{};

  filters.forEach((k, v) {
    if (v.trim().isNotEmpty) {
      if (k == 'NgayPhanCong') {
        payload[k] = v.trim(); // giữ dạng chuỗi yyyy-MM-dd
      } else {
        payload[k] = v.trim();
      }
    }
  });

  final resp = await http.post(
    Uri.parse('$baseURL/phancong/loc'),
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
        assignmentList = list;
        filteredList = list;
      });
    } else {
      print('Lỗi server: ${jsonResp['message']}');
    }
  } else {
    print('Lỗi API phancong/loc: ${resp.statusCode}');
  }
}

  Future<void> exportToPDF(List<dynamic> data) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: ['Mã CX', 'Mã NV', 'Vị trí', 'Ngày phân công'],
            data: data.map((item) {
              return [
                item['MaCX'] ?? '',
                item['MaNV'] ?? '',
                item['ViTri'] ?? '',
                item['NgayPhanCong'] ?? '',
              ];
            }).toList(),
            cellStyle: pw.TextStyle(font: ttf, fontSize: 12),
            headerStyle: pw.TextStyle(font: ttf, fontSize: 14, fontWeight: pw.FontWeight.bold),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mainOrange, width: 1),
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
                          'DANH SÁCH PHÂN CÔNG',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                          filters[selectedColumn] = '';
                          fetchAssignments();
                        },
                        onChanged: (value) {
                          filters[selectedColumn] = value.trim();
                        },
                      ),
                      const SizedBox(height: 16),
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
                            {'label': 'Mã CX', 'value': 'MaCX'},
                            {'label': 'Mã NV', 'value': 'MaNV'},
                            {'label': 'Vị trí', 'value': 'ViTri'},
                            {'label': 'Ngày phân công', 'value': 'NgayPhanCong'},
                          ], 
                          filterValues: filters, 
                          onFilterChanged: (upd) {
                            setState(() {
                              filters = upd;
                              fetchAssignments();
                            });
                          }),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng số: ${filteredList.length}', style: const TextStyle(fontFamily: 'Inter')),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.print),
                                tooltip: 'Xuất PDF',
                                onPressed: () => exportToPDF(filteredList),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm phân công',
                                onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddAssignment()),
                                );
                                },
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
                            columns: const [
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  child: Text('Mã CX', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  child: Text('Mã NV', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 200,
                                  child: Text('Vị trí', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 160,
                                  child: Text('Ngày phân công', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                ),
                              ),
                            ],
                            rows: filteredList.map((item) {
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
                                              builder: (context) => EditAssignment(assignment: item),
                                            ),
                                          );
                                        },
                                        child: Text(item['MaCX'] ?? ''),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: Text(item['MaNV'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 200,
                                      child: Text(item['ViTri'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        (item['NgayPhanCong'] ?? '').toString().split('T').first, // YYYY-MM-DD
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
                        onFirstPressed: () {
                          print("Go to first page");
                        },
                        onLastPressed: () {
                          print("Go to last page");
                        },
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
                  MaterialPageRoute(builder: (_) => ManageTripScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}