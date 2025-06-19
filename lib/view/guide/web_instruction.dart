import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/news/news.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/config/default.dart';

class InstructionWeb extends StatefulWidget {
  @override
  _InstructionWebState createState() => _InstructionWebState();
}

class _InstructionWebState extends State<InstructionWeb> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> imagePaths = [
    'assets/image/web_step_1.png',
    'assets/image/web_step_2.png',
    'assets/image/web_step_3.png',
    'assets/image/web_step_4.png',
    'assets/image/web_step_5.png',
    'assets/image/web_step_5b.png',
    'assets/image/web_step_6.png',
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
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mainOrange.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imagePaths.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    iconSize: 28,
                    onPressed: () {
                      if (_currentIndex > 0) {
                        _onDotTapped(_currentIndex - 1);
                      }
                    },
                  ),
                  Row(
                    children: List.generate(imagePaths.length, (index) {
                      bool isSelected = _currentIndex == index;
                      return GestureDetector(
                        onTap: () => _onDotTapped(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 14 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isSelected
                                ?  AppColors.mainOrange
                                :  AppColors.greyLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    iconSize: 28,
                    onPressed: () {
                      if (_currentIndex < imagePaths.length - 1) {
                        _onDotTapped(_currentIndex + 1);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterNavigation(),
    );
  }
}