import 'package:flutter/material.dart';
import 'package:giao_dien_1/screen/about_us_page3.dart';

class AboutUsPage2 extends StatelessWidget{
  const AboutUsPage2 ({super.key});

  @override
  Widget build(BuildContext context) {
    //header 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar (
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
        
          //BODY 
          
          child: Column(  mainAxisAlignment:MainAxisAlignment.start,
      children: [
        Text("TẦM NHÌN VÀ SỨ MỆNH ",style: TextStyle(color: Colors.deepOrange,fontSize: 25,fontWeight: FontWeight.bold),),
        SizedBox(height: 10  ,),
        Text("Vì 1 Việt Nam vững mạnh kinh tế - xã hội",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        //       
        
        Align(
  alignment: Alignment.centerLeft,
  child: Text.rich(
    TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 15, height: 1.6),
      children: [
        TextSpan(
          text: "Trở thành công ty uy tín hàng đầu Việt Nam với cam kết:\n",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        TextSpan(text: "• Tạo môi trường làm việc năng động, thân thiện.\n"),
        TextSpan(text: "• Lòng tin của khách hàng là chất lượng của công ty.\n"),
        TextSpan(text: "• Trở thành công ty vận tải hàng đầu đất nước.\n"),
        TextSpan(
          text: "Nam Hải ",
          style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
        ),
        TextSpan(text: "luôn phát triển để tạo nên một Việt Nam vững mạnh về kinh tế - xã hội."),
      ],
    ),
  ),
),      
      Image.network("https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRfyRsY3nWeaT8UpBV-HpSsLCKdDT0coA2YNvgZu_dlTwYlPGc2",width: 300,),
      Text("GIÁ TRỊ CỐT LÕI",style: TextStyle(color:Colors.deepOrange,fontSize:20,fontWeight: FontWeight.bold),),
      SizedBox(height: 10,),
      Text("Giá trị cốt lõi - Nam Hải",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),   
      RichText(
      text: TextSpan(style:TextStyle(color: Colors.black,fontSize: 14,height: 2),
      children: [
        TextSpan(text:"NAM:",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold)),       // \n ý nghĩa xuống dòng
        TextSpan(text:"Tượng trưng cho sự ấm áp, bao dung, hướng tới tương lai.\n "),       
        TextSpan(text:"HẢI:",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold)),
        TextSpan(text:"Tượng trưng cho sự bao la, rộng lớn và sâu sắc, nối kết các đại lục.\n"),
        TextSpan(text:"NAM HẢI:",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold)),
        TextSpan(text:"Những chuyến xe nối kết mọi nơi bằng sự ấm áp, bao dung.\n"),  
        
      ]      
      ),
      ),
      Image.network("https://www.shutterstock.com/image-photo/hand-holdig-plant-growing-on-260nw-2152039709.jpg",width: 300,),
      Text("TRIẾT LÝ",style: TextStyle(color: Colors.deepOrange,fontSize: 20,fontWeight: FontWeight.bold,),),
      Text("Hành trình an toàn",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,height:2),),
      Text("Nhà xe Nam Hải cam kết mang đến hành trình an toàn, chất lượng và đáng tin cậy cho mỗi hành khách. "
      "Chúng tôi đặt sự hài lòng của khách hàng lên hàng đầu, lấy uy tín và tận tâm làm kim chỉ nam trong mọi hoạt động."
      " Với tinh thần phục vụ chuyên nghiệp và sự đồng hành bền bỉ, Nam Hải không chỉ là phương tiện di chuyển mà còn là người bạn đồng hành tin cậy trên mỗi chặng đường,"
      " mang đến cho khách hàng những trải nghiệm tốt nhất, chất lượng nhất, sự an toàn chỉnh chu trong từng khâu phục vụ khách hàng, góp phần nâng cao nền kinh tế nước nhà."),
      Image.network("https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTbtJh7BPv2DbG6hGatmeEAXj6fckGDMS0GWU3VI5BpRXFJDyZy",width: 300,),      
      // Tạo nút 
      ElevatedButton(onPressed: (){
        Navigator.push(context,
        MaterialPageRoute(builder:(context) =>const AboutUsPage3()),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
       child: Text("Xem tiếp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
   
            ],
          ),
        ),
      ),
    );
  }
}
