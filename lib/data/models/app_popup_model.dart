import 'package:cloud_firestore/cloud_firestore.dart';

enum PopupContentType {
  webview, // HTML 페이지 URL
  image, // 이미지 URL
}

class AppPopupModel {
  final String id;
  final String contentUrl; // WebView 또는 이미지 URL
  final PopupContentType contentType; // 컨텐츠 타입
  final bool isActive; // 활성화 상태
  final DateTime startDate; // 노출 시작일
  final DateTime endDate; // 노출 종료일
  final int priority; // 우선순위 (높을수록 먼저 표시)

  AppPopupModel({
    required this.id,
    required this.contentUrl,
    required this.contentType,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.priority,
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
      isActive: data['isActive'] as bool? ?? false,
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      priority: data['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contentUrl': contentUrl,
      'contentType': contentType == PopupContentType.image ? 'image' : 'webview',
      'isActive': isActive,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'priority': priority,
    };
  }

  /// 현재 시점에 표시 가능한 팝업인지 확인
  bool get shouldShow {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }
}
