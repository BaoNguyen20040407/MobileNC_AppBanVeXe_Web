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

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaNV';
  bool showSearchOptions = false;
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/nhanvien'));
      if (response.statusCode == 200) {
        setState(() {
          employees = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('❌ Error fetching employees: $e');
    }
  }

  Future<void> deleteEmployee(String maNV) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có chắc muốn xóa nhân viên $maNV không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await http.delete(Uri.parse('http://10.0.2.2:3000/nhanvien/$maNV'));
        if (response.statusCode == 200) {
          setState(() {
            employees.removeWhere((e) => e['MaNV'] == maNV);
          });
        } else {
          throw Exception('Delete failed');
        }
      } catch (e) {
        print('❌ Delete error: $e');
      }
    }
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
    final filteredList = employees.where((nv) {
      final value = nv[selectedColumn]?.toString().toLowerCase() ?? '';
      return value.contains(searchController.text.toLowerCase());
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
                    children: [
                      const Center(
                        child: Text(
                          'DANH SÁCH NHÂN VIÊN',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent, fontFamily: 'Inter'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Box
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Nhập từ khóa...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.mainOrange),
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
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildChoiceChip('Mã NV', 'MaNV'),
                            _buildChoiceChip('Họ tên', 'HoVaTen'),
                            _buildChoiceChip('SĐT', 'SDT'),
                            _buildChoiceChip('Email', 'Email'),
                            _buildChoiceChip('Chức vụ', 'ChucVu'),
                            _buildChoiceChip('Phòng ban', 'PhongBan'),
                          ],
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

                      if (filteredList.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Chưa có dữ liệu để hiển thị', style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Inter')),
                          ),
                        )
                      else
                        ListView.builder(
                          itemCount: filteredList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            final nv = filteredList[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text(nv['HoVaTen'][0])),
                              title: Text(nv['HoVaTen']),
                              subtitle: Text('Email: ${nv['Email']} - SDT: ${nv['SDT']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditAccountAdminScreen(staffData: nv),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteEmployee(nv['MaNV']),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  ManagePeopleScreen()));
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
