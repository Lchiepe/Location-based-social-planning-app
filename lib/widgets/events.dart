import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/content_model.dart';

class Events extends StatelessWidget {
  final String title;
  final List<Content> contentList;


  const Events({
    Key? key,
    required this.title,
    required this.contentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05, // 5% padding from the left
        top: MediaQuery.of(context).size.width * 0.0, // Move the widget up by 20 units
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 400.0,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 8.0),
              scrollDirection : Axis.horizontal,
              itemCount: contentList.length,
              itemBuilder: (BuildContext context, int index){
                final Content content = contentList[index];
                return GestureDetector(
                    child: Stack(children: [
                      Container(margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 500 ,
                        width: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(content.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                    )
                );
              },
            ),
          )
          // Add more widgets here, such as ListView to display contentList
        ],
      ),
    );
  }
}

