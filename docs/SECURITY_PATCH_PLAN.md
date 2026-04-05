# 보안 패치 상세 실행 계획

**작성일**: 2026-02-10
**총 소요 기간**: 6일 (하루 1시간씩)
**목표**: Gemini API 키 완전 보안 처리 + Firestore Rules 강화

---

## 📅 Day 1: Cloud Functions 초기 설정 (1시간)

### 🎯 목표
- Firebase CLI 설치 및 로그인
- Functions 프로젝트 초기화
- 프로젝트 구조 확인

### ✅ 체크리스트

#### 1. Firebase CLI 설치 확인 (5분)
```bash
# 터미널 열기
# 설치 여부 확인
firebase --version

# 없으면 설치
npm install -g firebase-tools
# 또는 (Mac)
curl -sL https://firebase.tools | bash
```

#### 2. Firebase 로그인 (5분)
```bash
# Firebase 계정 로그인
firebase login

# 브라우저에서 Google 계정 선택
# 권한 허용
# 터미널에 "Success!" 메시지 확인
```

#### 3. 현재 Firebase 프로젝트 확인 (5분)
```bash
cd /Users/t2023-m0013/Documents/MyProject/your_write

# 프로젝트 목록 확인
firebase projects:list

# 현재 프로젝트 확인
firebase use
```

#### 4. Cloud Functions 초기화 (30분)
```bash
# Functions 초기화
firebase init functions

# 질문 답변:
? Select a default Firebase project for this directory:
  → 기존 프로젝트 선택 (your_write 프로젝트)

? What language would you like to use to write Cloud Functions?
  → JavaScript (TypeScript보다 간단)

? Do you want to use ESLint to catch probable bugs and enforce style?
  → Yes (권장)

? Do you want to install dependencies with npm now?
  → Yes

# 설치 완료 대기 (2-3분)
```

#### 5. 생성된 파일 구조 확인 (5분)
```bash
# functions 디렉토리 생성 확인
ls -la functions/

# 예상 파일:
# functions/
#   ├── .eslintrc.js
#   ├── index.js          ← 여기에 코드 작성
#   ├── package.json
#   └── node_modules/
```

#### 6. 간단한 테스트 Function 작성 (10분)
```bash
# functions/index.js 열기
open functions/index.js
# 또는
code functions/index.js
```

**테스트 코드 작성:**
```javascript
const functions = require('firebase-functions');

// 간단한 테스트 함수
exports.helloWorld = functions.https.onCall((data, context) => {
  return { message: 'Hello from Cloud Functions!' };
});
```

#### 7. 테스트 배포 (5분)
```bash
# Firebase 프로젝트 연결 확인
firebase use --add

# Functions 배포
firebase deploy --only functions

# 배포 성공 확인
# ✔ Deploy complete!
# Function URL: https://asia-northeast3-[project-id].cloudfunctions.net/helloWorld
```

### ✅ Day 1 완료 조건
- [ ] Firebase CLI 설치됨
- [ ] Firebase 로그인 성공
- [ ] functions 디렉토리 생성됨
- [ ] 테스트 함수 배포 성공

### 📝 Day 1 마무리
```bash
# 현재 상태 저장
git add .
git commit -m "feat: Firebase Cloud Functions 초기 설정"
```

---

## 📅 Day 2: Cloud Function 코드 작성 (1시간)

### 🎯 목표
- Gemini API 연동 Function 작성
- 환경 변수 설정
- 입력 검증 및 에러 처리

### ✅ 체크리스트

#### 1. Google Generative AI 패키지 설치 (5분)
```bash
cd /Users/t2023-m0013/Documents/MyProject/your_write/functions

# 패키지 설치
npm install @google/generative-ai

# package.json 확인
cat package.json
```

#### 2. 환경 변수 설정 - API 키 등록 (10분)
```bash
# .env 파일에서 API 키 복사
cat /Users/t2023-m0013/Documents/MyProject/your_write/.env

# Firebase Functions Config에 설정
firebase functions:config:set gemini.key="YOUR_ACTUAL_API_KEY_HERE"

# 설정 확인
firebase functions:config:get
# 출력:
# {
#   "gemini": {
#     "key": "AIzaSy..."
#   }
# }
```

