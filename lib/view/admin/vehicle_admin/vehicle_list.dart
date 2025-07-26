import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/home_admin/manage_station.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/add_vehicle.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/edit_vehicle.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';

class VehicleList extends StatefulWidget {
  const VehicleList({super.key});

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool showSearchOptions = false;

  final TextEditingController searchController = TextEditingController();

  // Filters gồm các trường filter theo API xe/loc (có thêm SoChoNgoi)
  Map<String, String> filters = {
    'BienSoXe': '',
    'LoaiXe': '',
    'HangSanXuat': '',
    'NamSanXuat': '',
    'MaBX': '',
    'SoChoNgoi': '',
  };

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchVehicles();

    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _onSearchChanged();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchVehicles() async {
    try {
      // Chuẩn bị body gửi lên API POST xe/loc, chỉ gửi các trường không rỗng
      final Map<String, dynamic> payload = {};
      filters.forEach((key, value) {
        if (value.trim().isNotEmpty) {
          if (key == 'NamSanXuat' || key == 'SoChoNgoi') {
            // Parse int cho 2 trường số
            final parsed = int.tryParse(value.trim());
            if (parsed != null) payload[key] = parsed;
          } else {
            payload[key] = value.trim();
          }
        }
      });

      final response = await http.post(
        Uri.parse('$baseURL/xe/loc'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            // Lấy data từ server (đã lọc)
            final List<dynamic> jsonList = jsonResponse['data'];
            vehicleList = List<Map<String, dynamic>>.from(
              jsonList.map((e) => Map<String, dynamic>.from(e)),
            );
            filteredList = vehicleList; // Không cần lọc lại ở client
          });
        } else {
          print('Lỗi server khi lấy dữ liệu xe: ${jsonResponse['message']}');
        }
      } else {
        print('Lỗi khi gọi API xe/loc: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi kết nối API xe/loc: $e');
    }
  }

  void _onSearchChanged() {
    // Cập nhật filters theo selected filter (searchController dùng cho selectedColumn)
    setState(() {
      filters[selectedColumn] = searchController.text.trim();
    });
    fetchVehicles();
  }

  // Khởi tạo selectedColumn để tương tác với searchController
  String selectedColumn = 'BienSoXe';

  Future<void> exportToPDF(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: ['Biển số', 'Loại xe', 'Số chỗ', 'Hãng SX', 'Năm SX', 'Mã BX'],
            data: data.map((xe) {
              return [
                xe['BienSoXe'] ?? '',
                xe['LoaiXe'] ?? '',
                xe['SoChoNgoi']?.toString() ?? '',
                xe['HangSanXuat'] ?? '',
                xe['NamSanXuat']?.toString() ?? '',
                xe['MaBX'] ?? '',
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
    // Cập nhật searchController.text theo selectedColumn filter hiện tại
    if (searchController.text != filters[selectedColumn]) {
      searchController.text = filters[selectedColumn] ?? '';
      searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
    }

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
                          'DANH SÁCH XE',
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
                          hintStyle: const TextStyle(fontFamily: 'Inter'),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                filters[selectedColumn] = '';
                                fetchVehicles();
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
                          filters[selectedColumn] = value;
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(const Duration(milliseconds: 300), () {
                            fetchVehicles();
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Bộ lọc chọn cột lọc
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tìm kiếm theo:", style: TextStyle(fontFamily: 'Inter')),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FilterChipWithInputInline(
                            filters: [
                              {'label': 'Biển số', 'value': 'BienSoXe'},
                              {'label': 'Loại xe', 'value': 'LoaiXe'},
                              {'label': 'Hãng SX', 'value': 'HangSanXuat'},
                              {'label': 'Năm SX', 'value': 'NamSanXuat'},
                              {'label': 'Mã BX', 'value': 'MaBX'},
                              {'label': 'Số chỗ', 'value': 'SoChoNgoi'},
                            ],
                            filterValues: filters,
                            onFilterChanged: (updated) {
                              setState(() {
                                filters = updated;
                                // Cập nhật searchController với selectedColumn mới
                                if (!filters.containsKey(selectedColumn)) {
                                  selectedColumn = filters.keys.first;
                                }
                                searchController.text = filters[selectedColumn] ?? '';
                                fetchVehicles();
                              });
                            },
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Tổng số + icon
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
                                tooltip: 'Thêm xe',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
                                  ).then((value) => fetchVehicles()); // Reload sau khi thêm
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
                                  width: 100,
                                  child: Text(
                                    'Biển số',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Loại xe',
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
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Hãng SX',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Năm SX',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Mã BX',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                            ],
                            rows: filteredList.map((xe) {
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
                                                builder: (context) => EditVehicle(vehicle: xe)),
                                          ).then((value) => fetchVehicles());
                                        },
                                        child: Text(
                                          xe['BienSoXe'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: 'Inter'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        xe['LoaiXe'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        xe['SoChoNgoi']?.toString() ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        xe['HangSanXuat'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        xe['NamSanXuat']?.toString() ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        xe['MaBX'] ?? '',
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

                      // Phân trang demo
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