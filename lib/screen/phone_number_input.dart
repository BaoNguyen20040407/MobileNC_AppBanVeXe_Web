import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/welcome.dart';

class Phone_Number_Input extends StatefulWidget {
  const Phone_Number_Input({super.key});

  @override
  State<Phone_Number_Input> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<Phone_Number_Input> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose(); // Giải phóng bộ nhớ khi widget bị huỷ
    super.dispose();
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
            Navigator.pop(context); // quay về trang trước
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Số điện thoại",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Icon(Icons.phone),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5722), width: 2.0),
                  ),
                  hintText: 'VD: 0987654321',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Welcome()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    minimumSize: const Size(double.infinity, 54),
                  ),
                  child: const Text(
                    "Tiếp tục",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