#### 3. generateAI Function 작성 (40분)
```bash
# functions/index.js 열기
code functions/index.js
```

**전체 코드 작성:**
```javascript
const functions = require('firebase-functions');
const { GoogleGenerativeAI } = require('@google/generative-ai');

// Gemini API 초기화
const genAI = new GoogleGenerativeAI(functions.config().gemini.key);

/**
 * AI 텍스트 생성 Cloud Function
 * @param {Object} data - { prompt: string }
 * @param {Object} context - Firebase Auth Context
 * @returns {Object} - { success: boolean, text: string }
 */
exports.generateAI = functions
  .region('asia-northeast3') // 서울 리전 (빠른 응답)
  .runWith({
    timeoutSeconds: 60, // 최대 60초
    memory: '256MB',
  })
  .https.onCall(async (data, context) => {
    // ===== 1. 인증 확인 =====
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        '로그인이 필요합니다.'
      );
    }

    // ===== 2. 입력값 검증 =====
    const { prompt } = data;

    if (!prompt) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        '프롬프트가 필요합니다.'
      );
    }

    if (typeof prompt !== 'string') {
      throw new functions.https.HttpsError(
        'invalid-argument',
        '프롬프트는 문자열이어야 합니다.'
      );
    }

    if (prompt.length < 10) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        '프롬프트는 최소 10자 이상이어야 합니다.'
      );
    }

    if (prompt.length > 5000) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        '프롬프트는 최대 5000자까지 가능합니다.'
      );
    }

    // ===== 3. Rate Limiting (선택) =====
    // TODO: Firestore로 사용자별 호출 횟수 제한 구현
    // 예: 하루 50회 제한

    console.log('🔐 사용자:', context.auth.uid);
    console.log('✍️ 프롬프트 길이:', prompt.length);

    try {
      // ===== 4. Gemini API 호출 =====
      const model = genAI.getGenerativeModel({
        model: 'gemini-2.0-flash-exp'
      });

      const result = await model.generateContent(prompt);
      const response = await result.response;
      const text = response.text();

      console.log('✅ AI 생성 성공, 길이:', text.length);

      // ===== 5. 응답 반환 =====
      return {
        success: true,
        text: text,
        timestamp: new Date().toISOString(),
      };

    } catch (error) {
      // ===== 6. 에러 처리 =====
      console.error('❌ Gemini API 오류:', error);

      // 사용자 친화적 에러 메시지
      let errorMessage = 'AI 생성 중 오류가 발생했습니다.';

      if (error.message.includes('quota')) {
        errorMessage = 'API 할당량이 초과되었습니다. 잠시 후 다시 시도해주세요.';
      } else if (error.message.includes('invalid')) {
        errorMessage = '유효하지 않은 요청입니다.';
      } else if (error.message.includes('timeout')) {
        errorMessage = '요청 시간이 초과되었습니다. 다시 시도해주세요.';
      }

      throw new functions.https.HttpsError(
        'internal',
        errorMessage,
        error.message
      );
    }
  });

// ===== 기존 테스트 함수 삭제 =====
// exports.helloWorld = ... (삭제)
```

#### 4. ESLint 경고 수정 (5분)
```bash
# Lint 확인
npm run lint

# 자동 수정
npm run lint -- --fix
```

### ✅ Day 2 완료 조건
- [ ] @google/generative-ai 패키지 설치됨
- [ ] gemini.key 환경 변수 설정됨
- [ ] generateAI 함수 작성 완료
- [ ] 코드에 주석 및 에러 처리 포함

### 📝 Day 2 마무리
```bash
git add .
git commit -m "feat: Gemini API Cloud Function 작성"
```

---

## 📅 Day 3: Cloud Function 배포 및 테스트 (1시간)

### 🎯 목표
- Function 배포
- Firebase Console에서 확인
- 수동 테스트

### ✅ 체크리스트

#### 1. 배포 전 확인 (5분)
```bash
cd /Users/t2023-m0013/Documents/MyProject/your_write

# Firebase 프로젝트 확인
firebase use

# Functions 디렉토리 확인
ls -la functions/index.js
```

