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

class AwardNews extends StatefulWidget {
  const AwardNews({super.key});

  @override
  State<AwardNews> createState() => _NewsState();
}

class _NewsState extends State<AwardNews> {
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
              SectionTitle(title: 'GIẢI THƯỞNG'),
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
                      imageUrl: newsList[12].imageUrl,
                      title: newsList[12].title,
                      time: newsList[12].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[13].imageUrl,
                      title: newsList[13].title,
                      time: newsList[13].time,
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
                      imageUrl: newsList[14].imageUrl,
                      title: newsList[14].title,
                      time: newsList[14].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[15].imageUrl,
                      title: newsList[15].title,
                      time: newsList[15].time,
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
                      imageUrl: newsList[12].imageUrl,
                      title: newsList[12].title,
                      time: newsList[12].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[13].imageUrl,
                      title: newsList[13].title,
                      time: newsList[13].time,
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
                      imageUrl: newsList[14].imageUrl,
                      title: newsList[14].title,
                      time: newsList[14].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[15].imageUrl,
                      title: newsList[15].title,
                      time: newsList[15].time,
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
                      imageUrl: newsList[12].imageUrl,
                      title: newsList[12].title,
                      time: newsList[12].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[13].imageUrl,
                      title: newsList[13].title,
                      time: newsList[13].time,
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
                      imageUrl: newsList[14].imageUrl,
                      title: newsList[14].title,
                      time: newsList[14].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[15].imageUrl,
                      title: newsList[15].title,
                      time: newsList[15].time,
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
                      imageUrl: newsList[12].imageUrl,
                      title: newsList[12].title,
                      time: newsList[12].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[13].imageUrl,
                      title: newsList[13].title,
                      time: newsList[13].time,
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
                      imageUrl: newsList[14].imageUrl,
                      title: newsList[14].title,
                      time: newsList[14].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[15].imageUrl,
                      title: newsList[15].title,
                      time: newsList[15].time,
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
                      imageUrl: newsList[12].imageUrl,
                      title: newsList[12].title,
                      time: newsList[12].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[13].imageUrl,
                      title: newsList[13].title,
                      time: newsList[13].time,
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
                      imageUrl: newsList[14].imageUrl,
                      title: newsList[14].title,
                      time: newsList[14].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[15].imageUrl,
                      title: newsList[15].title,
                      time: newsList[15].time,
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
            ]
          ),
        ),
        ),
      bottomNavigationBar: FooterNavigation(),
    );
  }
}