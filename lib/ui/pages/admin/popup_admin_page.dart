import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_write/data/models/app_popup_model.dart';
import 'package:your_write/services/admin_service.dart';
import 'package:intl/intl.dart';

class PopupAdminPage extends ConsumerStatefulWidget {
  const PopupAdminPage({super.key});

  @override
  ConsumerState<PopupAdminPage> createState() => _PopupAdminPageState();
}

class _PopupAdminPageState extends ConsumerState<PopupAdminPage> {
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final isAdmin = await AdminService.isAdmin();
    setState(() {
      _isAdmin = isAdmin;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('팝업 관리'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('팝업 관리'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64.sp,
                color: Colors.grey,
              ),
              SizedBox(height: 16.h),
              Text(
                '관리자 권한이 필요합니다',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AdminService.currentUserEmail ?? '로그인 필요',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('팝업 관리'),
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('app_popups')
            .orderBy('priority', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('오류: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final popups = snapshot.data!.docs
              .map((doc) => AppPopupModel.fromFirestore(doc))
              .toList();

          if (popups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '등록된 팝업이 없습니다',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: popups.length,
            itemBuilder: (context, index) {
              final popup = popups[index];
              return _PopupCard(
                popup: popup,
                onToggle: () => _toggleActive(popup),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _toggleActive(AppPopupModel popup) async {
    try {
      await FirebaseFirestore.instance
          .collection('app_popups')
          .doc(popup.id)
          .update({'isActive': !popup.isActive});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              popup.isActive ? '팝업을 비활성화했습니다' : '팝업을 활성화했습니다',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _PopupCard extends StatelessWidget {
  final AppPopupModel popup;
  final VoidCallback onToggle;

  const _PopupCard({
    required this.popup,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isExpired = now.isAfter(popup.endDate);
    final isUpcoming = now.isBefore(popup.startDate);

    String statusText;
    Color statusColor;

    if (isExpired) {
      statusText = '종료됨';
      statusColor = Colors.grey;
    } else if (isUpcoming) {
      statusText = '예정';
      statusColor = Colors.orange;
    } else if (popup.isActive) {
      statusText = '진행중';
      statusColor = Colors.green;
    } else {
      statusText = '비활성';
      statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 (상태 + 토글)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    popup.contentType == PopupContentType.image
                        ? '이미지'
                        : 'WebView',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                ),
                const Spacer(),
                Switch(
                  value: popup.isActive,
                  onChanged: (_) => onToggle(),
                  activeColor: const Color(0xFFD4AF37),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // ID
            Text(
              'ID: ${popup.id}',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
                fontFamily: 'monospace',
              ),
            ),

            SizedBox(height: 8.h),

            // URL
            Text(
              popup.contentUrl,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.blue[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            if (popup.actionUrl != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.link,
                    size: 14.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      popup.actionUrl!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 12.h),

            // 기간
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4.w),
                Text(
                  '${DateFormat('yyyy-MM-dd').format(popup.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(popup.endDate)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // 우선순위
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4.w),
                Text(
                  '우선순위: ${popup.priority}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // 통계 정보
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 통계',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          icon: Icons.visibility_outlined,
                          label: '조회수',
                          value: '${popup.viewCount}',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _StatItem(
                          icon: Icons.touch_app_outlined,
                          label: '클릭수',
                          value: '${popup.clickCount}',
                        ),
                      ),
                    ],
                  ),
                  if (popup.viewCount > 0) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.ads_click,
                          size: 12.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'CTR: ${popup.clickCount > 0 && popup.viewCount > 0 ? ((popup.clickCount / popup.viewCount) * 100).toStringAsFixed(1) : '0.0'}%',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (popup.lastViewedAt != null) ...[
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 11.sp,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '최근 조회: ${DateFormat('MM/dd HH:mm').format(popup.lastViewedAt!)}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: const Color(0xFFD4AF37),
        ),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
