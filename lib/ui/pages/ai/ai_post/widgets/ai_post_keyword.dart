import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiPostKeyword extends StatelessWidget {
  final String keyword;

  const AiPostKeyword({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDDBEA9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        keyword,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
