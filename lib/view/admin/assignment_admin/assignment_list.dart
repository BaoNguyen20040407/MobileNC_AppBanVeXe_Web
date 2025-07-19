import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/assignment_admin/add_assignment.dart';
import 'package:giao_dien_1/view/admin/assignment_admin/edit_assignment.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/view/admin/home_admin/manage_station.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';

class AssignmentList extends StatefulWidget {
  const AssignmentList({super.key});

  @override
  State<AssignmentList> createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  List<dynamic> assignmentList = [];
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaCX';
  bool showSearchOptions = false;

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    final response = await http.get(Uri.parse('$baseURL/phancong'));
    if (response.statusCode == 200) {
      setState(() {
        assignmentList = jsonDecode(response.body);
      });
    } else {
      print('Lỗi khi lấy dữ liệu');
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
    List<dynamic> filteredList = assignmentList.where((item) {
      final value = (item[selectedColumn] ?? '').toString().toLowerCase();
      final keyword = searchController.text.toLowerCase();
      return value.contains(keyword);
    }).toList();

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
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Nhập từ khóa...',
                          hintStyle: const TextStyle(fontFamily: 'Inter'),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          ),
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
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tìm kiếm theo: ", style: TextStyle(fontFamily: 'Inter')),
                          IconButton(
                            icon: Icon(showSearchOptions ? Icons.expand_less : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                showSearchOptions = !showSearchOptions;
                              });
                            },
                          ),
                        ],
                      ),
                      if (showSearchOptions)
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ChoiceChipSelector(
                                    label: 'Mã CX',
                                    value: 'MaCX',
                                    selectedValue: selectedColumn,
                                    onSelected: (val) => setState(() => selectedColumn = val),
                                  ),
                                  const SizedBox(width: 8),
                                  ChoiceChipSelector(
                                    label: 'Mã NV',
                                    value: 'MaNV',
                                    selectedValue: selectedColumn,
                                    onSelected: (val) => setState(() => selectedColumn = val),
                                  ),
                                  const SizedBox(width: 8),
                                  ChoiceChipSelector(
                                    label: 'Vị trí',
                                    value: 'ViTri',
                                    selectedValue: selectedColumn,
                                    onSelected: (val) => setState(() => selectedColumn = val),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                            dataRowMinHeight: 40,
                            dataRowMaxHeight: 48,
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
                            ],
                            rows: filteredList.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditAssignment(assignment: item)),
                                        );
                                      },
                                      child: Text(item['MaCX'] ?? ''),
                                    ),
                                  ),
                                  DataCell(Text(item['MaNV'] ?? '')),
                                  DataCell(Text(item['ViTri'] ?? '')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () {}, child: const Text("Đầu", style: TextStyle(fontFamily: 'Inter'))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: AppColors.mainOrange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          TextButton(onPressed: () {}, child: const Text("Cuối", style: TextStyle(fontFamily: 'Inter'))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ExitButton(onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}