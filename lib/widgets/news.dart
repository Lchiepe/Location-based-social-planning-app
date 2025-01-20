import 'package:flutter/material.dart';
import 'package:geolocation_app/model/news_articles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/news_api.dart';

class News extends StatelessWidget {
  final String title;
  final List<Article> articles;
  final Future<void> Function(Uri) onArticleTap;


  const News({
    Key? key,
    required this.title,
    required this.articles,
    required this.onArticleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 25.0,color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        // Display a simple list of articles
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: articles.map((article) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      _launchUrl(
                        Uri.parse(article.url ?? ""),
                      );
                    },
                    leading: Image.network(
                      article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
                      height: 250,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      article.title ?? "",
                    ),
                    subtitle: Text(
                      article.publishedAt ?? "",
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
