import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/view/admin/account/account.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/add_account_admin.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/edit_account_admin.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountStaffList extends StatefulWidget {
  const AccountStaffList({super.key});

  @override
  State<AccountStaffList> createState() => _AccountStaffListState();
}

class _AccountStaffListState extends State<AccountStaffList> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaTK';
  bool showSearchOptions = false;
  List<dynamic> staffAccounts = [];

  @override
  void initState() {
    super.initState();
    fetchStaffAccounts();
  }

  Future<void> fetchStaffAccounts() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/taikhoannv'));
      if (response.statusCode == 200) {
        setState(() {
          staffAccounts = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load accounts');
      }
    } catch (e) {
      print('❌ Error fetching accounts: $e');
    }
  }

  Future<void> deleteAccount(String maTK) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa tài khoản này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:3000/taikhoannv/$maTK'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xóa thành công')));
        fetchStaffAccounts();
      } else {
        throw Exception('Failed to delete');
      }
    } catch (e) {
      print('❌ Error deleting: $e');
    }
  }

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
              pw.Text('Danh sách tài khoản nhân viên', style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: ['Mã TK', 'Tên đăng nhập', 'Mật khẩu', 'Mã NV'],
                data: accounts.map((tk) => [tk['MaTK'] ?? '', tk['TenDangNhapNV'] ?? '', tk['Password'] ?? '', tk['MaNV'] ?? '']).toList(),
                cellStyle: pw.TextStyle(font: ttf, fontSize: 11),
                headerStyle: pw.TextStyle(font: ttf, fontSize: 13, fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                border: pw.TableBorder.all(width: 0.5),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = staffAccounts.where((account) {
      final query = searchController.text.toLowerCase();
      return account[selectedColumn]?.toLowerCase().contains(query) ?? false;
    }).toList();

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
                          const Text("Tìm kiếm theo: ", style: TextStyle(fontFamily: 'Inter')),
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
                            children: [
                              ChoiceChipSelector(label: 'Mã TK', value: 'MaTK', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Tên đăng nhập', value: 'TenDangNhapNV', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Mật khẩu', value: 'Password', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Mã NV', value: 'MaNV', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
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
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không có dữ liệu để xuất PDF')));
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
                                  ).then((_) => fetchStaffAccounts());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...filteredList.map((acc) => ListTile(
                            title: Text('${acc['MaTK']} - ${acc['TenDangNhapNV']}', style: const TextStyle(fontFamily: 'Inter')),
                            subtitle: Text('Mã NV: ${acc['MaNV']}', style: const TextStyle(fontFamily: 'Inter')),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditAccountAdminScreen(accountData: acc),
                                    ),
                                  ).then((_) => fetchStaffAccounts()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteAccount(acc['MaTK']),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),
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
