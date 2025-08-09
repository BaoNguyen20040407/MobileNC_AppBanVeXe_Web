import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/view/admin/account/account.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/add_account_admin.dart';
import 'package:giao_dien_1/view/admin/account/account_admin/edit_account_admin.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:giao_dien_1/widget/search_field.dart';
import 'package:giao_dien_1/widget/build_pdf_page.dart';

class AccountStaffList extends StatefulWidget {
  const AccountStaffList({super.key});

  @override
  State<AccountStaffList> createState() => _AccountStaffListState();
}

class _AccountStaffListState extends State<AccountStaffList> {
  final TextEditingController searchController = TextEditingController();
  bool showSearchOptions = false;
  List<Map<String, dynamic>> accountList = [];
  List<Map<String, dynamic>> filteredList = [];
  Map<String, String> filters = {
    'MaTK': '',
    'TenDangNhapNV': '',
    'Password': '',
    'MaNV': '',
  };
  Timer? _debounce;

    @override
  void initState() {
    super.initState();
    fetchAccounts();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        fetchAccounts();
      });
    });
  }

  Future<void> fetchAccounts() async {
  try {
    final response = await http.get(Uri.parse('$baseURL/loctaikhoannv'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List<dynamic> jsonList = body is List ? body : body['data'];

      final List<Map<String, dynamic>> parsedList =
          List<Map<String, dynamic>>.from(jsonList.map((e) => Map<String, dynamic>.from(e)));

      setState(() {
        accountList = parsedList;
        _filterAccounts();
      });

      print('✅ Fetch thành công: ${accountList.length} tài khoản');
    } else {
      print('❌ Lỗi khi fetch tài khoản: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Lỗi kết nối: $e');
  }
}

void _filterAccounts() {
  String keyword = searchController.text.trim().toLowerCase();

  setState(() {
    filteredList = accountList.where((account) {
      // 1. Tìm kiếm từ khóa chung
      final matchesSearch = keyword.isEmpty
          ? true
          : account.values.any((value) =>
              value != null &&
              value.toString().toLowerCase().contains(keyword));

      // 2. Kiểm tra các bộ lọc chi tiết (nếu có)
      final matchesFilters = filters.entries.every((entry) {
        final key = entry.key;
        final filterValue = entry.value.trim().toLowerCase();

        if (filterValue.isEmpty) return true;

        final fieldValue = account[key]?.toString().toLowerCase() ?? '';

        return fieldValue.startsWith(filterValue); // lọc gần đúng
      });

      return matchesSearch && matchesFilters;
    }).toList();
  });
}

  Future<void> exportStaffAccountsToPDF(List<dynamic> accounts) async {
  try {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    final logoBytes = await loadLogoBytes('assets/image/logovexekhach_1.png');

    final data = accounts.map((tk) {
      return [
        tk['MaTK']?.toString() ?? '',
        tk['TenDangNhapNV']?.toString() ?? '',
        tk['Password']?.toString() ?? '',
        tk['MaNV']?.toString() ?? '',
      ];
    }).toList();

    final page = buildPdfPage(
      font: ttf,
      logoBytes: logoBytes,
      title: 'DANH SÁCH TÀI KHOẢN NHÂN VIÊN',
      headers: ['Mã TK', 'Tên đăng nhập', 'Mật khẩu', 'Mã NV'],
      data: data,
      totalCount: accounts.length,
    );

    pdf.addPage(page);

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  } catch (e, stacktrace) {
    print('Lỗi khi tạo PDF danh sách tài khoản nhân viên: $e');
    print('Stacktrace: $stacktrace');
  }
}

  @override
  Widget build(BuildContext context) {
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
                      CustomSearchField(
                        controller: searchController,
                        onClear: () {
                          searchController.clear();
                          _filterAccounts();
                        },
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tìm kiếm theo:", style: TextStyle(fontFamily: 'Inter')),
                          IconButton(
                            icon: Icon(showSearchOptions ? Icons.expand_less : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                showSearchOptions = !showSearchOptions;
                                print('showSearchOptions: $showSearchOptions'); // debug
                              });
                            },
                          ),
                        ],
                      ),
                      if (showSearchOptions)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FilterChipWithInputInline(
                            filters: [
                              {'label': 'Mã TK', 'value': 'MaTK'},
                              {'label': 'Tên đăng nhập', 'value': 'TenDangNhap'},
                              {'label': 'Password', 'value': 'Password'},
                              {'label': 'Mã NV', 'value': 'MaNV'},
                            ], 
                            filterValues: filters, 
                            onFilterChanged: (updated) {
                              setState(() => filters = updated);
                              _filterAccounts();
                            },
                          )
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
                                  ).then((_) => fetchAccounts());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bảng dữ liệu tài khoản nhân viên
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
                                  width: 100,
                                  child: Text(
                                    'Mã TK',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 180,
                                  child: Text(
                                    'Tên đăng nhập',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 160,
                                  child: Text(
                                    'Mật khẩu',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Mã NV',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                            ],
                            rows: filteredList.map((taiKhoan) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: InkWell(
                                        onTap: () {
                                          // Chuyển sang trang sửa tài khoản nếu có
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditAccountAdminScreen(accountData: taiKhoan),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          taiKhoan['MaTK'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: 'Inter'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        taiKhoan['TenDangNhapNV'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        taiKhoan['Password'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        taiKhoan['MaNV'] ?? '',
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
