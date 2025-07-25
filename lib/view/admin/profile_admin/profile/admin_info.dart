import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/config/config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:giao_dien_1/widget/appbar_profile_admin.dart';

class AdminInfo extends StatefulWidget {
  const AdminInfo({super.key});

  @override
  State<AdminInfo> createState() => _AdminInfoState();
}

class _AdminInfoState extends State<AdminInfo> {
  String _hoVaTen = '';
  String _ngaySinh = '';
  String _diaChi = '';
  String _email = '';
  String _sdt = '';
  String _ngayVaoLam = '';
  String _chucVu = '';
  String _phongBan = '';
  String _maNV = '';
  String _avatarUrl = '';
  Uint8List? _avatarBytes;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadEmployeeInfo();
  }

  Future<void> _loadEmployeeInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null) return;

    final url = Uri.parse('$baseURL/api/full-admin/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final nv = data['data'];
        setState(() {
          _maNV = nv['MaNV'] ?? '';
          _hoVaTen = nv['HoVaTen'] ?? '';
          _ngaySinh = nv['NgaySinh'] ?? '';
          _diaChi = nv['DiaChi'] ?? '';
          _email = nv['Email'] ?? '';
          _sdt = nv['SDT'] ?? '';
          _ngayVaoLam = nv['NgayVaoLam'] ?? '';
          _chucVu = nv['ChucVu'] ?? '';
          _phongBan = nv['PhongBan'] ?? '';
          _username = nv['username'] ?? '';

          final imgPath = nv['URLHinhAnh'];
          if (imgPath != null && imgPath.isNotEmpty) {
            _avatarUrl = '$baseURL$imgPath';
            _avatarBytes = null; // ❗ Ưu tiên URL, bỏ local base64
          } else {
            // fallback: lấy từ local nếu không có ảnh trên server
            final base64 = prefs.getString('image_base64');
            if (base64 != null && base64.isNotEmpty) {
              _avatarBytes = base64Decode(base64);
            }
          }
        });
      }
    } else {
      print('❌ Lỗi khi load dữ liệu nhân viên');
    }
  }

  Future<void> _pickAndUploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null) return;

    final url = Uri.parse('$baseURL/api/upload-avatar-admin/$username');

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('avatar', pickedFile.path));
    
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      if (data['success'] == true) {
        final imagePath = data['imageUrl']; // e.g., /uploads/abc.jpg

        // Cập nhật lại avatar
        final newUrl = '$baseURL$imagePath';
        final bytes = await pickedFile.readAsBytes();

        setState(() {
          _avatarUrl = newUrl;
          _avatarBytes = bytes;
        });

        // Lưu vào SharedPreferences
        await prefs.setString('avatarUrl', imagePath);
        await prefs.setString('image_base64', base64Encode(bytes));
      }
    } else {
      print('❌ Upload avatar thất bại');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarAdminProfile(title: 'THÔNG TIN NHÂN VIÊN'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: _avatarBytes != null
                      ? MemoryImage(_avatarBytes!)
                      : (_avatarUrl.isNotEmpty
                          ? NetworkImage(_avatarUrl)
                          : const AssetImage('assets/image/personicon.png')) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.grey400, blurRadius: 4),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.camera_alt, size: 20, color: AppColors.black),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              _username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/image/vietnam_flag.png'),
                  width: 25,
                  height: 17,
                ),
                const SizedBox(width: 8),
                Text(
                  _sdt,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: 'THÔNG TIN CÁ NHÂN',
              content: Column(
                children: [
                  _buildInfoRow('Họ và tên', _hoVaTen),
                  const SizedBox(height: 8),
                  _buildInfoRow('Ngày sinh', _ngaySinh),
                  const SizedBox(height: 8),
                  _buildInfoRow('Địa chỉ', _diaChi),
                  const SizedBox(height: 8),
                  _buildInfoRow('Email', _email),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'THÔNG TIN NHÂN VIÊN',
              titleColor: AppColors.greenDark,
              content: Column(
                children: [
                  _buildInfoRow('Ngày vào làm', _ngayVaoLam),
                  const SizedBox(height: 8),
                  _buildInfoRow('Chức vụ', _chucVu),
                  const SizedBox(height: 8),
                  _buildInfoRow('Phòng ban', _phongBan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    Color titleColor = AppColors.greenDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14, fontFamily: 'Inter', color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }
}
