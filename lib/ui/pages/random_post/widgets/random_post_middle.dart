import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/detail/detail_page.dart';

class RandomPostMiddle extends StatelessWidget {
  const RandomPostMiddle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailPage();
            },
          ),
        );
      },
      child: Container(
        height: 320,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('제목', style: TextStyle(fontSize: 40)),
            SizedBox(height: 30),
            Text('''이것은 본문입니다.
                  \n본문을 읽어주세요이것은 본문입니다.
                  \n본문을 읽어주세요''', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