#### 2. Cloud Function 배포 (10분)
```bash
# 배포 시작
firebase deploy --only functions

# 진행 상황:
# === Deploying to 'your-project-id'...
# i  deploying functions
# i  functions: ensuring required API cloudfunctions.googleapis.com is enabled...
# ✔  functions: required API cloudfunctions.googleapis.com is enabled
# i  functions: preparing functions directory for uploading...
# i  functions: packaged functions (XX KB) for uploading
# ✔  functions: functions folder uploaded successfully
# i  functions: updating Node.js 18 function generateAI(asia-northeast3)...
# ✔  functions[generateAI(asia-northeast3)]: Successful update operation.

# 배포 성공 확인!
# Function URL 복사해두기
```

#### 3. Firebase Console 확인 (10분)
```
1. Firebase Console 접속
   https://console.firebase.google.com

2. 프로젝트 선택

3. Functions 메뉴 클릭

4. generateAI 함수 확인
   - 상태: Active (초록색)
   - 지역: asia-northeast3
   - 트리거: HTTPS (Callable)
   - 메모리: 256MB
   - 타임아웃: 60s

5. 로그 확인 (선택)
   - Logs 탭 클릭
   - 최근 실행 내역 확인
```

#### 4. Postman으로 테스트 (선택, 15분)
```bash
# 또는 curl로 테스트
curl -X POST \
  https://asia-northeast3-[project-id].cloudfunctions.net/generateAI \
  -H 'Content-Type: application/json' \
  -d '{
    "data": {
      "prompt": "안녕하세요, 간단한 시를 써주세요."
    }
  }'

# 주의: Callable Function은 Firebase SDK로만 호출 가능
# 위 테스트는 실패할 수 있음 (인증 필요)
```

#### 5. Flutter 프로젝트에 cloud_functions 패키지 추가 (10분)
```bash
cd /Users/t2023-m0013/Documents/MyProject/your_write

# pubspec.yaml 열기
code pubspec.yaml
```

**pubspec.yaml 수정:**
```yaml
dependencies:
  flutter:
    sdk: flutter

  # 기존 패키지들...
  firebase_core: ^3.14.0
  cloud_firestore: ^5.6.9
  firebase_auth: ^5.6.0

  # 추가
  cloud_functions: ^4.7.0  # ← 이 줄 추가
```

```bash
# 패키지 설치
flutter pub get
```

#### 6. 간단한 Flutter 테스트 코드 작성 (20분)
```bash
# 테스트 파일 생성
mkdir -p lib/test
code lib/test/test_cloud_function.dart
```

**테스트 코드:**
```dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestCloudFunctionPage extends StatefulWidget {
  const TestCloudFunctionPage({Key? key}) : super(key: key);

  @override
  State<TestCloudFunctionPage> createState() => _TestCloudFunctionPageState();
}

class _TestCloudFunctionPageState extends State<TestCloudFunctionPage> {
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');
  String _result = '테스트 대기 중...';
  bool _loading = false;

  Future<void> _testFunction() async {
    setState(() {
      _loading = true;
      _result = '호출 중...';
    });

    try {
      // 로그인 확인
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _result = '오류: 로그인이 필요합니다';
          _loading = false;
        });
        return;
      }

      // Cloud Function 호출
      final callable = _functions.httpsCallable('generateAI');
      final result = await callable.call({
        'prompt': '테스트: 짧은 시 한 편을 작성해주세요.',
      });

      setState(() {
        _result = '성공!\n\n${result.data['text']}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = '오류: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cloud Function 테스트')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _testFunction,
              child: _loading
                ? const CircularProgressIndicator()
                : const Text('generateAI 테스트'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 7. 앱에서 테스트 페이지 실행 (선택)
```dart
// lib/main.dart 또는 프로필 페이지에 버튼 추가
// Navigator.push(context, MaterialPageRoute(
//   builder: (context) => TestCloudFunctionPage(),
// ));
```

### ✅ Day 3 완료 조건
- [ ] Cloud Function 배포 성공
- [ ] Firebase Console에서 함수 확인됨
- [ ] cloud_functions 패키지 설치됨
- [ ] 테스트 페이지 작성 완료 (선택)

### 📝 Day 3 마무리
```bash
git add .
git commit -m "feat: Cloud Function 배포 및 테스트 환경 구축"
```

---

## 📅 Day 4: Flutter 코드 수정 - ai_write_service.dart (1시간)

### 🎯 목표
- 기존 Gemini SDK 제거
- Cloud Function 호출로 변경
- 에러 처리 개선

### ✅ 체크리스트

#### 1. 기존 코드 백업 (5분)
```bash
# 현재 파일 백업
cp lib/ui/pages/ai/ai_write/ai_write_service.dart \
   lib/ui/pages/ai/ai_write/ai_write_service.dart.backup

