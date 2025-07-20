import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_station.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/add_vehicle.dart';
import 'package:giao_dien_1/view/admin/vehicle_admin/edit_vehicle.dart';

class VehicleList extends StatefulWidget {
  const VehicleList({super.key});

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  List<dynamic> vehicleList = [];
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'BienSoXe';
  bool showSearchOptions = false;

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    final response = await http.get(Uri.parse('$baseURL/xe'));

    if (response.statusCode == 200) {
      setState(() {
        vehicleList = jsonDecode(response.body);
      });
    } else {
      print('Lỗi khi lấy dữ liệu xe');
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
            headers: ['Biển số', 'Loại xe', 'Số chỗ', 'Hãng SX', 'Năm', 'Mã BX'],
            data: data.map((xe) {
              return [
                xe['BienSoXe'] ?? '',
                xe['LoaiXe'] ?? '',
                xe['SoChoNgoi'].toString(),
                xe['HangSanXuat'] ?? '',
                xe['NamSanXuat'].toString(),
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
    List<dynamic> filteredList = vehicleList.where((xe) {
      final value = (xe[selectedColumn] ?? '').toString().toLowerCase();
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
                      const SizedBox(height: 16),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Nhập từ khóa...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.mainOrange),
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tìm kiếm theo: ", style: TextStyle(fontFamily: 'Inter')),
                          IconButton(
                            icon: Icon(showSearchOptions ? Icons.expand_less : Icons.expand_more),
                            onPressed: () => setState(() => showSearchOptions = !showSearchOptions),
                          ),
                        ],
                      ),
                      if (showSearchOptions)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ChoiceChipSelector(label: "Biển số", value: "BienSoXe", selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              const SizedBox(width: 8),
                              ChoiceChipSelector(label: "Loại xe", value: "LoaiXe", selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              const SizedBox(width: 8),
                              ChoiceChipSelector(label: "Hãng SX", value: "HangSanXuat", selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              const SizedBox(width: 8),
                              ChoiceChipSelector(label: "Mã BX", value: "MaBX", selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
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
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm xe',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mainOrange),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(AppColors.softOrange),
                            columns: const [
                              DataColumn(label: Text('Biển số', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Loại xe', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Số chỗ', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Hãng SX', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Năm SX', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Mã BX', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: filteredList.map((xe) {
                              return DataRow(cells: [
                                DataCell(InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditVehicle(vehicle: xe),
                                      ),
                                    );
                                  },
                                  child: Text(xe['BienSoXe'] ?? ''),
                                )),
                                DataCell(Text(xe['LoaiXe'] ?? '')),
                                DataCell(Text('${xe['SoChoNgoi']}')),
                                DataCell(Text(xe['HangSanXuat'] ?? '')),
                                DataCell(Text('${xe['NamSanXuat']}')),
                                DataCell(Text(xe['MaBX'] ?? '')),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PaginationControls(
                        currentPage: 1,
                        onFirstPressed: () {},
                        onLastPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ExitButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ManageStationScreen()));
            }),
          ],
        ),
      ),
    );
  }
}