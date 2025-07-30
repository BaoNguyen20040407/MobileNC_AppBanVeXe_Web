import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/customer_admin/edit_customer.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_people.dart';
import 'package:giao_dien_1/view/admin/customer_admin/add_customer.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaKH';
  bool showSearchOptions = false;
  List<dynamic> customerList = [];
  List<dynamic> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchAllCustomers();
  }

  Future<void> fetchAllCustomers() async {
    final url = Uri.parse('http://10.0.2.2:3000/khachhang');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          customerList = jsonResponse['data'];
          filteredList = customerList;
        });
      } else {
        print('❌ Lỗi khi lấy danh sách: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception khi lấy danh sách: $e');
    }
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

  Future<void> _deleteCustomer(String maKH) async {
    final url = Uri.parse('http://10.0.2.2:3000/khachhang/$maKH');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Đã xóa khách hàng')),
          );
          setState(() {
            filteredList.removeWhere((kh) => kh['MaKH'] == maKH);
            customerList.removeWhere((kh) => kh['MaKH'] == maKH);
          });
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Lỗi khi gọi API xóa');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Không thể xóa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final search = searchController.text.toLowerCase();
    filteredList = customerList.where((customer) {
      final value = (customer[selectedColumn] ?? '').toString().toLowerCase();
      return value.contains(search);
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
                            children: [
                              ChoiceChipSelector(label: 'Mã KH', value: 'MaKH', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Họ tên', value: 'HoVaTen', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'SĐT', value: 'SDT', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Email', value: 'Email', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
                              ChoiceChipSelector(label: 'Địa chỉ', value: 'DiaChi', selectedValue: selectedColumn, onSelected: (val) => setState(() => selectedColumn = val)),
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
                                  'Không tìm thấy khách hàng.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final kh = filteredList[index];

                                return ListTile(
                                  title: Text(kh['HoVaTen'] ?? ''),
                                  subtitle: Text('Mã: ${kh['MaKH']} - Email: ${kh['Email']}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditCustomerScreen(customerData: kh),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Xác nhận'),
                                              content: Text('Bạn có chắc muốn xóa khách hàng ${kh['HoVaTen']} không?'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
                                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            await _deleteCustomer(kh['MaKH']);
                                          }
                                        },
                                      ),
                                    ],
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
