import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaGY';
  bool showSearchOptions = false;

  final List<Map<String, String>> feedbacks = [];

  @override
  Widget build(BuildContext context) {
    final filteredList = feedbacks.where((item) {
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
                          'GÓP Ý',
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
                                label: 'Mã góp ý',
                                value: 'MaGY',
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
                            tooltip: 'Không thể thêm góp ý trực tiếp',
                            onPressed: null,
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
                              children: filteredList.map((feedback) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(
                                      'Mã góp ý: ${feedback['MaGY'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Tiêu đề: ${feedback['TieuDe'] ?? ''}'),
                                        Text('Nội dung: ${feedback['NoiDungGopY'] ?? ''}'),
                                        if ((feedback['PhanHoi'] ?? '').isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Phản hồi: ${feedback['PhanHoi']}',
                                              style: const TextStyle(color: AppColors.greenDark),
                                            ),
                                          ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.person, size: 12, color: AppColors.mainOrange),
                                            const SizedBox(width: 4),
                                            Text('Khách: ${feedback['MaKH'] ?? '-'}',
                                                style: const TextStyle(fontSize: 12)),
                                            const SizedBox(width: 16),
                                            const Icon(Icons.badge, size: 12, color: AppColors.mainOrange),
                                            const SizedBox(width: 4),
                                            Text('NV: ${feedback['MaNV'] ?? '-'}',
                                                style: const TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.reply, color: AppColors.mainOrange),
                                      onPressed: () {
                                        // TODO: mở form phản hồi
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                      const SizedBox(height: 16),

                      // Phân trang
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Đầu", style: TextStyle(fontFamily: 'Inter', color: AppColors.black)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: AppColors.mainOrange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('1',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Cuối", style: TextStyle(fontFamily: 'Inter', color: AppColors.black)),
                          ),
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
