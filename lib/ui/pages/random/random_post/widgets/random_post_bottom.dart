import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_keyword.dart';

class RandomPostBottom extends StatelessWidget {
  const RandomPostBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Text('랜덤 인용구 : ', style: TextStyle(fontSize: 12)),
              Row(
                children: [
                  RandomPostKeyword(),
                  Text(','),
                  RandomPostKeyword(),
                  Text(','),
                  RandomPostKeyword(),
                  Text(','),
                  RandomPostKeyword(),
                  Text(','),
                  RandomPostKeyword(),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only()),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border_rounded),
              ),
              Text('37'),
              IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
              Text('326'),
              IconButton(onPressed: () {}, icon: Icon(Icons.share)),

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
