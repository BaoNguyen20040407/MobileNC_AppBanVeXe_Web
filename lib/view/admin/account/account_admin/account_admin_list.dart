import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/view/admin/account/account.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/add_account_admin.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;


class AccountStaffList extends StatefulWidget {
  const AccountStaffList({super.key});

  @override
  State<AccountStaffList> createState() => _AccountStaffListState();
}

class _AccountStaffListState extends State<AccountStaffList> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaTK';
  bool showSearchOptions = false;

  Future<void> exportStaffAccountsToPDF(List<dynamic> accounts) async {
  final pdf = pw.Document();

  final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Danh sách tài khoản nhân viên',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Table.fromTextArray(
              headers: ['Mã TK', 'Tên đăng nhập', 'Mật khẩu', 'Mã NV'],
              data: accounts.map((tk) {
                return [
                  tk['MaTK'] ?? '',
                  tk['TenDangNhapNV'] ?? '',
                  tk['MatKhauNV'] ?? '',
                  tk['MaNV'] ?? '',
                ];
              }).toList(),
              cellStyle: pw.TextStyle(font: ttf, fontSize: 11),
              headerStyle: pw.TextStyle(
                font: ttf,
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(width: 0.5),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}


  @override
  Widget build(BuildContext context) {
    final List<dynamic> filteredList = []; // Giao diện trống

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
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'DANH SÁCH TÀI KHOẢN\nNHÂN VIÊN',
                          textAlign: TextAlign.center,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              ChoiceChipSelector(
                                label: 'Mã TK',
                                value: 'MaTK',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                              ChoiceChipSelector(
                                label: 'Email',
                                value: 'Email',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                              ChoiceChipSelector(
                                label: 'Mật khẩu',
                                value: 'Password',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                              ChoiceChipSelector(
                                label: 'Mã KH',
                                value: 'MaKH',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                            ],
                          ),
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
                                onPressed: () {
                                  if (filteredList.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Không có dữ liệu để xuất PDF')),
                                    );
                                    return;
                                  }
                                  exportStaffAccountsToPDF(filteredList);
                                },
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm tài khoản',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AddEmployeeAccountScreen(),
                                      settings: const RouteSettings(name: '/add_account_admin'),
                                    ),
                                  );
                                },
                              ),
                            ],
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
}