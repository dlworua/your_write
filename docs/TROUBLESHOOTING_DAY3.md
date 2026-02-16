# Day 3 문제 해결 가이드

## ❌ MissingPluginException 에러

### 에러 메시지
```
MissingPluginException(No implementation found for method FirebaseFunctions#call on channel plugins.flutter.io/firebase_functions)
```

### 원인
Flutter 플러그인이 네이티브 레이어에 제대로 등록되지 않았을 때 발생합니다. 새로운 Firebase 플러그인(`cloud_functions`)을 추가한 후 네이티브 코드가 업데이트되지 않았기 때문입니다.

### 해결 방법

#### ✅ 완료된 조치 (자동)
```bash
# 1. Flutter 클린
flutter clean

# 2. 패키지 재설치
flutter pub get

# 3. iOS CocoaPods 재설치
cd ios
pod deintegrate
pod install
cd ..
```

#### 📱 다음 단계 (수동)

**앱을 완전히 중지하고 재실행해야 합니다:**

```bash
# 현재 실행 중인 앱 중지 (터미널에서 Ctrl+C 또는 Stop 버튼)

# iOS 시뮬레이터에서 재실행
flutter run

# 또는 Android에서 재실행 (Android의 경우)
flutter run
```

**중요**: Hot Reload나 Hot Restart가 아닌 **완전한 재빌드**가 필요합니다!

---

## ✅ 확인 사항

앱 재실행 후 다음을 확인하세요:

1. **빌드 성공 여부**
   ```
   ✓ Built build/ios/iphoneos/Runner.app (또는 Android APK)
   ```

2. **플러그인 등록 확인**
   - 앱이 크래시 없이 정상 실행됨
   - 마이페이지에서 버그 아이콘 클릭 가능
   - 테스트 페이지 로드됨

3. **Cloud Function 호출 테스트**
   - 프롬프트 입력 후 "Cloud Function 호출" 버튼 클릭
   - MissingPluginException 에러가 사라짐
   - AI 응답이 정상적으로 표시됨

---

## 🐛 여전히 에러가 발생하는 경우

### iOS 추가 조치

```bash
# Xcode 파생 데이터 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData

# iOS 시뮬레이터 재시작
# (시뮬레이터 앱에서 Device > Erase All Content and Settings...)

# 앱 완전 재설치
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### Android 추가 조치

```bash
# Gradle 캐시 삭제
cd android
./gradlew clean
cd ..

# 앱 완전 재빌드
flutter clean
flutter pub get
flutter run
```

---

## 📋 일반적인 Flutter 플러그인 에러 해결 절차

새로운 네이티브 플러그인을 추가할 때마다 다음 단계를 따르세요:

### 1. 패키지 추가 후
```bash
flutter pub get
```

### 2. iOS의 경우
```bash
cd ios
pod install
cd ..
```

### 3. Android의 경우
```bash
# 보통 자동 처리되지만, 문제 발생 시:
cd android
./gradlew clean
cd ..
```

### 4. 앱 재빌드 (필수!)
```bash
# Hot Reload/Restart로는 부족함
# 완전히 중지 후 재실행
flutter run
```

---

## 💡 예방 조치

### 새 플러그인 추가 시 체크리스트

- [ ] `pubspec.yaml`에 패키지 추가
- [ ] `flutter pub get` 실행
- [ ] iOS: `cd ios && pod install && cd ..`
- [ ] 앱 완전히 중지
- [ ] `flutter clean` (선택적, 문제 발생 시)
- [ ] `flutter run`으로 재빌드
- [ ] ⚠️ Hot Reload가 아닌 완전한 재시작!

---

## 🎯 현재 상태

- ✅ `flutter clean` 완료
- ✅ `flutter pub get` 완료
- ✅ `pod deintegrate` 완료
- ✅ `pod install` 완료 (28 pods 설치됨)
- ⏳ **다음 단계**: 앱 재실행 필요

---

## 📞 추가 도움

여전히 문제가 해결되지 않으면:

1. **Flutter Doctor 확인**
   ```bash
   flutter doctor -v
   ```

2. **Firebase 플러그인 버전 확인**
   ```bash
   flutter pub deps | grep cloud_functions
   ```
   - 현재 버전: `cloud_functions 5.5.2`

3. **로그 확인**
   - iOS: Xcode Console 확인
   - Android: `flutter run --verbose`

---

**결론**: 앱을 완전히 재시작하면 MissingPluginException 에러가 해결됩니다! 🚀