# 백업 확인
ls -la lib/ui/pages/ai/ai_write/
```

#### 2. ai_write_service.dart 수정 (45분)

**수정 전 import 부분:**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // 삭제
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';  // 삭제
import 'package:your_write/data/models/write_model.dart';
```

**수정 후 import 부분:**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';  // 추가
import 'package:firebase_auth/firebase_auth.dart';  // 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
```

**전체 수정된 코드:**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';

final aiWriterServiceProvider = Provider<AiWriteService>((ref) {
  return AiWriteService();
});

class AiWriteService {
  final _firestore = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');
  final _auth = FirebaseAuth.instance;

  /// AI 글 목록 가져오기
  Future<List<WriteModel>> fetchAiPosts() async {
    final snapshot = await _firestore
        .collection('ai_writes')
        .where('type', isEqualTo: 'ai')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .where((doc) => doc.data() != null)
        .map((doc) => WriteModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  /// AI로 구조화된 텍스트 생성
  Future<WriteModel> generateStructuredText(String prompt) async {
    print('✍️ Cloud Functions 호출 시작');
    print('📝 프롬프트 길이: ${prompt.length}자');

    try {
      // Cloud Function 호출
      final callable = _functions.httpsCallable('generateAI');
      final result = await callable.call({
        'prompt': prompt,
      });

      // 응답 확인
      if (result.data == null || result.data['text'] == null) {
        throw Exception('AI 응답이 비어있습니다.');
      }

      final text = result.data['text'] as String;
      print('✅ AI 생성 완료: ${text.length}자');

      // === 기존 파싱 로직 그대로 유지 ===
      final lines = text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      String title = '';
      String keyword = '';
      final contentBuffer = <String>[];

      for (final line in lines) {
        final lower = line.toLowerCase();
        if (lower.startsWith('제목:') || lower.startsWith('title:')) {
          title = line.split(':').sublist(1).join(':').trim();
        } else if (lower.startsWith('제목 -')) {
          title = line.split('-').sublist(1).join('-').trim();
        } else if (RegExp(r'^#{1,3}\s*').hasMatch(line)) {
          title = line.replaceFirst(RegExp(r'^#{1,3}\s*'), '').trim();
        } else if (lower.startsWith('키워드:') ||
            lower.startsWith('keywords:')) {
          keyword = line.split(':').sublist(1).join(':').trim();
        } else {
          contentBuffer.add(line);
        }
      }

      final content = contentBuffer.join('\n').trim();

      // 키워드 자동 생성 (기존 로직 유지)
      if (keyword.isEmpty && content.isNotEmpty) {
        final words = content
            .replaceAll(RegExp(r'[^\uAC00-\uD7A3a-zA-Z\s]'), '')
            .split(' ')
            .where((w) => w.length >= 2)
            .toList();

        final freq = <String, int>{};
        for (final w in words) {
          freq[w] = (freq[w] ?? 0) + 1;
        }

        final sorted = freq.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final topKeywords = sorted.take(3).map((e) => e.key).toList();
        keyword = topKeywords.join(', ');
      }

      print('📌 제목: $title');
      print('🏷️ 키워드: $keyword');

      // WriteModel 생성
      return WriteModel(
        id: '',
        title: title.isEmpty ? '제목 없음' : title,
        keyWord: keyword.isEmpty ? '키워드 없음' : keyword,
        nickname: _auth.currentUser?.displayName ?? '익명',
        content: content.isEmpty ? text : content,
        date: DateTime.now(),
        type: 'ai',
      );
    } on FirebaseFunctionsException catch (e) {
      // Cloud Functions 에러
      print('❌ Functions 오류: ${e.code} - ${e.message}');

      String userMessage = 'AI 생성 중 오류가 발생했습니다.';

      switch (e.code) {
        case 'unauthenticated':
          userMessage = '로그인이 필요합니다.';
          break;
        case 'invalid-argument':
          userMessage = '입력값이 올바르지 않습니다.';
          break;
        case 'resource-exhausted':
          userMessage = 'API 사용량을 초과했습니다. 잠시 후 다시 시도해주세요.';
          break;
        case 'deadline-exceeded':
          userMessage = '요청 시간이 초과되었습니다. 다시 시도해주세요.';
          break;
      }

      throw Exception(userMessage);
    } catch (e) {
      // 기타 에러
      print('❌ 예기치 않은 오류: $e');
      throw Exception('AI 생성 중 오류가 발생했습니다: $e');
    }
  }
}
```

