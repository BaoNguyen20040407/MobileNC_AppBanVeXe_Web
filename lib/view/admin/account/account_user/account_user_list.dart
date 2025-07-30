import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/view/admin/account/account.dart';
import 'package:giao_dien_1/view/admin/account/account_user/add_account_user.dart';
import 'package:giao_dien_1/view/admin/account/account_user/edit_account_user.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AccountUserList extends StatefulWidget {
  const AccountUserList({super.key});

  @override
  State<AccountUserList> createState() => _AccountUserListState();
}

class _AccountUserListState extends State<AccountUserList> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaTK';
  bool showSearchOptions = false;
  List<dynamic> accountList = [];

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/taikhoankh'));
    if (response.statusCode == 200) {
      setState(() {
        accountList = json.decode(response.body);
      });
    } else {
      print('Lỗi khi tải dữ liệu tài khoản KH');
    }
  }

  Future<void> exportAccountsToPDF(List<dynamic> accounts) async {
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
                'Danh sách tài khoản khách hàng',
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: ['Mã TK', 'Tên đăng nhập', 'Mật khẩu', 'Mã KH'],
                data: accounts.map((tk) {
                  return [
                    tk['MaTK'] ?? '',
                    tk['TenDangNhapKH'] ?? '',
                    tk['Password'] ?? '',
                    tk['MaKH'] ?? '',
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

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = accountList.where((account) {
      final keyword = searchController.text.toLowerCase();
      final value = account[selectedColumn]?.toString().toLowerCase() ?? '';
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
                          'DANH SÁCH TÀI KHOẢN\nKHÁCH HÀNG',
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
                              ChoiceChipSelector(label: 'Mã TK', value: 'MaTK', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Tên đăng nhập', value: 'TenDangNhapKH', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Mật khẩu', value: 'Password', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Mã KH', value: 'MaKH', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
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
                                onPressed: () => exportAccountsToPDF(filteredList),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm tài khoản',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AddCustomerAccountScreen(),
                                      settings: const RouteSettings(name: '/add_account_user'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (filteredList.isEmpty)
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
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final account = filteredList[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              child: ListTile(
                                title: Text(account['TenDangNhapKH'] ?? ''),
                                subtitle: Text('MãTK: ${account['MaTK']} - MãKH: ${account['MaKH']}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditCustomerAccountScreen(accountData: account),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Xác nhận xóa'),
                                            content: const Text('Bạn có chắc chắn muốn xóa tài khoản này?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
                                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Xóa')),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          final response = await http.delete(
                                            Uri.parse('http://10.0.2.2:3000/taikhoankh/${account['MaTK']}'),
                                          );
                                          if (response.statusCode == 200) {
                                            setState(() => accountList.removeAt(index));
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã xóa tài khoản')));
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Không thể xóa tài khoản')));
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
