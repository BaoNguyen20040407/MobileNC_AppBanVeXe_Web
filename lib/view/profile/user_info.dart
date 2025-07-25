import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/profile/edit_user_info.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:giao_dien_1/config/config.dart';
import 'package:http/http.dart' as http;


class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String _avatarUrl = '';
  String _fullName = '';
  String _phone = '';
  String _dob = '';
  String _address = '';
  String _email = '';
  String _userName = '';
  String? _gender;
  String? _job;
  String? _intro;
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  if (username == null) return;

  // 🟢 Gọi API để lấy thông tin chính
  final url = Uri.parse('$baseURL/api/full-user/$username');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      final user = data['data'];
      print('📦 Dữ liệu user trả về từ API: ${jsonEncode(user)}');

      final imageUrl = user['URLHinhAnh'];
      if (imageUrl != null && imageUrl.isNotEmpty) {
        _avatarUrl = '$baseURL$imageUrl';
      }

      setState(() {
        _userName = user['username'] ?? '';
        _fullName = user['HoVaTen'] ?? '';
        _phone = user['SDT'] ?? '';
        _dob = user['NgaySinh'] ?? '';
        _address = user['DiaChi'] ?? '';
        _email = user['Email'] ?? '';
      });
    }
  } else {
    print('❌ Lỗi khi gọi API user-info: ${response.statusCode}');
  }

  // 🔵 Load thêm dữ liệu phụ từ SharedPreferences
  setState(() {
    final base64Image = prefs.getString('image_base64');
    if (base64Image != null && base64Image.isNotEmpty) {
      _avatarBytes = base64Decode(base64Image);
    }

    _gender = prefs.getString('gender');
    _job = prefs.getString('job');
    _intro = prefs.getString('intro');
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'THÔNG TIN TÀI KHOẢN'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 48,
              backgroundImage: _avatarBytes != null
                ? MemoryImage(_avatarBytes!)
                : (_avatarUrl.isNotEmpty
                    ? NetworkImage(_avatarUrl)
                    : const AssetImage('assets/image/personicon.png')) as ImageProvider,
            ),
            const SizedBox(height: 8),
            Text(
              _userName,
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
                  _phone,
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
              title: 'THÔNG TIN CƠ BẢN',
              content: Column(
                children: [
                  _buildInfoRow('Họ tên', _fullName),
                  const SizedBox(height: 8),
                  _buildInfoRow('Ngày sinh', _dob),
                  const SizedBox(height: 8),
                  _buildInfoRow('Nơi ở', _address),
                  const SizedBox(height: 8),
                  _buildInfoRow('Email', _email),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSection(
              title: 'THÔNG TIN THÊM',
              titleColor: AppColors.greenDark,
              content: Column(
                children: [
                  _buildInfoRow('Giới tính', _gender ?? ''),
                  const SizedBox(height: 8),
                  _buildInfoRow('Nghề nghiệp', _job ?? ''),
                  const SizedBox(height: 8),
                  _buildInfoRow('Giới thiệu về bản thân', _intro ?? ''),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: chuyển tới trang sửa thông tin
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditUserInfo()),
                    ).then((_) {
                    _loadUserInfo(); // reload dữ liệu mới sau khi chỉnh sửa
                  });
                },
                child: const Text(
                  'Sửa thông tin tài khoản',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
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
