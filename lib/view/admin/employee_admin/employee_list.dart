import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_people.dart';
import 'package:giao_dien_1/view/admin/employee_admin/add_employee.dart';
import 'package:giao_dien_1/view/admin/employee_admin/edit_employee.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'dart:convert';
import 'dart:async';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:giao_dien_1/widget/search_field.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showSearchOptions = false;
  List<Map<String, dynamic>> employeeList = [];
  List<Map<String, dynamic>> filteredList = [];
  Map<String, String> filters = {
    'MaNV': '',
    'HoVaTen': '',
    'NgaySinh': '',
    'DiaChi': '',
    'Email': '',
    'SDT': '',
    'URLHinhAnh': '',
    'NgayVaoLam': '',
    'ChucVu': '',
    'PhongBan': '',
  };
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        fetchEmployees();
      });
    });

  }

  Future<void> fetchEmployees() async {
  try {
    final response = await http.get(Uri.parse('$baseURL/nhanvien'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Kiểm tra xem trả về danh sách trực tiếp hay bọc trong object
      final List<dynamic> jsonList =
          body is List ? body : body['data'];

      final List<Map<String, dynamic>> parsedList =
          List<Map<String, dynamic>>.from(
              jsonList.map((e) => Map<String, dynamic>.from(e)));

      setState(() {
        employeeList = parsedList;
        _filterEmployees();
      });

      print('✅ Fetch thành công: ${employeeList.length} nhân viên');
    } else {
      print('❌ Lỗi khi fetch nhân viên: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Lỗi kết nối: $e');
  }
}

void _filterEmployees() {
  String keyword = searchController.text.trim().toLowerCase();

  setState(() {
    filteredList = employeeList.where((employee) {
      // 1. Tìm kiếm theo từ khóa chung
      final matchesSearch = keyword.isEmpty
          ? true
          : employee.values.any((value) =>
              value != null &&
              value.toString().toLowerCase().contains(keyword));

      // 2. Lọc theo các trường cụ thể
      final matchesFilters = filters.entries.every((entry) {
        final key = entry.key;
        final filterValue = entry.value.trim().toLowerCase();

        if (filterValue.isEmpty) return true;

        final fieldValue = employee[key]?.toString().toLowerCase() ?? '';

        return fieldValue.startsWith(filterValue); // Có thể đổi thành contains nếu muốn fuzzy hơn
      });

      return matchesSearch && matchesFilters;
    }).toList();
  });
}

  Future<void> exportEmployeesToPDF(List<dynamic> employees) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Danh sách nhân viên',
                  style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: [
                  'Mã NV', 'Họ và tên', 'Ngày sinh', 'Địa chỉ',
                  'Email', 'SĐT', 'Ngày vào', 'Chức vụ', 'Phòng ban',
                ],
                data: employees.map((nv) {
                  return [
                    nv['MaNV'] ?? '',
                    nv['HoVaTen'] ?? '',
                    nv['NgaySinh'] ?? '',
                    nv['DiaChi'] ?? '',
                    nv['Email'] ?? '',
                    nv['SDT'] ?? '',
                    nv['NgayVaoLam'] ?? '',
                    nv['ChucVu'] ?? '',
                    nv['PhongBan'] ?? '',
                  ];
                }).toList(),
                cellStyle: pw.TextStyle(font: ttf, fontSize: 10),
                headerStyle: pw.TextStyle(font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
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
                    children: [
                      const Center(
                        child: Text(
                          'DANH SÁCH NHÂN VIÊN',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent, fontFamily: 'Inter'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Box
                      CustomSearchField(
                        controller: searchController,
                        onClear: () {
                          searchController.clear();
                          _filterEmployees();
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
                              {'label': 'Mã NV', 'value': 'MaNV'},
                              {'label': 'Họ và tên', 'value': 'HoVaTen'},
                              {'label': 'Ngày sinh', 'value': 'NgaySinh'},
                              {'label': 'Địa chỉ', 'value': 'DiaChi'},
                              {'label': 'Email', 'value': 'Email'},
                              {'label': 'Số điện thoại', 'value': 'SDT'},
                              {'label': 'URL hình ảnh', 'value': 'URLHinhAnh'},
                              {'label': 'Ngày vào làm', 'value': 'NgayVaoLam'},
                              {'label': 'Chức vụ', 'value': 'ChucVu'},
                              {'label': 'Phòng ban', 'value': 'PhongBan'},
                            ], 
                            filterValues: filters, 
                            onFilterChanged: (updated) {
                              setState(() => filters = updated);
                              _filterEmployees();
                            },
                          )
                        ),


                      const SizedBox(height: 8),

                      // Count and Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng số: ${filteredList.length}', style: const TextStyle(fontFamily: 'Inter')),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.print),
                                tooltip: 'Xuất PDF',
                                onPressed: () => exportEmployeesToPDF(filteredList),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm nhân viên',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Bảng dữ liệu nhân viên
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
                                  width: 80,
                                  child: Text(
                                    'Mã NV',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 160,
                                  child: Text(
                                    'Họ và tên',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Ngày sinh',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Địa chỉ',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 250,
                                  child: Text(
                                    'Email',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'SĐT',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 140,
                                  child: Text(
                                    'Ngày vào làm',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Chức vụ',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Phòng ban',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Ảnh',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                            ],
                            rows: filteredList.map((nhanVien) {
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
                                              builder: (_) => EditEmployee(staffData: nhanVien),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          nhanVien['MaNV'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: 'Inter'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(SizedBox(
                                    width: 160,
                                    child: Text(
                                      nhanVien['HoVaTen'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 120,
                                    child: Text(
                                      nhanVien['NgaySinh'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 200,
                                    child: Text(
                                      nhanVien['DiaChi'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 250,
                                    child: Text(
                                      nhanVien['Email'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 120,
                                    child: Text(
                                      nhanVien['SDT'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 140,
                                    child: Text(
                                      nhanVien['NgayVaoLam'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 120,
                                    child: Text(
                                      nhanVien['ChucVu'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 120,
                                    child: Text(
                                      nhanVien['PhongBan'] ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'Inter'),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 100,
                                    height: 60,
                                    child: nhanVien['URLHinhAnh'] != null &&
                                            nhanVien['URLHinhAnh'].toString().isNotEmpty
                                        ? Image.network(
                                            nhanVien['URLHinhAnh'],
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image),
                                          )
                                        : const Icon(Icons.image_not_supported),
                                  )),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  ManagePeopleScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
