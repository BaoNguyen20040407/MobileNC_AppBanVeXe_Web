import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/support_admin/reply_support.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';

class SupportListScreen extends StatefulWidget {
  const SupportListScreen({super.key});

  @override
  State<SupportListScreen> createState() => _SupportListScreenState();
}

class _SupportListScreenState extends State<SupportListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaHT';
  bool showSearchOptions = false;

  List<Map<String, dynamic>> supports = [];

  @override
  void initState() {
    super.initState();
    _fetchSupports();
  }

  Future<void> _fetchSupports() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/hotro'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            supports = List<Map<String, dynamic>>.from(json['data']);
          });
        }
      } else {
        print('❌ Server lỗi khi lấy hỗ trợ');
      }
    } catch (e) {
      print('❌ Lỗi kết nối khi gọi API hỗ trợ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = supports.where((item) {
      final searchLower = searchController.text.toLowerCase();
      if (searchLower.isEmpty) return true;
      final field = (item[selectedColumn]?.toString() ?? '').toLowerCase();
      return field.contains(searchLower);
    }).toList();

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
                          'HỖ TRỢ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
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
                              ChoiceChipSelector(label: 'Mã hỗ trợ', value: 'MaHT', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Tiêu đề', value: 'TieuDe', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Khách hàng', value: 'MaKH', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Nhân viên', value: 'MaNV', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng số: ${filteredList.length}', style: const TextStyle(fontFamily: 'Inter')),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            tooltip: 'Không thể thêm hỗ trợ trực tiếp',
                            onPressed: null,
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
                              DataColumn(label: SizedBox(width: 80, child: Text('Mã HT', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 160, child: Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 250, child: Text('Câu hỏi', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 250, child: Text('Trả lời', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 100, child: Text('Mã KH', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 100, child: Text('Mã NV', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                              DataColumn(label: SizedBox(width: 80, child: Text('Phản hồi', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
                            ],
                            rows: filteredList.map((support) {
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
                                              builder: (_) => ReplySupportScreen(supportItem: support),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          support['MaHT'] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(SizedBox(width: 160, child: Text(support['TieuDe'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 250, child: Text(support['CauHoi'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 250, child: Text(support['CauTraLoi'] ?? '', style: const TextStyle(fontFamily: 'Inter', color: AppColors.greenDark)))),
                                  DataCell(SizedBox(width: 100, child: Text(support['MaKH'] ?? '', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(SizedBox(width: 100, child: Text(support['MaNV'] ?? '-', style: const TextStyle(fontFamily: 'Inter')))),
                                  DataCell(
                                    SizedBox(
                                      width: 80,
                                      child: InkWell(
                                        onTap: () async {
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ReplySupportScreen(supportItem: support),
                                            ),
                                          );
                                          if (updated == true) {
                                            _fetchSupports(); // refresh lại sau khi phản hồi
                                          }
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeAdmin()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
