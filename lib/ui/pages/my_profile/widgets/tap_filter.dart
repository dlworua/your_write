import 'package:flutter/material.dart';

class FilterTabs extends StatelessWidget {
  const FilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 25),
          Text(
            'ALL',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(width: 16),
          Text(
            '4',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
          ),
          // 필터를 구현할 경우 상태 관리 필요
        ],
      ),
    );
  }
}
