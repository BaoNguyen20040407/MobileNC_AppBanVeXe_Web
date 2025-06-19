import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/auth/welcome.dart';
import 'package:giao_dien_1/widget/orange_button_1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/widget/input_field.dart';

class Phone_Number_Input extends StatefulWidget {
  const Phone_Number_Input({super.key});

  @override
  State<Phone_Number_Input> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<Phone_Number_Input> {
  final TextEditingController _phoneController = TextEditingController();
  String? _phoneError; 

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _savePhoneNumber(String phone) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('phone_number', phone);
  }

  void _handleContinue() {
    final phone = _phoneController.text.trim();
    final phonePattern = RegExp(r'^0\d{9}$');
    if (!phonePattern.hasMatch(phone)) {
      setState(() {
        _phoneError = 'Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 64),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nhập số điện thoại',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomInputField(
                controller: _phoneController,
                labelText: "Số điện thoại",
                hintText: "VD: 0987654321",
                prefixIcon: Icons.phone,
                errorText: _phoneError,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  final phonePattern = RegExp(r'^0\d{9}$');
                  if (value.isEmpty || phonePattern.hasMatch(value)) {
                    _phoneError = null;
                  } else {
                    _phoneError = 'Số điện thoại phải có đúng 10 chữ số và bắt đầu bằng số 0';
                  }
                  setState(() {}); // Cập nhật UI
                },
              ),

              const SizedBox(height: 32),
              OrangeButton1(
                text: "Tiếp tục", 
                onPressed: () async{
                  _handleContinue();
                  if (_phoneError == null) {
                    await _savePhoneNumber(_phoneController.text.trim());
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const Welcome())
                    );
                  }
                }),
              const SizedBox(height: 32),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Inter',
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Bằng việc nhập số điện thoại, bạn có thể kích hoạt tài khoản và bắt đầu trải nghiệm trên app của ',
                    ),
                    TextSpan(
                      text: 'Nhà Xe Nam Hải',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}