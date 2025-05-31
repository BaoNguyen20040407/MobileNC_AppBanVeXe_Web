import 'package:flutter/material.dart';

class GuideStep1 extends StatelessWidget {
  const GuideStep1({super.key});
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // đủ chỗ cho padding và nội dung
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),  // ✅ Canh đều 4 phía
          color: const Color(0xffFDE5DE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/namhailogo.png",
                height: 32,
                width: 60,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "NHÀ XE NAM HẢI",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff006400),
                        fontFamily: 'Inter'
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Vì những chuyến xe an toàn cho bạn",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffFF0000),
                        fontFamily: 'Inter'
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/image/personicon.png",
                height: 32,
                width: 32,
              ),
            ],
          ),
        ),
      ),


      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: ListView(
            children: [
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  "HƯỚNG DẪN MUA VÉ XE TRÊN WEB",
                  style: TextStyle(
                      color: Color(0xffff5722),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                height: 380, // dài hơn để không bị chật
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffFDE5DE),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: Column( // dùng Column thay vì ListView vì không cần cuộn nội bộ ở đây
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Bước 1: Tìm kiếm chuyến xe",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff006400),
                              fontFamily: 'Inter'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Image.asset(
                          "image/guide1.png",
                          width: 308,
                          height: 75,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: const [
                            Text(
                              "Chọn loại chuyến đi: ",
                              style: TextStyle(fontSize: 15, fontFamily: 'Inter'),
                            ),
                            Text(
                              "Một chiều hoặc khứ hồi",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Chọn điểm đi và điểm đến dựa trên danh sách 63 tỉnh thành hiện nay.",
                          style: TextStyle(fontSize: 15, fontFamily: 'Inter'),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Chọn ngày đi theo mong muốn.",
                          style: TextStyle(fontSize: 15, fontFamily: 'Inter'),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Chọn số vé mà mình mong muốn.",
                          style: TextStyle(fontSize: 15, fontFamily: 'Inter'),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Thực hiện các bước trên, sau đó nhấn nút Tìm chuyến xe.",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }    
}