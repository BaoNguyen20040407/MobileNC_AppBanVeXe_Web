import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/view/admin/home_admin/manage_trip.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/view/admin/stop_admin/add_stop.dart';
import 'package:giao_dien_1/view/admin/stop_admin/edit_stop.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'dart:async';

class StopList extends StatefulWidget {
  const StopList({super.key});

  @override
  State<StopList> createState() => _StopListState();
}

class _StopListState extends State<StopList> {
  List<Map<String, dynamic>> transferList = [];
  List<Map<String, dynamic>> filteredList = [];
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaCX';
  Timer? _debounce;
  bool showSearchOptions = false;

  Map<String, String> filters = {
    'MaCX': '',
    'ThuTu': '',
    'DiemDung': '',
    'ThoiGianDen': '',
    'ThoiGianDi': '',
  };

  @override
  void initState() {
    super.initState();
    fetchTransfers();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        filters[selectedColumn] = searchController.text.trim();
        fetchTransfers();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchTransfers() async {
  final payload = <String, dynamic>{};

  filters.forEach((k, v) {
    if (v.trim().isNotEmpty) {
      if (k == 'ThuTu') {
        final number = int.tryParse(v.trim());
        if (number != null) payload[k] = number;
      } else {
        payload[k] = v.trim();
      }
    }
  });

  try {
    final resp = await http.post(
      Uri.parse('$baseURL/trungchuyen/loc'),
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
          transferList = list;
          filteredList = list;
        });
      } else {
        print('Lỗi dữ liệu trả về: ${jsonResp['message']}');
      }
    } else {
      print('Lỗi kết nối API: ${resp.statusCode}');
    }
  } catch (e) {
    print('Lỗi ngoại lệ fetchTransfers: $e');
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
            headers: ['Mã CX', 'Thứ tự', 'Điểm dừng', 'TG đến', 'TG đi'],
            data: data.map((item) {
              return [
                item['MaCX'] ?? '',
                item['ThuTu'].toString(),
                item['DiemDung'] ?? '',
                item['ThoiGianDen'] ?? '',
                item['ThoiGianDi'] ?? '',
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
            // Khung chính
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
                          'DANH SÁCH TRẠM',
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
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Nhập từ khóa...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              filters[selectedColumn] = '';
                              fetchTransfers();
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
                      onChanged: (value) {
                        filters[selectedColumn] = value.trim();
                      },

                      ),
                      const SizedBox(height: 16),
                      // Bộ lọc
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
                            {'label': 'Thứ tự', 'value': 'ThuTu'},
                            {'label': 'Điểm dừng', 'value': 'DiemDung'},
                            {'label': 'Thời gian đến', 'value': 'ThoiGianDen'},
                            {'label': 'Thời gian đi', 'value': 'ThoiGianDi'},
                          ],
                          filterValues: filters, 
                          onFilterChanged: (upd){
                            setState(() {
                              filters = upd;
                              fetchTransfers();
                            });
                          }),
                      const SizedBox(height: 8),
                      // Tổng số + nút
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
                                tooltip: 'Thêm trạm',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddStop()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bảng
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
                                  child: Text(
                                    'Mã CX',
                                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 60,
                                  child: Text(
                                    'Thứ tự',
                                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 220,
                                  child: Text(
                                    'Điểm dừng',
                                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 140,
                                  child: Text(
                                    'Thời gian đến',
                                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 140,
                                  child: Text(
                                    'Thời gian đi',
                                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                  ),
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
                                              builder: (context) => EditStop(stop: item),
                                            ),
                                          );
                                        },
                                        child: Text(item['MaCX'] ?? ''),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 60,
                                      child: Text(item['ThuTu']?.toString() ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 220,
                                      child: Text(item['DiemDung'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 140,
                                      child: Text(item['ThoiGianDen'] ?? ''),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 140,
                                      child: Text(item['ThoiGianDi'] ?? ''),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Phân trang
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