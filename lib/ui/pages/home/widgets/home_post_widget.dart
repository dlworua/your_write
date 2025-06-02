import 'package:flutter/material.dart';

class HomePostWidget extends StatelessWidget {
  const HomePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/app_logo.png', fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Text('닉네임'),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.flag)),
              ],
            ),
          ),
        ),
        Container(
          height: 320,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
        ),
        Container(
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
          child: Row(
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
        ),
      ],
    );
  }
}
