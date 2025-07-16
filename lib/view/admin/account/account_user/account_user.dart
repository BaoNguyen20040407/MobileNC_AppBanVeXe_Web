import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/view/admin/account/account.dart';

class AccountUserList extends StatefulWidget {
  const AccountUserList({super.key});

  @override
  State<AccountUserList> createState() => _AccountUserListState();
}

class _AccountUserListState extends State<AccountUserList> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaTK';
  bool showSearchOptions = false;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> filteredList = []; // Giao diện, không có dữ liệu

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                          'DANH SÁCH TÀI KHOẢN KHÁCH HÀNG',
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
                                  _buildChoiceChip('Mã TK', 'MaTK'),
                                  const SizedBox(width: 8),
                                  _buildChoiceChip('Email', 'Email'),
                                  const SizedBox(width: 8),
                                  _buildChoiceChip('Mật khẩu', 'Password'),
                                  const SizedBox(width: 8),
                                  _buildChoiceChip('Mã KH', 'MaKH'),
                                ],
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 8),

                      // Tổng số + chức năng
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng số: ${filteredList.length}', style: const TextStyle(fontFamily: 'Inter')),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.print),
                                tooltip: 'Xuất PDF',
                                onPressed: () {},
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm tài khoản',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Bảng dữ liệu (trống)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mainOrange),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Chưa có dữ liệu để hiển thị',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
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

            const SizedBox(height: 32),

            ExitButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AccountScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