#### 3. 코드 검증 (5분)
```bash
# 문법 오류 확인
flutter analyze lib/ui/pages/ai/ai_write/ai_write_service.dart

# 빌드 확인
flutter build apk --debug
```

#### 4. 변경사항 확인 (5분)
```bash
# 변경된 내용 비교
git diff lib/ui/pages/ai/ai_write/ai_write_service.dart

# 주요 변경사항:
# - google_generative_ai 제거
# - cloud_functions 추가
# - API 키 관련 코드 제거
# - Cloud Function 호출로 변경
```

### ✅ Day 4 완료 조건
- [ ] 기존 파일 백업됨
- [ ] import 문 수정 완료
- [ ] Cloud Function 호출 코드 작성 완료
- [ ] 에러 처리 개선됨
- [ ] flutter analyze 통과

### 📝 Day 4 마무리
```bash
git add .
git commit -m "refactor: AI 생성을 Cloud Functions로 이전"
```

---

## 📅 Day 5: main.dart 정리 및 Firestore Rules 강화 (1시간)

### 🎯 목표
- main.dart에서 .env 관련 코드 제거
- Firestore Security Rules 강화
- 최종 코드 정리

### ✅ 체크리스트

#### 1. main.dart 수정 (15분)

**수정 전:**
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';  // 삭제

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();  // 삭제

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  print(const String.fromEnvironment('GEMINI_API_KEY'));  // 삭제
  runApp(ProviderScope(child: const MyApp()));
}
```

**수정 후:**
```dart
// flutter_dotenv import 삭제

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // dotenv.load() 삭제

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // print 문 삭제
  runApp(const ProviderScope(child: MyApp()));
}
```

#### 2. pubspec.yaml 정리 (선택, 5분)
```yaml
dependencies:
  # flutter_dotenv: ^5.2.1  # 주석 처리 또는 삭제 (선택)
  # google_generative_ai: ^0.4.7  # 주석 처리 (선택)

assets:
  - assets/
  - assets/policies/privacy_policy.md
  - assets/policies/terms_of_service.md
  - assets/policies/marketing_agreement.md
  # - .env  # 주석 처리 (선택)
