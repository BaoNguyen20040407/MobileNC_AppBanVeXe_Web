import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/about_us.dart';

class AboutUsPage3 extends StatelessWidget   {
  const AboutUsPage3 ({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Nhà Xe Nam Hải ", style: TextStyle(color: Color.fromARGB(255, 25, 75, 27),fontSize: 25,fontWeight: FontWeight.bold,), ),
              Text("Vì những chuyến xe an toàn cho bạn", style: TextStyle(color:Colors.deepOrange,fontSize: 15),),    
            ],
          ),
          backgroundColor: Color.fromARGB(255, 255, 202, 186),       
        ),
        body:  SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 40),
          //body 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Text("CƠ SỞ VẬT CHẤT",style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold),), 

             Text.rich(
            TextSpan(style: TextStyle(color: Colors.black,fontSize: 15),
              children:[

                TextSpan(text: "Tuân thủ phương châm “Vì những chuyến xe an toàn cho bạn”."
                " Công ty quản lý xe khách Nam Hải hiện đang khai thác hơn 250 phòng vé, với đội ngũ nhân viên lên 9.000 người."
                " Chúng tôi hiện đang sở hữu 4.500 đầu xe các loại, trong đó có hơn 1.500 xe giường nằm, vận hành hơn 125 tuyến liên tỉnh với 5.500 chuyến được khai thác mỗi ngày. "),
                TextSpan(text: "Thương hiệu Nam Hải đã trở thành thương hiệu được lựa chọn của hàng triệu lượt khách mỗi năm.",style: TextStyle(fontWeight: FontWeight.bold)),           
              ]             
              ),           
          ),
          Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8_5v4bhbKVRI-JJBWylQXCNsUwpyGxP9QeOrvobLLI2GrYPCG",width: 200,),
          SizedBox(height: 10,),
          Text("TRẠM DỪNG CHÂN",style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold),),
          Text("Nắm bắt được nhu cầu nghỉ ngơi sau những chuyến đi dài qua nhiều thành phố. "
          "Công ty có một số trạm dừng chân tọa lạc tại các tỉnh thành như: Thủ đô Hà Nội, TP. Đà Nẵng, TP. Nha Trang, Bình Thuận TP. Hồ Chí Minh, Bình Dương, TP. Cần Thơ, Bạc Liêu, Cà Mau"),
          SizedBox(height: 10,),
          Text("Các trạm dừng chân Nam Hải Vui Tươi với chỗ nghỉ đầy đủ tiện nghi (giường, chiếu, phòng máy lạnh...), phục vụ những món ăn đặc sản theo vùng miền."),
          Image.network("https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTxgHv1LmSeqt8Ckwiwk-YfXBExQwBIsuV8-3D5LnT8LpngHbbJ",width: 300,),
          SizedBox(height: 10,),
          
          Text("APPLICATION",style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold),),
          Text.rich(
            TextSpan(style: TextStyle(color: Colors.black,fontSize: 15),
            children: [
              TextSpan(text: "Cùng với việc mở rộng mạng lưới phát triển, Công ty hiện tại đang ứng dụng những công nghệ tiên tiên mới nhất vào hoạt động kinh doanh. "
              "Khách hàng chỉ cần một chiếc điện thoại và với vài thao tác đơn giản là đã có thể đặt được vé xe như mong muốn,"
              " cũng như tận hưởng những chương trình khuyến mãi của các đối tượng trong từng thời điểm.Hãy trải nghiệm"),
              TextSpan(text:" Nam Hải App",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              TextSpan(text: "ngay để tận hưởng những tiện nghi công nghệ thông tin mới nhất - chúng tôi luôn hân hạnh phục vụ bạn.")
            ]
            ),           
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
       child: Text("Trở về trang chủ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          ),
          Container(          
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
           onPressed: () {
            print('Bấm Trang chủ');
           },
           child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
       Image.network("https://img.icons8.com/?size=100&id=73&format=png&color=000000",width: 24,),
        SizedBox(height: 4), // khoảng cách giữa icon và chữ
       Text('Trang chủ'),
    ],
  ),
),   
              TextButton(
                onPressed: () {
                  print('Bấm Lịch trình');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround ,
                  children: [
                    Image.network("https://img.icons8.com/?size=100&id=23&format=png&color=000000",width: 24,),
                    SizedBox(height: 4,),
                    Text("Lịch trình"),
                    
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  print('Bấm Tra cứu vé');
                },
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network("https://img.icons8.com/?size=100&id=3665&format=png&color=000000",width: 24,),
                    SizedBox(height: 4,),
                    Text("Tra cứu vé"),                 
                ],),
                
              ),
              TextButton(
                onPressed: () {
                  print('Bấm Tin tức');
                },
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network("https://img.icons8.com/?size=100&id=532&format=png&color=000000",width: 24,),
                    SizedBox(height: 4,),
                    Text("Tin tức"),      
                  
                ],),
              ),
            ],
          ),

          ) 
            ]
          ),
         
        ),
      ),
    );
  }
}