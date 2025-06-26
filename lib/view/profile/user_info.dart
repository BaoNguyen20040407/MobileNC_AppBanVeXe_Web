import 'package:flutter/material.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/view/profile/edit_user_info.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('image_url') ?? '';
      _fullName = prefs.getString('full_name') ?? '';
      _userName = prefs.getString('username') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _dob = prefs.getString('dob') ?? '';
      _address = prefs.getString('address') ?? '';
      _email = prefs.getString('email') ?? '';
      _gender = prefs.getString('gender');
      _job = prefs.getString('job');
      _intro = prefs.getString('intro');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: const AppBarProfile(title: 'THÔNG TIN TÀI KHOẢN'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 48,
              backgroundImage: _avatarUrl.isNotEmpty
                  ? NetworkImage(_avatarUrl)
                  : const AssetImage('assets/image/personicon.png') as ImageProvider,
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
