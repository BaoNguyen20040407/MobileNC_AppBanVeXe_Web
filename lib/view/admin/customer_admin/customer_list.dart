import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/customer_admin/edit_customer.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_people.dart';
import 'package:giao_dien_1/view/admin/customer_admin/add_customer.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/widget/filter_chip_with_input.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:async';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showSearchOptions = false;
  List<Map<String, dynamic>> customerList = [];
  List<Map<String, dynamic>> filteredList = [];
  Map<String, String> filters = {
    'MaKH': '',
    'HoVaTen': '',
    'NgaySinh': '',
    'DiaChi': '',
    'Email': '',
    'SDT': '',
    'URLHinhAnh': '',
  };

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchCustomers();

    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        fetchCustomers();
      });
    });
  }


  Future<void> fetchCustomers() async {
  try {
    final response = await http.get(Uri.parse('$baseURL/khachhang'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Kiểm tra xem có phải là Map trả về có 'data'
      final List<dynamic> jsonList =
          body is List ? body : body['data'];

      final List<Map<String, dynamic>> parsedList =
          List<Map<String, dynamic>>.from(jsonList.map((e) => Map<String, dynamic>.from(e)));

      setState(() {
        customerList = parsedList;
        _filterCustomers();
      });

      print('✅ Fetch thành công: ${customerList.length} khách hàng');
    } else {
      print('❌ Lỗi khi fetch khách hàng: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Lỗi kết nối: $e');
  }
}

void _filterCustomers() {
  String keyword = searchController.text.trim().toLowerCase();

  setState(() {
    filteredList = customerList.where((customer) {
      // 1. Kiểm tra từ khóa tìm kiếm chung
      final matchesSearch = keyword.isEmpty
          ? true
          : customer.values.any((value) =>
              value != null &&
              value.toString().toLowerCase().contains(keyword));

      // 2. Kiểm tra các bộ lọc chi tiết
      final matchesFilters = filters.entries.every((entry) {
        final key = entry.key;
        final filterValue = entry.value.trim().toLowerCase();

        if (filterValue.isEmpty) return true;

        final fieldValue = customer[key]?.toString().toLowerCase() ?? '';

        return fieldValue.startsWith(filterValue); // Lọc chính xác hơn
      });

      return matchesSearch && matchesFilters;
    }).toList();
  });
}

  Future<void> exportCustomersToPDF(List<dynamic> customers) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Danh sách khách hàng',
                  style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: ['Mã KH', 'Họ và tên', 'Ngày sinh', 'Địa chỉ', 'Email', 'SĐT'],
                data: customers.map((kh) {
                  return [
                    kh['MaKH'] ?? '',
                    kh['HoVaTen'] ?? '',
                    kh['NgaySinh'] ?? '',
                    kh['DiaChi'] ?? '',
                    kh['Email'] ?? '',
                    kh['SDT'] ?? '',
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
                          'DANH SÁCH KHÁCH HÀNG',
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
                          hintStyle: const TextStyle(fontFamily: 'Inter'),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              _filterCustomers();
                            }),
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
                      ),
                      const SizedBox(height: 16),
                      //Bộ lọc
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
                              {'label': 'Mã KH', 'value': 'MaKH'},
                              {'label': 'Họ và tên', 'value': 'HoVaTen'},
                              {'label': 'Ngày sinh', 'value': 'NgaySinh'},
                              {'label': 'Địa chỉ', 'value': 'DiaChi'},
                              {'label': 'Email', 'value': 'Email'},
                              {'label': 'Số điện thoại', 'value': 'SDT'},
                              {'label': 'URL hình ảnh', 'value': 'URLHinhAnh'},
                            ], 
                            filterValues: filters, 
                            onFilterChanged: (updated) {
                              setState(() => filters = updated);
                              _filterCustomers();
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
                                onPressed: () => exportCustomersToPDF(filteredList),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm khách hàng',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AddCustomerScreen(),
                                      settings: const RouteSettings(name: '/add_customer'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bảng dữ liệu khách hàng
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
                                    'Mã KH',
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
                                  width: 100,
                                  child: Text(
                                    'Ảnh',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                  ),
                                ),
                              ),
                            ],
                            rows: filteredList.map((khachHang) {
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
                                              builder: (context) => EditCustomerScreen(customerData: khachHang) 
                                            ),
                                          );
                                        },
                                        child: Text(
                                          khachHang['MaKH'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        khachHang['HoVaTen'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        khachHang['NgaySinh'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        khachHang['DiaChi'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        khachHang['Email'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        khachHang['SDT'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: 'Inter'),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 100,
                                      height: 60,
                                      child: khachHang['URLHinhAnh'] != null &&
                                              khachHang['URLHinhAnh'].toString().isNotEmpty
                                          ? Image.network(
                                              khachHang['URLHinhAnh'],
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image),
                                            )
                                          : const Icon(Icons.image_not_supported),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ManagePeopleScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
