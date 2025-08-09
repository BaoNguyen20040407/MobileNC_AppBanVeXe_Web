import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:giao_dien_1/view/admin/trip_admin/add_trip.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/view/admin/home_admin/manage_trip.dart';
import 'package:giao_dien_1/view/admin/trip_admin/edit_trip.dart';
import 'package:giao_dien_1/widget/search_field.dart';
import 'package:giao_dien_1/widget/build_pdf_page.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

class TripList extends StatefulWidget {
  const TripList({super.key});

  @override
  State<TripList> createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Map<String, dynamic>> tripList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool showSearchOptions = false;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String selectedColumn = 'MaCX';

  Map<String, String> filters = {
    'MaCX': '',
    'BienSoXe': '',
    'DiemDi': '',
    'DiemDen': '',
    'LoaiHinhChuyenDi': '',
    'GiaVe': '',
    'SoChoNgoi': '',
  };

  @override
  void initState() {
    super.initState();
    fetchTrips();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        filters[selectedColumn] = searchController.text.trim();
        fetchTrips();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchTrips() async {
    final payload = <String, dynamic>{};
    filters.forEach((k, v) {
      if (v.trim().isNotEmpty) {
        if (k == 'GiaVe' || k == 'SoChoNgoi') {
          final number = int.tryParse(v.trim());
          if (number != null) payload[k] = number;
        } else {
          payload[k] = v.trim();
        }
      }
    });

    final resp = await http.post(
      Uri.parse('$baseURL/chuyenxe/loc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (resp.statusCode == 200) {
      final jsonResp = jsonDecode(resp.body);
      if (jsonResp['success'] == true) {
        final list = List<Map<String, dynamic>>.from(
            (jsonResp['data'] as List).map((e) => Map<String, dynamic>.from(e)));
        setState(() {
          tripList = list;
          filteredList = list;
        });
      } else {
        print('Lỗi server: ${jsonResp['message']}');
      }
    } else {
      print('Lỗi API chuyenxe/loc: ${resp.statusCode}');
    }
  }

  Future<void> exportToPDF(List<Map<String, dynamic>> data) async {
  final pdf = pw.Document();

  // Load font
  final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  // Load logo (đường dẫn tùy bạn)
  final logoBytes = await loadLogoBytes('assets/image/logovexekhach_1.png');

  // Chuẩn bị dữ liệu bảng, ép thành String
  final tableData = data.map((t) {
    return [
      (t['MaCX'] ?? '').toString(),
      (t['BienSoXe'] ?? '').toString(),
      (t['DiemDi'] ?? '').toString(),
      (t['DiemDen'] ?? '').toString(),
      (t['LoaiHinhChuyenDi'] ?? '').toString(),
      t['GiaVe'] != null ? t['GiaVe'].toString() : '',
      t['SoChoNgoi'] != null ? t['SoChoNgoi'].toString() : '',
    ];
  }).toList();

  final page = pw.Page(
    build: (context) {
      final now = DateTime.now();
      final formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header logo + title
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), width: 100, height: 100),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Center(
                  child: pw.Text(
                    'DANH SÁCH CHUYẾN XE',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 8),

          // Tổng số bản ghi và thời gian
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Tổng số: ${data.length}', style: pw.TextStyle(font: ttf, fontSize: 12)),
              pw.Text('Xuất lúc: $formattedDate', style: pw.TextStyle(font: ttf, fontSize: 12)),
            ],
          ),

          pw.SizedBox(height: 12),

          // Bảng dữ liệu
          pw.Table.fromTextArray(
            headers: ['Mã CX','Biển số','Điểm đi','Điểm đến','Loại hình','Giá vé','Số chỗ'],
            data: tableData,
            cellStyle: pw.TextStyle(font: ttf, fontSize: 11),
            headerStyle: pw.TextStyle(font: ttf, fontSize: 13, fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(width: 0.5),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            headerAlignment: pw.Alignment.center,
          ),
        ],
      );
    },
  );

  pdf.addPage(page);

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
                  border: Border.all(color: AppColors.mainOrange, width: 1),
                  borderRadius: BorderRadius.circular(6)),
              child: Card(
                elevation: 0,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    const Text(
                      'DANH SÁCH CHUYẾN XE',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 16),
                    CustomSearchField(
                      controller: searchController,
                      onClear: () {
                        searchController.clear();
                        filters[selectedColumn] = '';
                        fetchTrips();
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
                          {'label': 'Biển số', 'value': 'BienSoXe'},
                          {'label': 'Điểm đi', 'value': 'DiemDi'},
                          {'label': 'Điểm đến', 'value': 'DiemDen'},
                          {'label': 'Loại hình', 'value': 'LoaiHinhChuyenDi'},
                          {'label': 'Giá vé', 'value': 'GiaVe'},
                          {'label': 'Số chỗ', 'value': 'SoChoNgoi'},
                        ],
                        filterValues: filters,
                        onFilterChanged: (upd) {
                          setState(() {
                            filters = upd;
                            fetchTrips();
                          });
                        },
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng số: ${filteredList.length}',
                            style: const TextStyle(fontFamily: 'Inter')),
                        Row(children: [
                          IconButton(
                            icon: const Icon(Icons.print),
                            tooltip: 'Xuất PDF',
                            onPressed: () => exportToPDF(filteredList),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            tooltip: 'Thêm chuyến xe',
                            onPressed: () =>
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTrip())),
                          ),
                        ])
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mainOrange),
                          borderRadius: BorderRadius.circular(6)),
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
                                  'Mã CX',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  'Biển số',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 150,
                                child: Text(
                                  'Điểm đến',
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
                                width: 80,
                                child: Text(
                                  'Số chỗ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                          ],
                          rows: filteredList.map((t) {
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
                                            builder: (context) => EditTrip(trip: t),
                                          ),
                                        ).then((value) {
                                          // Gọi lại API hoặc hàm load dữ liệu sau khi chỉnh sửa
                                          fetchTrips();
                                        });
                                      },
                                      child: Text(
                                        t['MaCX'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      t['BienSoXe'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      t['DiemDen'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      t['GiaVe']?.toString() ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      t['SoChoNgoi']?.toString() ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
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
                      onFirstPressed: () => print("First page"),
                      onLastPressed: () => print("Last page"),
                    ),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ExitButton(onPressed: () =>
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ManageTripScreen()))
            ),
          ],
        ),
      ),
    );
  }
}
