import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/station_admin/add_station.dart';
import 'package:giao_dien_1/view/admin/station_admin/edit_station.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/view/admin/home_admin/manage_station.dart';
import 'package:giao_dien_1/config/config.dart';

class StationList extends StatefulWidget {
  const StationList({super.key});

  @override
  State<StationList> createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  List<dynamic> stationList = [];
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaBX'; // Mặc định tìm theo Mã BX
  bool showSearchOptions = false;

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  Future<void> fetchStations() async {
    final response = await http.get(Uri.parse('$baseURL/benxe'));

    if (response.statusCode == 200) {
      setState(() {
        stationList = jsonDecode(response.body);
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
          headers: ['Mã BX', 'Tên Bến Xe', 'Tỉnh/Thành'],
          data: data.map((station) {
            return [
              station['MaBX'] ?? '',
              station['TenBX'] ?? '',
              station['TinhThanh'] ?? '',
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
  List<dynamic> filteredList = stationList.where((station) {
    final value = (station[selectedColumn] ?? '').toString().toLowerCase();
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
          // ✅ KHUNG CHÍNH
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

                    // Bộ lọc
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
                                _buildChoiceChip('Mã BX', 'MaBX'),
                                const SizedBox(width: 8),
                                _buildChoiceChip('Tên bến xe', 'TenBX'),
                                const SizedBox(width: 8),
                                _buildChoiceChip('Địa chỉ', 'DiaChi'),
                                const SizedBox(width: 8),
                                _buildChoiceChip('Tỉnh/Thành', 'TinhThanh'),
                              ],
                            ),
                          ),
                        ],
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
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 160,
                                child: Text(
                                  'Tên Bến xe',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 250,
                                child: Text(
                                  'Địa chỉ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  'Tỉnh/Thành',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
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
                                          MaterialPageRoute(builder: (context) => EditStation(station: station)),
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

                    // Phân trang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {}, child: const Text("Đầu", style: TextStyle(fontFamily: 'Inter', color: AppColors.black))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColors.mainOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        TextButton(onPressed: () {}, child: const Text("Cuối", style: TextStyle(fontFamily: 'Inter', color: AppColors.black))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ EXIT BUTTON Ở NGOÀI KHUNG
          const SizedBox(height: 24),
          ExitButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ManageStationScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

// Helper cho ChoiceChip
Widget _buildChoiceChip(String label, String value) {
  return ChoiceChip(
    label: Text(label, style: const TextStyle(fontFamily: 'Inter')),
    selected: selectedColumn == value,
    onSelected: (_) => setState(() => selectedColumn = value),
    selectedColor: AppColors.mainOrange,
    backgroundColor: Colors.white,
    labelStyle: TextStyle(
      color: selectedColumn == value ? Colors.white : Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.mainOrange),
    ),
  );
}
}