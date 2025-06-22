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

class BusStopNews extends StatefulWidget {
  const BusStopNews({super.key});

  @override
  State<BusStopNews> createState() => _NewsState();
}

class _NewsState extends State<BusStopNews> {
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
              SectionTitle(title: 'TRẠM DỪNG'),
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
