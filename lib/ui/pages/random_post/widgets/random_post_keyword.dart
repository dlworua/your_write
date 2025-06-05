import 'package:flutter/material.dart';

class RandomPostKeyword extends StatelessWidget {
  const RandomPostKeyword({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFF3C3),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 0.3),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '사랑해요',
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