```

#### 3. Firestore Security Rules 강화 (30분)

**Firebase Console 접속:**
```
1. https://console.firebase.google.com
2. 프로젝트 선택
3. Firestore Database 메뉴
4. Rules 탭 클릭
```

**전체 Rules 복사 붙여넣기:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ===== 헬퍼 함수 =====
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isAuthor(authorId) {
      return request.auth.uid == authorId;
    }

    // ===== 사용자 프로필 =====
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && isOwner(userId);
      allow update, delete: if isOwner(userId);
    }

    // ===== 홈 게시글 =====
    match /home_posts/{postId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn()
        && request.resource.data.authorId == request.auth.uid;
      allow update, delete: if isSignedIn()
        && resource.data.authorId == request.auth.uid;

      // 댓글
      match /comments/{commentId} {
        allow read: if isSignedIn();
        allow create: if isSignedIn();
        allow delete: if isSignedIn()
          && resource.data.uid == request.auth.uid;
      }

      // 좋아요
      match /likes/{likeId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn();
      }

      // 저장
      match /saves/{saveId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn();
      }
    }

    // ===== AI 글 =====
    match /ai_writes/{postId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn()
        && request.resource.data.authorId == request.auth.uid;
      allow update, delete: if isSignedIn()
        && resource.data.authorId == request.auth.uid;

      match /comments/{commentId} {
        allow read: if isSignedIn();
        allow create: if isSignedIn();
        allow delete: if isSignedIn()
          && resource.data.uid == request.auth.uid;
      }

      match /likes/{likeId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn();
      }

      match /saves/{saveId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn();
      }
    }

    // ===== 랜덤 글 =====
    match /random_writes/{postId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn()
        && request.resource.data.authorId == request.auth.uid;
      allow update, delete: if isSignedIn()
        && resource.data.authorId == request.auth.uid;

      match /comments/{commentId} {
        allow read: if isSignedIn();
        allow create: if isSignedIn();
        allow delete: if isSignedIn()
          && resource.data.uid == request.auth.uid;
      }

      match /likes/{likeId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn();
      }

      match /saves/{saveId} {
        allow read: if isSignedIn();
        allow write: if isSignedIn();
      }
    }

    // ===== 신고 =====
    match /reports/{reportId} {
      allow read: if false; // 관리자만
      allow create: if isSignedIn();
    }

    // ===== 문의 (v1.1.0+) =====
    match /inquiries/{inquiryId} {
      allow read: if isSignedIn()
        && resource.data.userId == request.auth.uid;
      allow create: if isSignedIn()
        && request.resource.data.userId == request.auth.uid;
    }
  }
}
```

**Rules 게시:**
```
1. "게시" 버튼 클릭
2. 확인 다이얼로그에서 "게시" 클릭
3. "규칙이 게시되었습니다" 메시지 확인
```

#### 4. Rules Playground 테스트 (10분)
```
1. Firebase Console > Firestore > Rules 탭
2. "Rules Playground" 클릭
3. 시뮬레이션 위치: /home_posts/test123
4. 시뮬레이션 유형: get
5. 인증됨: ✓ 체크
6. 실행 클릭
7. ✅ "허용됨" 확인

다른 시나리오 테스트:
- 비인증 사용자 읽기 (차단되어야 함)
- 다른 사용자 게시글 삭제 (차단되어야 함)
- 본인 게시글 삭제 (허용되어야 함)
```

### ✅ Day 5 완료 조건
- [ ] main.dart에서 .env 관련 코드 제거
- [ ] Firestore Rules 게시 완료
- [ ] Rules Playground 테스트 통과
- [ ] flutter analyze 통과

### 📝 Day 5 마무리
```bash
git add .
git commit -m "refactor: .env 제거 및 Firestore Rules 강화"
```

---

## 📅 Day 6: 통합 테스트 및 검증 (1시간)

### 🎯 목표
- 전체 플로우 테스트
- 에러 케이스 확인
- 성능 검증
- 문서화

### ✅ 체크리스트

#### 1. 전체 빌드 (10분)
```bash
cd /Users/t2023-m0013/Documents/MyProject/your_write

# 클린 빌드
flutter clean
flutter pub get

# Android 빌드
flutter build apk --debug

# iOS 빌드 (Mac)
flutter build ios --debug
```

#### 2. 실제 기기 테스트 (30분)

**테스트 시나리오:**

✅ **시나리오 1: AI 글쓰기 성공**
```
1. 앱 실행
2. 로그인
3. AI 글쓰기 탭 이동
4. 프롬프트 입력: "봄을 주제로 짧은 시를 써주세요."
5. 생성 버튼 클릭
6. 로딩 표시 확인
7. 결과 확인 (제목, 키워드, 본문)
8. 게시 버튼 클릭
9. 목록에서 확인

예상 시간: 3-10초
```

