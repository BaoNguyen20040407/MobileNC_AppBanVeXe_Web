import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/admin/employee_admin/employee_list.dart';
import 'package:giao_dien_1/widget/input_field.dart';
import 'package:giao_dien_1/widget/appbar_admin.dart';
import 'package:giao_dien_1/view/admin/employee_admin/edit_employee_success.dart';
import 'package:giao_dien_1/widget/edit_action_button.dart';

class EditAccountAdminScreen extends StatefulWidget {
  final Map<String, dynamic> staffData;

  const EditAccountAdminScreen({super.key, required this.staffData});

  @override
  State<EditAccountAdminScreen> createState() => _EditAccountAdminScreenState();
}

class _EditAccountAdminScreenState extends State<EditAccountAdminScreen> {
  late TextEditingController _maNVController;
  late TextEditingController _hoTenController;
  late TextEditingController _ngaySinhController;
  late TextEditingController _diaChiController;
  late TextEditingController _emailController;
  late TextEditingController _sdtController;
  late TextEditingController _urlHinhAnhController;
  late TextEditingController _ngayVaoLamController;
  late TextEditingController _chucVuController;
  late TextEditingController _phongBanController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _maNVController = TextEditingController(text: widget.staffData['MaNV']);
    _hoTenController = TextEditingController(text: widget.staffData['HoVaTen']);
    _ngaySinhController = TextEditingController(text: widget.staffData['NgaySinh']);
    _diaChiController = TextEditingController(text: widget.staffData['DiaChi']);
    _emailController = TextEditingController(text: widget.staffData['Email']);
    _sdtController = TextEditingController(text: widget.staffData['SDT']);
    _urlHinhAnhController = TextEditingController(text: widget.staffData['URLHinhAnh']);
    _ngayVaoLamController = TextEditingController(text: widget.staffData['NgayVaoLam']);
    _chucVuController = TextEditingController(text: widget.staffData['ChucVu']);
    _phongBanController = TextEditingController(text: widget.staffData['PhongBan']);
  }

  @override
  void dispose() {
    _maNVController.dispose();
    _hoTenController.dispose();
    _ngaySinhController.dispose();
    _diaChiController.dispose();
    _emailController.dispose();
    _sdtController.dispose();
    _urlHinhAnhController.dispose();
    _ngayVaoLamController.dispose();
    _chucVuController.dispose();
    _phongBanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EditEmployeeSuccess()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBarAdmin(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'THÔNG TIN NHÂN VIÊN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 32),

                CustomInputField(
                  controller: _maNVController,
                  labelText: "Mã NV",
                  prefixIcon: Icons.perm_identity,
                  readOnly: true,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _hoTenController,
                  labelText: "Họ và tên",
                  prefixIcon: Icons.person,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _ngaySinhController,
                  labelText: "Ngày sinh",
                  prefixIcon: Icons.cake,
                  readOnly: true,
                  onTap: () => _selectDate(_ngaySinhController),
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _ngayVaoLamController,
                  labelText: "Ngày vào làm",
                  prefixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () => _selectDate(_ngayVaoLamController),
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _diaChiController,
                  labelText: "Địa chỉ",
                  prefixIcon: Icons.home,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _sdtController,
                  labelText: "SĐT",
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _urlHinhAnhController,
                  labelText: "URL hình ảnh",
                  prefixIcon: Icons.image,
                  keyboardType: TextInputType.url,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _chucVuController,
                  labelText: "Chức vụ",
                  prefixIcon: Icons.work,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 16),

                CustomInputField(
                  controller: _phongBanController,
                  labelText: "Phòng ban",
                  prefixIcon: Icons.apartment,
                  showToggleVisibility: false,
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: EditActionButton(
                          onPressed: _submitForm,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                                actionsPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                                title: const Text(
                                  'Bạn có chắc không?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                content: const Text(
                                  'Dữ liệu này có thể bị xóa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    color: Colors.black87,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.end,
                                actions: [
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                        const BorderSide(color: Colors.black),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                      foregroundColor: MaterialStateProperty.all(Colors.black),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text(
                                      'Hủy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      elevation: 0,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Xóa',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                  contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                                  actionsPadding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
                                  title: const Text(
                                    'Xóa thành công!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: const Text(
                                    'Dữ liệu đã được xóa khỏi hệ thống.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      color: Colors.black87,
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.end,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => const EmployeeListScreen()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Đóng',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            side: const BorderSide(color: AppColors.mainOrange, width: 1.2),
                            elevation: 3,
                            shadowColor: AppColors.mainOrange.withOpacity(0.2),
                          ).copyWith(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Xóa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
