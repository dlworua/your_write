import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_write/data/models/app_popup_model.dart';

class PopupService {
  static const String _keyPrefix = 'popup_dont_show_';

  /// Firestore에서 현재 표시 가능한 팝업 가져오기
  static Future<List<AppPopupModel>> fetchActivePopups() async {
    try {
      print('[PopupService] 팝업 가져오기 시작...');
      final snapshot = await FirebaseFirestore.instance
          .collection('app_popups')
          .where('isActive', isEqualTo: true)
          .orderBy('priority', descending: true)
          .get();

      print('[PopupService] Firestore에서 ${snapshot.docs.length}개 문서 가져옴');

      final popups = snapshot.docs
          .map((doc) {
            print('[PopupService] 문서 ID: ${doc.id}, 데이터: ${doc.data()}');
            return AppPopupModel.fromFirestore(doc);
          })
          .where((popup) {
            final shouldShow = popup.shouldShow;
            print('[PopupService] ${popup.id} shouldShow: $shouldShow (${popup.startDate} ~ ${popup.endDate})');
            return shouldShow;
          })
          .toList();

      print('[PopupService] 최종 표시할 팝업: ${popups.length}개');
      return popups;
    } catch (e) {
      print('[PopupService] 팝업 가져오기 실패: $e');
      return [];
    }
  }

  /// 오늘 하루 보지 않기 설정 확인
  static Future<bool> shouldShowPopup(String popupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$popupId';
      final savedDate = prefs.getString(key);

      if (savedDate == null) return true;

      final savedDateTime = DateTime.tryParse(savedDate);
      if (savedDateTime == null) return true;

      // 저장된 날짜와 현재 날짜가 다르면 다시 표시
      final now = DateTime.now();
      final isSameDay = savedDateTime.year == now.year &&
          savedDateTime.month == now.month &&
          savedDateTime.day == now.day;

      return !isSameDay;
    } catch (e) {
      print('[PopupService] 팝업 표시 여부 확인 실패: $e');
      return true;
    }
  }

  /// 오늘 하루 보지 않기 설정
  static Future<void> setDontShowToday(String popupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_keyPrefix$popupId';
      final now = DateTime.now();
      await prefs.setString(key, now.toIso8601String());
    } catch (e) {
      print('[PopupService] 오늘 하루 보지 않기 설정 실패: $e');
    }
  }

  /// 팝업 표시 여부 확인 후 필터링
  static Future<List<AppPopupModel>> getPopupsToShow() async {
    final allPopups = await fetchActivePopups();
    final popupsToShow = <AppPopupModel>[];

    for (final popup in allPopups) {
      final shouldShow = await shouldShowPopup(popup.id);
      if (shouldShow) {
        popupsToShow.add(popup);
      }
    }

    return popupsToShow;
  }
}
