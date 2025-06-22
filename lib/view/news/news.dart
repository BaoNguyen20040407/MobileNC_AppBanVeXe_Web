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
import 'package:giao_dien_1/view/news/award_news.dart';
import 'package:giao_dien_1/view/news/bus_stop_news.dart';
import 'package:giao_dien_1/view/news/news_namhaibusline.dart';
import 'package:giao_dien_1/view/news/news_namhaicitybus.dart';
import 'package:giao_dien_1/view/news/promotion_news.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
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
              SectionTitle(title: 'TIN TỨC NỔI BẬT'),
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

              const SizedBox(height: 16),
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

              const SizedBox(height: 16),

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
              const SizedBox(height: 64),

              //NAMHAI Bus Lines
              SectionTitle(title: 'NAMHAI Bus Lines'),
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
              
              SeeMoreButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewsNamhaibusline(),
                      settings: const RouteSettings(name: '/nam_hai_bus_lines'),
                    ),
                  );
                },
              ),


              const SizedBox(height: 64),

              //NAMHAI City Bus
              SectionTitle(title: 'NAMHAI City Bus'),
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
              
              SeeMoreButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewsNamhaicitybus(),
                      settings: const RouteSettings(name: '/nam_hai_city_bus'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 64),

              //Khuyến mãi
              SectionTitle(title: 'KHUYẾN MÃI'),
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
              
              SeeMoreButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PromotionNews(),
                      settings: const RouteSettings(name: '/promotion_news'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 64),

              //Giải thưởng
              SectionTitle(title: 'GIẢI THƯỞNG'),
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
              
              SeeMoreButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AwardNews(),
                      settings: const RouteSettings(name: '/award_news'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 64),

              //Trạm dừng
              SectionTitle(title: 'TRẠM DỪNG'),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[16].imageUrl,
                      title: newsList[16].title,
                      time: newsList[16].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[17].imageUrl,
                      title: newsList[17].title,
                      time: newsList[17].time,
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
                      imageUrl: newsList[18].imageUrl,
                      title: newsList[18].title,
                      time: newsList[18].time,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: NewsItem(
                      imageUrl: newsList[19].imageUrl,
                      title: newsList[19].title,
                      time: newsList[19].time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              SeeMoreButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BusStopNews(),
                      settings: const RouteSettings(name: '/bus_stop_news'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: FooterNavigation(),
    );
  }
}