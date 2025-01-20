
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocation_app/services/auth_service.dart';
import 'package:geolocation_app/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/news_articles.dart';
import '../pages/data.dart';
import '../widgets/content_header.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/events.dart';
import '../widgets/news.dart';
import '../widgets/friends.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetIt _getIt = GetIt.instance;

  late ScrollController _scrollController;
  late AuthService _authService;
  late NavigationService _navigationService;

  double _scrollOffset = 0.0;

  final List<String> skylineImages = [
    'assets/images/skyline.png',
    'assets/images/skyline2.png',
    'assets/images/skyline3.png',
    // Add all the image paths here
  ];

  late String randomImagePath;
  late List<Article> articles = [];  // Declare the articles list

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();

    _getNews();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
    randomImagePath = _getRandomImagePath(); // Initialize random image path

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  String _getRandomImagePath() {
    final random = Random();
    return skylineImages[random.nextInt(skylineImages.length)];
  }

  Future<void> _getNews() async {
    try {
      final response = await dio.get();

      final articlesJson = response.data["articles"] as List;
      setState(() {
        articles = articlesJson.map((a) => Article.fromJson(a)).toList();
        articles = articles.where((a) => a.title != "[Removed]").toList();
      });
      print("Fetched ${articles.length} articles");
      // Print article titles for further confirmation
      for (var article in articles) {
        print(article.title);
      }
    } catch (e) {
      print("Error fetching news: $e");
    }
  }


  // Launch URL when the user taps on an article
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }



  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                ),
                child: Text(
                  'Navigation Drawer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () async {

                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('logout'),
                onTap: () async {
                  bool result = await _authService.logout();
                  if (result){
                    _navigationService.pushReplacementNamed("/login");
                  }
                },
              ),
            ],
          ),
        ),

        extendBodyBehindAppBar: true,
         appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 50.0),
          child: CustomAppBar(scrollOffset: _scrollOffset),
        ),
        body : CustomScrollView(controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: ContentHeader(
                key:  PageStorageKey('contentheader'),
                imagePath: randomImagePath),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 20.0),
              sliver: SliverToBoxAdapter(

                child: Friends(
                  key: PageStorageKey('friends'),
                  title: 'Friends',
                  contentList: friends,
                ),
              ),
            ),

            SliverToBoxAdapter(

              child: Events(
                key: PageStorageKey('events'),
                title: "Events", // Pass the function to launch URLs
                contentList: posters,
              ),
            ),

            SliverToBoxAdapter(

              child: News(
                key: PageStorageKey('news'),
                title: "News in your area!",
                articles: articles,
                onArticleTap: _launchUrl, // Pass the function to launch URLs

              ),
            ),

          ],
        )
    );
  }
}
