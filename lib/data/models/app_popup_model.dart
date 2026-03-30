import 'package:cloud_firestore/cloud_firestore.dart';

enum PopupContentType {
  webview, // HTML 페이지 URL
  image, // 이미지 URL
}

class AppPopupModel {
  final String id;
  final String contentUrl; // WebView 또는 이미지 URL
  final PopupContentType contentType; // 컨텐츠 타입
  final String? actionUrl; // 클릭 시 이동할 URL (선택사항)
  final bool isActive; // 활성화 상태
  final DateTime startDate; // 노출 시작일
  final DateTime endDate; // 노출 종료일
  final int priority; // 우선순위 (높을수록 먼저 표시)
  final int viewCount; // 조회수
  final int clickCount; // 클릭수
  final DateTime? lastViewedAt; // 마지막 조회 시각
  final DateTime? lastClickedAt; // 마지막 클릭 시각

  AppPopupModel({
    required this.id,
    required this.contentUrl,
    required this.contentType,
    this.actionUrl,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.priority,
    this.viewCount = 0,
    this.clickCount = 0,
    this.lastViewedAt,
    this.lastClickedAt,
  });

  factory AppPopupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // contentType 파싱 (기본값: webview)
    PopupContentType type = PopupContentType.webview;
    final typeString = data['contentType'] as String?;
    if (typeString == 'image') {
      type = PopupContentType.image;
    }

    return AppPopupModel(
      id: doc.id,
      contentUrl: data['contentUrl'] as String? ?? '',
      contentType: type,
      actionUrl: data['actionUrl'] as String?,
      isActive: data['isActive'] as bool? ?? false,
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      priority: data['priority'] as int? ?? 0,
      viewCount: data['viewCount'] as int? ?? 0,
      clickCount: data['clickCount'] as int? ?? 0,
      lastViewedAt: (data['lastViewedAt'] as Timestamp?)?.toDate(),
      lastClickedAt: (data['lastClickedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'contentUrl': contentUrl,
      'contentType': contentType == PopupContentType.image ? 'image' : 'webview',
      'isActive': isActive,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'priority': priority,
      'viewCount': viewCount,
      'clickCount': clickCount,
    };

    if (actionUrl != null) {
      map['actionUrl'] = actionUrl!;
    }

    if (lastViewedAt != null) {
      map['lastViewedAt'] = Timestamp.fromDate(lastViewedAt!);
    }

    if (lastClickedAt != null) {
      map['lastClickedAt'] = Timestamp.fromDate(lastClickedAt!);
    }

    return map;
  }

  /// 현재 시점에 표시 가능한 팝업인지 확인
  bool get shouldShow {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }
}
