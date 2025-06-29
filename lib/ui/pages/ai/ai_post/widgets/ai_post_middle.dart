import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiPostMiddle extends StatelessWidget {
  final String title;
  final String content;

  const AiPostMiddle({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFFF5F1EB).withOpacity(0.6),
            Color(0xFFFAF6F0).withOpacity(0.4),
            Color(0xFFF5F1EB).withOpacity(0.3),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8B4513),
                letterSpacing: -0.8,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Color(0xFFFAF6F0).withOpacity(0.7),
                  Colors.white.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Color(0xFFDDBEA9).withOpacity(0.3),
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  blurRadius: 15.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5D4037),
                height: 1.7,
                letterSpacing: 0.3,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
