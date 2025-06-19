import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/view/guide/mobile_instruction.dart';
import 'package:giao_dien_1/view/guide/web_instruction.dart';

class HuongDanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 390),
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Column(
              children: [
                Text(
                  'HƯỚNG DẪN MUA VÉ XE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainOrange,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Nơi bạn được hướng dẫn\nđể có thể mua vé xe một cách dễ dàng hơn',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InstructionWeb()),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.mainOrange,
                    ),
                    child: const Text(
                      "Xem hướng dẫn mua vé trên Web",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InstructionMobile()),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: AppColors.mainOrange,
                    ),
                    child: const Text(
                      "Xem hướng dẫn mua vé trên App",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/image/instruction_phone.png'),
                ),
                SizedBox(height: 16),
                Text(
                  'NHÀ XE NAM HẢI\nNHỮNG CHUYẾN ĐI AN TOÀN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),),
      bottomNavigationBar: FooterNavigation(),
    );
  }
}