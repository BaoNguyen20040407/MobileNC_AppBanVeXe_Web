import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/view/admin/support_admin/reply_support.dart';

class SupportListScreen extends StatefulWidget {
  const SupportListScreen({super.key});

  @override
  State<SupportListScreen> createState() => _SupportListScreenState();
}

class _SupportListScreenState extends State<SupportListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaHT'; 
  bool showSearchOptions = false;

  final List<Map<String, String>> supports = [];


  @override
  Widget build(BuildContext context) {
    // Lọc dữ liệu theo search (demo để sau bạn thêm thật)
    final filteredList = supports.where((item) {
      final searchLower = searchController.text.toLowerCase();
      if (searchLower.isEmpty) return true;
      final field = (item[selectedColumn] ?? '').toLowerCase();
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
                            ChoiceChipSelector(
                              label: 'Mã hỗ trợ',
                              value: 'MaHT',
                              selectedValue: selectedColumn,
                              onSelected: (val) => setState(() => selectedColumn = val),
                            ),
                            ChoiceChipSelector(
                              label: 'Tiêu đề',
                              value: 'TieuDe',
                              selectedValue: selectedColumn,
                              onSelected: (val) => setState(() => selectedColumn = val),
                            ),
                            ChoiceChipSelector(
                              label: 'Khách hàng',
                              value: 'MaKH',
                              selectedValue: selectedColumn,
                              onSelected: (val) => setState(() => selectedColumn = val),
                            ),
                            ChoiceChipSelector(
                              label: 'Nhân viên',
                              value: 'MaNV',
                              selectedValue: selectedColumn,
                              onSelected: (val) => setState(() => selectedColumn = val),
                            ),
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
                            onPressed: null, // disable nút thêm
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      filteredList.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.mainOrange),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  'Chưa có dữ liệu để hiển thị',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: filteredList.map((support) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(
                                      'Mã hỗ trợ: ${support['MaHT'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Tiêu đề: ${support['TieuDe'] ?? ''}'),
                                        Text('Câu hỏi: ${support['CauHoi'] ?? ''}'),
                                        if ((support['CauTraLoi'] ?? '').isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Trả lời: ${support['CauTraLoi']}',
                                              style: const TextStyle(color: AppColors.greenDark),
                                            ),
                                          ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.person, size: 12, color: AppColors.mainOrange),
                                            const SizedBox(width: 4),
                                            Text('Khách: ${support['MaKH'] ?? '-'}',
                                                style: const TextStyle(fontSize: 12)),
                                            const SizedBox(width: 16),
                                            const Icon(Icons.badge, size: 12, color: AppColors.mainOrange),
                                            const SizedBox(width: 4),
                                            Text('NV: ${support['MaNV'] ?? '-'}',
                                                style: const TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.reply, color: AppColors.mainOrange),
                                      onPressed: () async {
                                        final updated = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ReplySupportScreen(supportItem: support),
                                          ),
                                        );

                                        if (updated == true) {
                                          // TODO: Gọi lại API / cập nhật lại danh sách
                                          setState(() {
                                            // Nếu dùng API thật, reload lại từ server
                                            // Còn nếu dùng demo tạm, có thể chỉnh trực tiếp support['CauTraLoi'] trong danh sách nếu cần
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                      const SizedBox(height: 16),

                      // Phân trang (tạm để giống)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text("Đầu", style: TextStyle(fontFamily: 'Inter', color: AppColors.black))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: AppColors.mainOrange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text("Cuối", style: TextStyle(fontFamily: 'Inter', color: AppColors.black))),
                        ],
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
                  MaterialPageRoute(builder: (_) => HomeAdmin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
