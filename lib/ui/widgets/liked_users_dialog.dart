import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class LikedUsersDialog extends ConsumerWidget {
  final CommentParams params;

  const LikedUsersDialog({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(postInteractionProvider(params).notifier);

    return Dialog(
      backgroundColor: const Color(0xFFFFFDF4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: const Color(0xFFD4AF37),
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '좋아요한 사람',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B4E3D),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 20.sp,
                    color: const Color(0xFF8B6F47),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Flexible(
              child: FutureBuilder<List<Map<String, String>>>(
                future: viewModel.fetchLikedUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFFD4AF37),
                        strokeWidth: 2.5,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '오류가 발생했습니다',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF8B6F47),
                        ),
                      ),
                    );
                  }

                  final likedUsers = snapshot.data ?? [];

                  if (likedUsers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 48.sp,
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '아직 좋아요가 없습니다',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF8B6F47).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: likedUsers.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final user = likedUsers[index];
                      final nickname = user['nickname'] ?? '익명';

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EFE7).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  nickname.isNotEmpty
                                      ? nickname[0]
                                      : '?',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF8B6F47),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                nickname,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6B4E3D),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.favorite,
                              size: 16.sp,
                              color: const Color(0xFFD4AF37),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
