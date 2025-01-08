import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/content_model.dart';

class Friends extends StatelessWidget {
  final String title;
  final List<Content> contentList;

  const Friends({
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
            height: 165.0,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 8.0),
                scrollDirection : Axis.horizontal,
                itemCount: contentList.length,
                itemBuilder: (BuildContext context, int index){
                  final Content content = contentList[index];
                return GestureDetector(
                    onTap: ()=> print(content.name),
                    child: Stack(children: [
                      Container(margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 130 ,
                      width: 130,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(content.image),
                          fit: BoxFit.cover,
                          ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurpleAccent, width: 4.0 ),
                      ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        child:SizedBox( child: Text(content.name, style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),),
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
