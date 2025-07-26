import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/home_admin/homeadmin.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/widget/exit_button.dart';
import 'package:giao_dien_1/widget/choice_chip_selector.dart';
import 'package:giao_dien_1/widget/pagination_control.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedColumn = 'MaVe';
  bool showSearchOptions = false;

  // Giả lập danh sách vé, sau này thay bằng API call
  final List<Map<String, dynamic>> filteredList = [];

  Future<void> exportTicketsToPDF(List<dynamic> tickets) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/font/inter_18pt_regular.ttf');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Table.fromTextArray(
          headers: [
            'Mã vé',
            'SĐT',
            'Tên khách',
            'Tuyến',
            'Ngày đi',
            'Chỗ',
          ],
          data: tickets.map((ticket) {
            return [
              ticket['MaVe'] ?? '',
              ticket['SDT'] ?? '',
              ticket['HoTenKH'] ?? '',
              '${ticket['DiemDi']} - ${ticket['DiemDen']}',
              ticket['NgayDi'] ?? '',
              ticket['GheNgoi'] ?? '',
            ];
          }).toList(),
          cellStyle: pw.TextStyle(font: ttf, fontSize: 11),
          headerStyle: pw.TextStyle(
              font: ttf, fontSize: 13, fontWeight: pw.FontWeight.bold),
          border: pw.TableBorder.all(width: 0.5),
          headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.centerLeft,
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
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
                          'DANH SÁCH VÉ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ô tìm kiếm
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

                      // Tùy chọn tìm kiếm
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
                              ChoiceChipSelector(
                                label: 'Mã vé',
                                value: 'MaVe',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                              ChoiceChipSelector(
                                label: 'Loại vé',
                                value: 'LoaiVe',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                              ChoiceChipSelector(
                                label: 'Vị trí ghế',
                                value: 'ViTriGheNgoi',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                              ChoiceChipSelector(
                                label: 'Trạng thái',
                                value: 'TrangThai',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                              ChoiceChipSelector(
                                label: 'Thanh toán',
                                value: 'HinhThucThanhToan',
                                selectedValue: selectedColumn,
                                onSelected: (val) => setState(() => selectedColumn = val),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Thống kê + nút thêm (vô hiệu)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng số: ${filteredList.length}',
                            style: const TextStyle(fontFamily: 'Inter'),
                          ),
                          Row(
                            children: [
                              Tooltip(
                                message: 'In danh sách vé PDF',
                                child: IconButton(
                                  icon: const Icon(Icons.print),
                                  onPressed: () => exportTicketsToPDF(filteredList),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                message: 'Không thể thêm vé thủ công',
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.grey),
                                  onPressed: null, // Vô hiệu hóa
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dữ liệu hoặc thông báo trống
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
                                  'Chưa có dữ liệu để hiển thị',
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
                                final ve = filteredList[index];
                                return ListTile(
                                  title: Text('Mã vé: ${ve['MaVe']}', style: const TextStyle(fontFamily: 'Inter')),
                                  subtitle: Text('Ghế: ${ve['ViTriGheNgoi']} - ${ve['LoaiVe']}'),
                                  trailing: Text('${ve['GiaVe']}đ'),
                                );
                              },
                            ),

                      const SizedBox(height: 16),

                      // Phân trang
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
                  MaterialPageRoute(builder: (_) => HomeAdmin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
