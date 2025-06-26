import 'package:flutter/material.dart';

class FilterTabs extends StatelessWidget {
  final int count;

  const FilterTabs({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 25),
          const Text(
            'ALL',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SizedBox(width: 16),
          Text(
            '$count',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