✅ **시나리오 2: 짧은 프롬프트 에러**
```
1. AI 글쓰기
2. 프롬프트 입력: "안녕" (10자 미만)
3. 생성 버튼 클릭
4. 에러 메시지 확인: "프롬프트는 최소 10자 이상이어야 합니다."
```

✅ **시나리오 3: 비로그인 에러**
```
1. 로그아웃
2. AI 글쓰기 시도
3. 에러 메시지: "로그인이 필요합니다"
```

✅ **시나리오 4: 네트워크 오류**
```
1. 비행기 모드 켜기
2. AI 글쓰기 시도
3. 네트워크 에러 메시지 확인
4. 비행기 모드 끄기
5. 재시도 성공 확인
```

#### 3. Cloud Functions 로그 확인 (10분)
```
1. Firebase Console
2. Functions 메뉴
3. generateAI 클릭
4. Logs 탭
5. 최근 호출 확인
   - 성공: 200 OK
   - 요청 시간 확인 (3-10초)
   - 에러 없는지 확인
```

#### 4. 비용 확인 (5분)
```
1. Google Cloud Console
   https://console.cloud.google.com

2. Billing 메뉴

3. Cloud Functions 비용 확인
   - 예상: 매우 적음 (무료 할당량 내)

4. Gemini API 비용 확인
   - 예상: 무료 (Flash 모델 무료)
```

#### 5. 성능 측정 (5분)
```
성능 지표:
- 첫 호출: 5-10초 (Cold Start)
- 이후 호출: 3-5초 (Warm)
- 메모리: 256MB 충분
- 타임아웃: 60초 (충분)

만약 느리다면:
- 메모리 증가 (512MB)
- 타임아웃 증가 (120초)
```

### ✅ Day 6 완료 조건
- [ ] Android/iOS 빌드 성공
- [ ] 모든 테스트 시나리오 통과
- [ ] Cloud Functions 로그 정상
- [ ] 에러 처리 확인
- [ ] 성능 기준 충족

### 📝 최종 체크리스트
```
✅ API 키가 클라이언트에 노출되지 않음
✅ Cloud Function이 정상 작동함
✅ 에러 처리가 적절함
✅ Firestore Rules가 강화됨
✅ 성능이 양호함
✅ 비용이 예상 범위 내
```

### 📝 Day 6 마무리
```bash
git add .
git commit -m "test: 보안 패치 통합 테스트 완료"
git push origin dlworua/issue25
```

---

## 🎉 보안 패치 완료!

### ✅ 달성한 것
1. ✅ Gemini API 키 완전 보안 처리
2. ✅ Cloud Functions 기반 아키텍처
3. ✅ Firestore Security Rules 강화
4. ✅ 에러 처리 개선
5. ✅ 코드 정리 및 최적화

### 📊 Before vs After

| 항목 | Before | After |
|------|--------|-------|
| API 키 위치 | 클라이언트 (.env) | 서버 (Cloud Functions) |
| 보안 수준 | ⚠️ 취약 | ✅ 안전 |
| 디컴파일 위험 | ❌ 높음 | ✅ 없음 |
| 에러 처리 | 기본 | 상세 |
| Firestore 보안 | 기본 | 강화 |

### 🚀 다음 단계
이제 안심하고 스토어 배포를 진행할 수 있습니다!

```
다음 작업: 스토어 리스팅 작성 (Day 7)
또는: 추가 기능 개발 시작
```

---

## 📞 문제 발생 시

### 자주 발생하는 오류

**1. Functions 배포 실패**
```bash
# 에러: Permission denied
firebase login --reauth

# 에러: Project not found
firebase use --add
```

**2. Flutter 빌드 오류**
```bash
# 패키지 충돌
flutter pub cache repair
flutter clean
flutter pub get
```

**3. Cloud Function 호출 실패**
```
- Firebase Auth 로그인 확인
- Functions 지역 확인 (asia-northeast3)
- 인터넷 연결 확인
- Functions 로그 확인
```

**4. Firestore Rules 오류**
```
- Rules Playground로 시뮬레이션
- authorId 필드 존재 확인
- 인증 상태 확인
```

---

**문서 끝**
