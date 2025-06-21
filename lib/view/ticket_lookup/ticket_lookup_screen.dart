import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';

class TicketLookupScreen extends StatefulWidget {
  const TicketLookupScreen({super.key});

  @override
  State<TicketLookupScreen> createState() => _TicketLookupScreenState();
}

class _TicketLookupScreenState extends State<TicketLookupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ticketCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPhone();
    _phoneController.addListener(_savePhone);
  }

  Future<void> _loadPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone') ?? '';
    setState(() {
      _phoneController.text = phone;
    });
  }

  Future<void> _savePhone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', _phoneController.text.trim());
  }

  @override
  void dispose() {
    _phoneController.removeListener(_savePhone);
    _phoneController.dispose();
    _ticketCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              'TRA CỨU THÔNG TIN ĐẶT VÉ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainOrange,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tìm thông tin đặt vé của mình',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.mainOrange,
                  width: 8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ô nhập số điện thoại
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone, color: AppColors.mainOrange),
                      filled: true,
                      fillColor: Colors.white,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey400),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey400),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
                      ),
                    ),
                    cursorColor: AppColors.mainOrange,
                    style: TextStyle(fontSize: 16, color: AppColors.black87),
                  ),

                  // Ô nhập mã vé
                  TextField(
                    controller: _ticketCodeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number, color: AppColors.mainOrange),
                      hintText: 'Nhập mã vé',
                      filled: true,
                      fillColor: Colors.white,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hintStyle: TextStyle(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey400),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey400),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.mainOrange, width: 2),
                      ),
                    ),
                    cursorColor: AppColors.mainOrange,
                    style: TextStyle(fontSize: 16, color: AppColors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Nút tìm vé (chưa xử lý)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.mainOrange,
                      ),
                      child: const Text(
                        'Tìm vé',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Image.asset(
              'assets/image/lookup_illustration.png',
              height: 150,
            ),
            const SizedBox(height: 10),
            const Text(
              'NHÀ XE NAM HẢI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 20,
                fontFamily: 'Inter',
              ),
            ),
            const Text(
              'NHỮNG CHUYẾN ĐI AN TOÀN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 20,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }
}
