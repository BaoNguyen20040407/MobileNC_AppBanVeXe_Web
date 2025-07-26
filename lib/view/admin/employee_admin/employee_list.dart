import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/view/admin/home_admin/manage_people.dart';
import 'package:giao_dien_1/view/admin/employee_admin/add_employee.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaNV';
  bool showSearchOptions = false;

  Future<void> exportEmployeesToPDF(List<dynamic> employees) async {
  final pdf = pw.Document();

  // Load font Inter
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
                'Mã NV',
                'Họ và tên',
                'Ngày sinh',
                'Địa chỉ',
                'Email',
                'SĐT',
                'Ngày vào',
                'Chức vụ',
                'Phòng ban',
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
              headerStyle: pw.TextStyle(
                font: ttf,
                fontSize: 12,
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
    final List<dynamic> filteredList = []; // Chưa có dữ liệu

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
                          'DANH SÁCH NHÂN VIÊN',
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
                            children: [
                              _buildChoiceChip('Mã NV', 'MaNV'),
                              _buildChoiceChip('Họ tên', 'HoVaTen'),
                              _buildChoiceChip('SĐT', 'SDT'),
                              _buildChoiceChip('Email', 'Email'),
                              _buildChoiceChip('Chức vụ', 'ChucVu'),
                              _buildChoiceChip('Phòng ban', 'PhongBan'),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng số: ${filteredList.length}',
                            style: const TextStyle(fontFamily: 'Inter'),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.print),
                                tooltip: 'Xuất PDF',
                                onPressed: () => exportEmployeesToPDF(filteredList), // Gọi hàm xuất PDF
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                tooltip: 'Thêm nhân viên',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AddEmployeeScreen(),
                                      settings: const RouteSettings(name: '/add_employee'),
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
                  MaterialPageRoute(builder: (_) => ManagePeopleScreen()),
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
