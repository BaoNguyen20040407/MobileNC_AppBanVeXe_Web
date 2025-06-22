import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/news/news_detail_01.dart';
import 'package:giao_dien_1/widget/section_title.dart';
import '../main/homepage.dart';
import 'package:giao_dien_1/widget/appbar.dart';
import 'package:giao_dien_1/widget/footer.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/data/news_data.dart';
import 'package:giao_dien_1/widget/news_item.dart';
import 'package:giao_dien_1/widget/see_more_button.dart';
import 'package:giao_dien_1/widget/news_card.dart';
import 'package:giao_dien_1/widget/back_button_custom.dart';

class PromotionNews extends StatefulWidget {
  const PromotionNews({super.key});

  @override
  State<PromotionNews> createState() => _NewsState();
}

class _NewsState extends State<PromotionNews> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          //Tin tức nổi bật
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             //Khuyến mãi
              SectionTitle(title: 'KHUYẾN MÃI'),
              const SizedBox(height: 32),

              NewsCard(
                imageUrl: newsList[0].imageUrl,
                title: newsList[0].title,
                time: newsList[0].time,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetail01()),
                  );
                },
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[8].imageUrl,
                      title: newsList[8].title,
                      time: newsList[8].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[9].imageUrl,
                      title: newsList[9].title,
                      time: newsList[9].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[10].imageUrl,
                      title: newsList[10].title,
                      time: newsList[10].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[11].imageUrl,
                      title: newsList[11].title,
                      time: newsList[11].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[8].imageUrl,
                      title: newsList[8].title,
                      time: newsList[8].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[9].imageUrl,
                      title: newsList[9].title,
                      time: newsList[9].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[10].imageUrl,
                      title: newsList[10].title,
                      time: newsList[10].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[11].imageUrl,
                      title: newsList[11].title,
                      time: newsList[11].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[8].imageUrl,
                      title: newsList[8].title,
                      time: newsList[8].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[9].imageUrl,
                      title: newsList[9].title,
                      time: newsList[9].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[10].imageUrl,
                      title: newsList[10].title,
                      time: newsList[10].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[11].imageUrl,
                      title: newsList[11].title,
                      time: newsList[11].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BackButtonCustom(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 142),
                  SeeMoreButton(
                    onPressed: () {
                      // Điều hướng đến trang khác
                    },
                  ),
                ],
              ),

              const SizedBox(height: 64),
            ]
          ),
        ),
  
        ),
      bottomNavigationBar: FooterNavigation(),
    );
  }
}