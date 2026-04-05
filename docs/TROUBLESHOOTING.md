# Flutter 개발 트러블슈팅 모음

> 개발 중 실제로 마주쳤던 문제와 해결 과정을 블로그 형식으로 기록합니다.

---

## [2026-02-16] VSCode IDE에서 실제 존재하는 속성을 "정의되지 않음"으로 표시하는 문제

### 증상

`WriteModel`에 `uid` 필드를 새로 추가한 직후, VSCode에서 아래와 같은 오류가 표시되었다.

```
The named parameter 'uid' isn't defined.
Try correcting the name to an existing named parameter's name,
or defining a named parameter with the name 'uid'.
```

오류 위치:
- `ai_write_page.dart` 121번째 줄
- `ai_write_service.dart` 2, 12, 20, 61, 139번째 줄

### 당황스러웠던 점

분명히 `write_model.dart`를 열어보면 `uid` 필드가 제대로 정의되어 있다.

```dart
class WriteModel {
  final String uid; // 작성자 UID (수정/삭제 권한 확인용)

  WriteModel({
    // ...
    this.uid = '',
  });
}
```

그런데 IDE는 "없다"고 한다.

### 진단 과정

`flutter analyze`를 직접 실행해봤다.

```bash
flutter analyze
```

결과:
```
Analyzing your_write...

   info • The private field _selectedFilterIndex could be 'final' • ...

1 issue found.
```

**에러 0개.** `flutter analyze`는 실제 Dart 컴파일러 기반으로 분석하므로 이 결과가 정확하다.

즉, **코드는 정상이고 IDE만 오래된 분석 결과를 보여주고 있는 것**이었다.

### 원인

VSCode의 Dart Analysis Server가 오래된 캐시를 사용하고 있었다.

`flutter pub get` 실행 전에 IDE가 이전 버전의 모델 클래스를 분석해두고, 이후 파일이 수정되었음에도 불구하고 **캐싱된 분석 결과를 계속 표시**한 것이다.

특히 이런 상황에서 자주 발생한다:
- 클래스에 새 필드/파라미터를 추가했을 때
- 여러 파일을 동시에 빠르게 수정했을 때
- 린터 규칙이 적용되어 자동 수정이 이루어진 직후

### 해결 방법

**방법 1: Dart Analysis Server 재시작 (권장)**

```
Cmd + Shift + P → "Dart: Restart Analysis Server"
```

**방법 2: flutter pub get 실행 후 잠시 대기**

```bash
flutter pub get
```

실행 후 IDE가 의존성을 다시 불러오면서 분석 캐시도 갱신된다.

**방법 3: VSCode 완전 재시작**

가장 확실하지만 불편한 방법.

### 확인 방법

IDE 진단에 의존하지 말고, **항상 `flutter analyze`로 실제 에러를 확인**하자.

```bash
# 에러만 확인 (info 무시)
flutter analyze --no-fatal-infos

# 전체 확인
flutter analyze
```

### 교훈

> **IDE 진단 ≠ 실제 컴파일 에러**
>
> VSCode의 빨간 줄은 Dart Analysis Server의 분석 결과다.
> 이 서버가 캐시를 사용하기 때문에 최신 파일 상태를 반영하지 못할 수 있다.
> **`flutter analyze`가 에러를 보여주지 않는다면 코드는 정상이다.**

---

## [2026-02-16] cloud_functions 패키지 버전 충돌

### 증상

`cloud_functions` 패키지 추가 시 아래 오류 발생:

```
Because cloud_functions >=4.7.0 requires firebase_core ^2.28.0,
version solving failed.
```

### 원인

`firebase_core` 버전과 `cloud_functions` 버전 간 호환성 문제.

### 해결

`pubspec.yaml`에서 최신 호환 버전으로 업그레이드:

```yaml
cloud_functions: ^5.5.2
```

---

## [2026-02-16] MissingPluginException - cloud_functions 네이티브 레이어 미등록

### 증상

앱 실행 후 Cloud Function 호출 시:

```
MissingPluginException: No implementation found for method FirebaseFunctions#call
```

### 원인

`cloud_functions` 패키지를 `pubspec.yaml`에 추가했지만,
iOS 네이티브 레이어(CocoaPods)가 아직 새 패키지를 인식하지 못한 상태.

### 해결

네이티브 빌드 캐시 완전 초기화 필요:

```bash
flutter clean
flutter pub get
cd ios
pod deintegrate
pod install
cd ..
```

이후 앱 **완전 재빌드** (단순 Hot Restart가 아닌 Stop → Run).

---

## [2026-02-16] Gemini API 404 오류 - v1beta vs v1 API 버전 불일치

### 증상

Cloud Function에서 `gemini-2.0-flash` 호출 시 404 Not Found.
`gemini-1.5-flash`, `gemini-pro` 등 여러 모델 이름을 시도해도 동일한 404.

### 원인

Node.js `@google/generative-ai` 라이브러리가 **v1beta API**를 사용한다.
그런데 `gemini-2.0-flash`는 **v1 API**에만 존재한다.

| API 버전 | 엔드포인트 | 지원 모델 |
|---------|-----------|---------|
| v1beta | `generativelanguage.googleapis.com/v1beta/...` | gemini-pro, gemini-1.5-pro 등 |
| v1 | `generativelanguage.googleapis.com/v1/...` | gemini-2.0-flash 포함 최신 모델 |

Flutter 클라이언트의 `google_generative_ai ^0.4.7`은 v1을 사용하는데
서버의 Node.js 라이브러리는 v1beta를 사용하면서 충돌 발생.

### 해결

`@google/generative-ai` 라이브러리를 완전히 제거하고,
Node.js 내장 `https` 모듈로 v1 REST API를 직접 호출:

```javascript
// ❌ 제거
// const { GoogleGenerativeAI } = require('@google/generative-ai');

// ✅ 직접 REST 호출
const url = `https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent?key=${apiKey}`;
```

---

*이 문서는 실제 개발 과정에서 마주친 문제들을 기록한 것입니다.*
*같은 실수를 반복하지 않기 위해 작성했습니다.*
