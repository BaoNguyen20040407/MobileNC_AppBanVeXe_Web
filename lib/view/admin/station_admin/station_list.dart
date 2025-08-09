import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/station_admin/add_station.dart';
import 'package:giao_dien_1/view/admin/station_admin/edit_station.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/view/admin/home_admin/manage_station.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:giao_dien_1/widget/search_field.dart';
import 'package:giao_dien_1/widget/build_pdf_page.dart';

class StationList extends StatefulWidget {
  const StationList({super.key});

  @override
  State<StationList> createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  List<Map<String, dynamic>> stationList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool showSearchOptions = false;

  final TextEditingController searchController = TextEditingController();
  Map<String, String> filters = {
    'MaBX': '',
    'TenBX': '',
    'DiaChi': '',
    'TinhThanh': '',
  };

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchStations();

    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _filterStations();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchStations() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/benxe'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Map<String, dynamic>> parsedList =
            List<Map<String, dynamic>>.from(jsonList.map((e) => Map<String, dynamic>.from(e)));

        setState(() {
          stationList = parsedList;
          _filterStations(); // Lọc lần đầu sau khi fetch
        });

        print('✅ Fetch thành công: ${stationList.length} bến xe');
      } else {
        print('❌ Lỗi khi fetch bến xe: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Lỗi kết nối: $e');
    }
  }

  void _filterStations() {
  String keyword = searchController.text.trim().toLowerCase();

  setState(() {
    filteredList = stationList.where((station) {
      // 1. Kiểm tra keyword search chung (nếu có)
      final matchesSearch = keyword.isEmpty
          ? true
          : station.values.any((value) =>
              value != null &&
              value.toString().toLowerCase().contains(keyword));

      // 2. Kiểm tra từng filter chi tiết
      final matchesFilters = filters.entries.every((entry) {
        final key = entry.key;
        final filterValue = entry.value.trim().toLowerCase();

        if (filterValue.isEmpty) return true;

        final fieldValue = station[key]?.toString().toLowerCase() ?? '';

        // Dùng startsWith để lọc chính xác hơn
        return fieldValue.startsWith(filterValue);
      });

      // 3. Kết hợp cả 2 điều kiện
      return matchesSearch && matchesFilters;
    }).toList();
  });
}

  Future<void> exportStationsToPDF(List<Map<String, dynamic>> data) async {
  try {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final logoBytes = await loadLogoBytes('assets/image/logovexekhach_1.png');

    final tableData = data.map((station) {
      return [
        station['MaBX']?.toString() ?? '',
        station['TenBX']?.toString() ?? '',
        station['TinhThanh']?.toString() ?? '',
        station['DiaChi']?.toString() ?? ''
      ];
    }).toList();

    final page = buildPdfPage(
      font: ttf,
      logoBytes: logoBytes,
      title: 'DANH SÁCH BẾN XE',
      headers: ['Mã BX', 'Tên BX', 'Tỉnh/Thành', 'Địa chỉ'],
      data: tableData,
      totalCount: data.length,
    );

    pdf.addPage(page);

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  } catch (e, stacktrace) {
    print('Lỗi khi tạo PDF danh sách bến xe: $e');
    print('Stacktrace: $stacktrace');
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // KHUNG CHÍNH
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
                          'DANH SÁCH BẾN XE',
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
                          _filterStations();
                        },
                      ),
                      const SizedBox(height: 16),

                      //Bộ lọc
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tìm kiếm theo:", style: TextStyle(fontFamily: 'Inter')),
                          IconButton(
                            icon: Icon(showSearchOptions ? Icons.expand_less : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                showSearchOptions = !showSearchOptions;
                                print('showSearchOptions: $showSearchOptions'); // debug
                              });
                            },
                          ),
                        ],
                      ),
                      if (showSearchOptions)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FilterChipWithInputInline(
                            filters: [
                              {'label': 'Mã BX', 'value': 'MaBX'},
                              {'label': 'Tên BX', 'value': 'TenBX'},
                              {'label': 'Địa chỉ', 'value': 'DiaChi'},
                              {'label': 'Tỉnh/Thành', 'value': 'TinhThanh'},
                            ],
                            filterValues: filters,
                            onFilterChanged: (updated) {
                              setState(() => filters = updated);
                              _filterStations();
                            },
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Tổng số + icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng số: ${filteredList.length}',
                              style: const TextStyle(fontFamily: 'Inter')),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.print),
                                tooltip: 'Xuất PDF',
                                onPressed: () => exportStationsToPDF(filteredList),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm bến xe',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddStation()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Bảng dữ liệu
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
                                  child: Text(
                                    'Mã BX',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 160,
                                  child: Text(
                                    'Tên Bến xe',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 250,
                                  child: Text(
                                    'Địa chỉ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Tỉnh/Thành',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                            ],
                            rows: filteredList.map((station) {
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
                                                builder: (context) =>
                                                    EditStation(station: station)),
                                          );
                                        },
                                        child: Text(
                                          station['MaBX'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: 'Inter'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        station['TenBX'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        station['DiaChi'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        station['TinhThanh'] ?? '',
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

                      // Phân trang (demo, chưa có logic thật)
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

            // EXIT BUTTON Ở NGOÀI KHUNG
            const SizedBox(height: 32),
            ExitButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ManageStationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
