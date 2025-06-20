import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';

class InstructionMobile extends StatefulWidget {
  @override
  _InstructionMobileState createState() => _InstructionMobileState();
}

class _InstructionMobileState extends State<InstructionMobile> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> imagePaths = [
    'image/app_step_1.png',
    'image/app_step_2.png',
    'image/app_step_3.png',
    'image/app_step_4.png',
    'image/app_step_5a.png',
    'image/app_step_5b.png',
    'image/app_step_6.png',
  ];

  void _onDotTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'HƯỚNG DẪN MUA VÉ XE TRÊN APP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mainOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),

              // Slider hình ảnh
              Container(
                height: screenHeight * 0.58,
                alignment: Alignment.center,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imagePaths.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainOrange.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Điều hướng ảnh
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      iconSize: 30,
                      color: _currentIndex > 0
                          ? AppColors.mainOrange
                          : Colors.grey.shade300,
                      onPressed: () {
                        if (_currentIndex > 0) {
                          _onDotTapped(_currentIndex - 1);
                        }
                      },
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(imagePaths.length, (index) {
                          final bool isActive = index == _currentIndex;
                          return GestureDetector(
                            onTap: () => _onDotTapped(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isActive ? 14 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.mainOrange
                                    : AppColors.greyLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      iconSize: 30,
                      color: _currentIndex < imagePaths.length - 1
                          ? AppColors.mainOrange
                          : Colors.grey.shade300,
                      onPressed: () {
                        if (_currentIndex < imagePaths.length - 1) {
                          _onDotTapped(_currentIndex + 1);
                        }
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }
}