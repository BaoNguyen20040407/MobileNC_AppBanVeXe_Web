import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:giao_dien_1/view/admin/station_admin/add_station.dart';
import 'package:giao_dien_1/view/admin/station_admin/edit_station.dart';

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
    final response = await http.get(Uri.parse('http://localhost:3000/benxe'));

    if (response.statusCode == 200) {
      setState(() {
        stationList = jsonDecode(response.body);
      });
    } else {
      print('Lỗi khi lấy dữ liệu');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredList = stationList.where((station) {
      final value = (station[selectedColumn] ?? '').toString().toLowerCase();
      final keyword = searchController.text.toLowerCase();
      return value.contains(keyword);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarAdmin(),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 1.5),
            borderRadius: BorderRadius.circular(12),
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tìm kiếm + chọn cột
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
                      const Text("Tìm kiếm theo:"),
                      IconButton(
                        icon: Icon(showSearchOptions ? Icons.expand_less : Icons.expand_more),
                        tooltip: 'Hiện/ẩn bộ lọc',
                        onPressed: () {
                          setState(() {
                        showSearchOptions = !showSearchOptions;
                          });
                        },
                      )
                    ],
                  ),
                  if (showSearchOptions) ...[
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                    children: [
                    ChoiceChip(
                      label: const Text('Mã BX'),
                      selected: selectedColumn == 'MaBX',
                      onSelected: (_) => setState(() => selectedColumn = 'MaBX'),
                      selectedColor: AppColors.mainOrange,        // khi được chọn
                      backgroundColor: Colors.white,       // khi không chọn
                      labelStyle: TextStyle(
                        color: selectedColumn == 'MaBX' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedColumn == 'MaBX' ? AppColors.mainOrange : AppColors.mainOrange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Tên bến xe'),
                      selected: selectedColumn == 'TenBX',
                      onSelected: (_) => setState(() => selectedColumn = 'TenBX'),
                      selectedColor: AppColors.mainOrange,        // khi được chọn
                      backgroundColor: Colors.white,       // khi không chọn
                      labelStyle: TextStyle(
                        color: selectedColumn == 'TenBX' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedColumn == 'TenBX' ? AppColors.mainOrange : AppColors.mainOrange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Địa chỉ'),
                      selected: selectedColumn == 'DiaChi',
                      onSelected: (_) => setState(() => selectedColumn = 'DiaChi'),
                      selectedColor: AppColors.mainOrange,        // khi được chọn
                      backgroundColor: Colors.white,       // khi không chọn
                      labelStyle: TextStyle(
                        color: selectedColumn == 'DiaChi' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedColumn == 'DiaChi' ? AppColors.mainOrange : AppColors.mainOrange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Tỉnh/Thành'),
                      selected: selectedColumn == 'TinhThanh',
                      onSelected: (_) => setState(() => selectedColumn = 'TinhThanh'),
                      selectedColor: AppColors.mainOrange,        // khi được chọn
                      backgroundColor: Colors.white,       // khi không chọn
                      labelStyle: TextStyle(
                        color: selectedColumn == 'TinhThanh' ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedColumn == 'TinhThanh' ? AppColors.mainOrange : AppColors.mainOrange,
                        ),
                      ),
                    ),
                  ],
                    ),
                  ),
                  ],
                  const SizedBox(height: 8),
                  // Tổng số và các icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng số: ${filteredList.length}'),
                      Row(
                        children: [
                          const Icon(Icons.print),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            tooltip: 'Thêm bến xe',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddStation(),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bảng dữ liệu
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.orange.shade100),
                          columnSpacing: 16,
                          columns: const [
                            DataColumn(label: Text('Mã BX', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Tên Bến xe', style: TextStyle(fontWeight: FontWeight.bold))),
                            //DataColumn(label: Text('Địa chỉ', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Tỉnh/Thành', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: filteredList.map((station) {
  return DataRow(
    cells: [
      DataCell(
        InkWell(
          child: Text(
            station['MaBX'] ?? '',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditStation(station: station),
              ),
            );
          },
        ),
      ),
      DataCell(Text(station['TenBX'] ?? '')),
      DataCell(Text(station['TinhThanh'] ?? '')),
    ],
  );
}).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phân trang căn phải
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () {}, child: const Text("Đầu")),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(onPressed: () {}, child: const Text("Cuối")),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
