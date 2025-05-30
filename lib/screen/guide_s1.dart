import 'package:flutter/material.dart';

class GuideStep1 extends StatelessWidget {
  const GuideStep1({super.key});
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0), 
          child: AppBar( 
        backgroundColor: Color(0xfffde5ed),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0,), 
          child: Image.asset(
            "assets/image/namhailogo.png",
            height: 32,
            width: 50,
          ),
        ),
        title: SafeArea(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                  "NHÀ XE NAM HẢI",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
            Text(
                  "Vì những chuyến xe an toàn cho bạn",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
          ],
          ),
        ),
        actions: [
          IconButton(onPressed: null, icon: Image.asset("image/personicon.png",height: 32,width: 32,)),
        ],
      ),
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: ListView(
            children: [
               const SizedBox(height: 25),
               const Center(
                  child: Text("HƯỚNG DẪN MUA VÉ XE TRÊN WEB",
                  style: TextStyle(color: Color(0xffff5722), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
               ),
               const SizedBox(height: 25),
              Container(
                height: 300,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xfffde5ed),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "Bước 1: Tìm kiếm chuyến xe",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset("image/guide1.png",width: 308,height: 75,),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 30, // Đặt chiều cao cố định cho ListView ngang
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            Text(
                              "Chọn loại chuyến đi: ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "Một chiều hoặc khứ hồi",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Chọn điểm đi và điểm đến dựa trên danh sách 63 tỉnh thành hiện nay.",
                        style: TextStyle(fontSize: 15),
                      ),
                      const Text(
                        "Chọn ngày đi theo mong muốn.",
                        style: TextStyle(fontSize: 15),
                      ),
                      const Text(
                        "Chọn số vé mà mình mong muốn.",
                        style: TextStyle(fontSize: 15),
                      ),
                      const Text(
                        "Thực hiện các bước trên, sau đó nhấn nút Tìm chuyến xe.",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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