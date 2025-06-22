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

class NewsNamhaicitybus extends StatefulWidget {
  const NewsNamhaicitybus({super.key});

  @override
  State<NewsNamhaicitybus> createState() => _NewsState();
}

class _NewsState extends State<NewsNamhaicitybus> {
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
              SectionTitle(title: 'NAMHAI City Bus'),
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
                      imageUrl: newsList[1].imageUrl,
                      title: newsList[1].title,
                      time: newsList[1].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[2].imageUrl,
                      title: newsList[2].title,
                      time: newsList[2].time,
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
                      imageUrl: newsList[3].imageUrl,
                      title: newsList[3].title,
                      time: newsList[3].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[4].imageUrl,
                      title: newsList[4].title,
                      time: newsList[4].time,
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
                      imageUrl: newsList[1].imageUrl,
                      title: newsList[1].title,
                      time: newsList[1].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[5].imageUrl,
                      title: newsList[5].title,
                      time: newsList[5].time,
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
                      imageUrl: newsList[6].imageUrl,
                      title: newsList[6].title,
                      time: newsList[6].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[7].imageUrl,
                      title: newsList[7].title,
                      time: newsList[7].time,
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
                      imageUrl: newsList[1].imageUrl,
                      title: newsList[1].title,
                      time: newsList[1].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[2].imageUrl,
                      title: newsList[2].title,
                      time: newsList[2].time,
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
                      imageUrl: newsList[3].imageUrl,
                      title: newsList[3].title,
                      time: newsList[3].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[7].imageUrl,
                      title: newsList[7].title,
                      time: newsList[7].time,
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

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      bottomNavigationBar: FooterNavigation(),
    );
  }
}