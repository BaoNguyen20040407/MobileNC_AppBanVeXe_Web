import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
int remainingSeconds = 15 * 60; // 15 phút
 final List<String> items1 = [
  'assets/image/vietqr.png',
  'assets/image/atm.png',
  'assets/image/vnpay.png',
  
 ];
 final List<String> items2 = [
  
  'assets/image/visa.png',
  'assets/image/viettel.png',
  'assets/image/spay.png',
  
 ];
 final List<String> items3 = [
  'assets/image/momo.png',
  'assets/image/zalopay.png',
 ];

String _name = '';
String _phone = '';
String _email = '';

Future<void> _loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final savedName = prefs.getString('full_name');
  final savedPhone = prefs.getString('phone');
  final savedEmail = prefs.getString('email');
  _name = savedName ?? '';
  _phone = savedPhone ?? '';
  _email = savedEmail ?? '';
}

  @override
  void initState() {
    super.initState();
    startCountdown();
    _loadUser();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  String get timerDisplay {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'TP. HỒ CHÍ MINH - HÀ NỘI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '16/04/2025',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Tổng thanh toán',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '140.000Đ',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.grey400,
                ),
                child: Column(
                  children: [
                    Text(
                      'Thời gian giữ chỗ còn lại $timerDisplay',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/image/qrcode.png', // Ảnh QR giả
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nhận tiền từ mọi Ngân hàng và Ví điện tử',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 24),
              Text(
                'Hướng dẫn thanh toán bằng Momo',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  instructionRow("1", "Mở ứng dụng Momo trên app điện thoại"),
                  instructionRow("2", "Dùng biểu tượng để quét mã QR"),
                  instructionRow("3", "Quét mã ở trang này và thanh toán"),
                ],
              ),
             
                  ],
                ),
              ),
               SizedBox(height: 12),
            //Ngân Hàng
             Container(
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Chọn ngân hàng thanh toán',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      SizedBox(height: 8),
      SizedBox(
        height: 50, // Chiều cao của hàng ảnh
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items1.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  items1[index],
                  width: 80,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(
        height: 50, // Chiều cao của hàng ảnh
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items2.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  items2[index],
                  width: 80,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(
        height: 50, // Chiều cao của hàng ảnh
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items3.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  items3[index],
                  width: 80,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      )
    ],
  ),
  ),
),
SizedBox(height: 12),
//Thông tin user
              Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: 8),
                  Text('Thông tin khách hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 8),
                  Text('Họ tên: $_name'),
                  Text('Số điện thoại: $_phone'),
                  Text('Email: $_email'),
                  ],
                ),
              ),

//Chờ trang đặt vé




//Chờ trang đặt vé
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }

  Widget instructionRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 12,
            child: Text(
              number,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
