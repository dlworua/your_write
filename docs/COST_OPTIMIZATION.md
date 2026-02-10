# Your Write 비용 최적화 전략

**목표**: 기능 유지하면서 월 비용을 **무료 ~ 1만원 이하**로 유지

---

## 💰 현재 예상 비용 분석

### Firebase Blaze 플랜 무료 할당량
```
✅ Cloud Functions
- 호출: 월 200만 회 무료
- 컴퓨팅 시간: 40만 GB·초/월 무료
- 네트워크: 5GB/월 무료

✅ Firestore
- 읽기: 5만 회/일 무료 (월 150만 회)
- 쓰기: 2만 회/일 무료 (월 60만 회)
- 삭제: 2만 회/일 무료
- 저장소: 1GB 무료

✅ Firebase Storage
- 저장: 5GB 무료
- 다운로드: 1GB/일 무료 (월 30GB)
- 업로드: 2만 회/일 무료

✅ Firebase Auth
- 완전 무료 (제한 없음)

✅ Firebase Hosting
- 저장: 10GB 무료
- 전송: 360MB/일 무료 (월 10GB)

✅ Gemini API
- gemini-2.0-flash-exp: 완전 무료 (현재)
- gemini-1.5-flash: 150만 토큰/일 무료
```

### 소규모 앱 예상 사용량 (DAU 100명 기준)
```
사용자당 평균 활동:
- 앱 실행: 1회
- 글 읽기: 5개 (Firestore 읽기 5회)
- 글 쓰기: 0.2개 (5명 중 1명, Firestore 쓰기 0.2회)
- AI 글 생성: 0.1회 (10명 중 1명, Functions 호출 0.1회)
- 댓글: 0.3회 (Firestore 쓰기 0.3회)

일일 총 사용량 (DAU 100명):
- Firestore 읽기: 500회 (무료 한도: 5만회)
- Firestore 쓰기: 50회 (무료 한도: 2만회)
- Functions 호출: 10회 (무료 한도: 월 200만회 ÷ 30일 = 66,666회)

월 총 사용량:
- Firestore 읽기: 15,000회 (한도의 1%)
- Firestore 쓰기: 1,500회 (한도의 2.5%)
- Functions 호출: 300회 (한도의 0.015%)

예상 비용: 0원 (모두 무료 한도 내)
```

---

## 🎯 비용 최적화 전략 (3단계)

---

## ✅ **전략 1: Gemini API를 무료로 유지** (권장!)

### Option A: gemini-2.0-flash-exp 사용 (현재)
```javascript
// 현재 코드 그대로 사용
const model = genAI.getGenerativeModel({
  model: 'gemini-2.0-flash-exp'  // 완전 무료!
});
```

**장점:**
- ✅ 완전 무료
- ✅ 빠른 속도
- ✅ 품질 우수

**단점:**
- ⚠️ 실험 버전 (언젠가 유료화 가능)
- ⚠️ 안정성 보장 없음

**결론**: 초기에는 이거 사용, 유료화 시 Option B로 전환

---

### Option B: gemini-1.5-flash (안정 버전, 무료 한도 큼)
```javascript
const model = genAI.getGenerativeModel({
  model: 'gemini-1.5-flash'  // 무료 한도: 150만 토큰/일
});
```

**무료 한도:**
- 하루 150만 토큰
- 요청당 평균 1,000 토큰 가정
- 하루 1,500회 요청 가능
- **월 45,000회 AI 글 생성 가능!**

**DAU 100명 기준:**
- 1인당 0.1회 AI 생성
- 하루 10회, 월 300회
- **무료 한도의 0.67%만 사용** ✅

**결론**: 이것만으로도 충분! 유료 전환 없음

---

### Option C: Hugging Face 무료 모델 (백업)
```javascript
// 완전 무료 오픈소스 LLM
// 예: mistral-7b, llama-2 등
// 품질은 Gemini보다 낮지만 무료
```

**사용 시점**: Gemini 무료 한도 초과 시

---

## ✅ **전략 2: Cloud Functions 비용 제로화**

### 최적화 방법

#### 1. 메모리 최소화
```javascript
// functions/index.js
exports.generateAI = functions
  .region('asia-northeast3')
  .runWith({
    memory: '256MB',  // 최소 메모리 (기본 256MB)
    timeoutSeconds: 60,
  })
  .https.onCall(async (data, context) => {
    // ...
  });
```

**비용 절감:**
- 256MB: $0.000000463/100ms
- 512MB: $0.000000925/100ms (2배)
- 1GB: $0.000001650/100ms (3.5배)

**결론**: 256MB면 충분함

---

#### 2. Cold Start 줄이기 (선택)
```javascript
// 최소 인스턴스 0으로 유지 (무료)
exports.generateAI = functions
  .runWith({
    memory: '256MB',
    minInstances: 0,  // Cold Start 감수, 비용 0
    maxInstances: 10,
  })
  .https.onCall(async (data, context) => {
    // ...
  });
```

**Cold Start:**
- 첫 호출: 5-10초 (느림)
- 이후 호출: 2-3초 (빠름)

**트레이드오프:**
- minInstances: 0 → 무료, 하지만 느림
- minInstances: 1 → 월 $5-10, 항상 빠름

**결론**: 초기에는 0으로 유지, 사용자 불만 시 1로 증가

---

#### 3. 캐싱 추가 (선택)
```javascript
// AI 생성 결과 캐싱 (동일 프롬프트 재사용)
const cache = new Map();

exports.generateAI = functions.https.onCall(async (data, context) => {
  const cacheKey = data.prompt;

  // 캐시 확인
  if (cache.has(cacheKey)) {
    console.log('캐시 히트!');
    return cache.get(cacheKey);
  }

  // AI 호출
  const result = await model.generateContent(data.prompt);

  // 캐시 저장 (1시간)
  cache.set(cacheKey, result);
  setTimeout(() => cache.delete(cacheKey), 3600000);

  return result;
});
```

**비용 절감:**
- 중복 요청 50% 가정
- Functions 호출 50% 감소

**주의**: 메모리 사용량 증가 가능

---

## ✅ **전략 3: Firestore 비용 최소화**

### 최적화 방법

#### 1. 읽기 횟수 줄이기 - 캐싱
```dart
// Flutter 앱에서 로컬 캐싱
class CachedPostService {
  final Map<String, List<WriteModel>> _cache = {};
  final Duration _cacheDuration = Duration(minutes: 5);

  Future<List<WriteModel>> fetchAiPosts() async {
    // 캐시 확인
    if (_cache.containsKey('ai_posts')) {
      return _cache['ai_posts']!;
    }

    // Firestore 읽기
    final posts = await _firestore.collection('ai_writes').get();

    // 캐시 저장
    _cache['ai_posts'] = posts;
    Future.delayed(_cacheDuration, () => _cache.remove('ai_posts'));

    return posts;
  }
}
```

**비용 절감:**
- 읽기 횟수 70-80% 감소
- 사용자 경험도 향상 (더 빠름)

---

#### 2. Pagination (무한 스크롤)
```dart
// 한 번에 20개만 로드 (v1.1.0에서 구현 예정)
await _firestore
  .collection('ai_writes')
  .orderBy('date', descending: true)
  .limit(20)  // ← 중요!
  .get();
```

**비용 절감:**
- 전체 로드: 100개 읽기
- Pagination: 20개 읽기
- **80% 절감!**

---

#### 3. 실시간 리스너 최소화
```dart
// ❌ 나쁜 예: 실시간 리스너 (계속 읽기 발생)
_firestore.collection('ai_writes')
  .snapshots()  // 변경마다 읽기!
  .listen((snapshot) {
    // ...
  });

// ✅ 좋은 예: 필요할 때만 읽기
Future<void> refresh() async {
  final snapshot = await _firestore
    .collection('ai_writes')
    .get();  // 한 번만 읽기
}
```

**비용 절감:**
- 실시간 리스너: 변경마다 읽기 (하루 수백 회)
- 수동 로드: 필요할 때만 (하루 수십 회)
- **90% 절감!**

---

#### 4. 복합 쿼리 피하기
```dart
// ❌ 비용 많이 드는 쿼리
await _firestore
  .collection('ai_writes')
  .where('type', '==', 'ai')
  .where('authorId', '==', uid)
  .orderBy('date')
  .get();  // 복합 인덱스 필요, 읽기 많음

// ✅ 간단한 쿼리
await _firestore
  .collection('ai_writes')
  .where('type', '==', 'ai')
  .limit(20)
  .get();  // 읽기 적음
```

---

## ✅ **전략 4: Storage 비용 최소화** (이미지 첨부 시)

### 최적화 방법

#### 1. 이미지 압축
```dart
import 'package:image/image.dart' as img;

Future<File> compressImage(File file) async {
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);

  // 리사이즈 (최대 1080px)
  final resized = img.copyResize(image!, width: 1080);

  // JPEG 압축 (품질 85%)
  final compressed = img.encodeJpg(resized, quality: 85);

  return File(file.path)..writeAsBytesSync(compressed);
}
```

**비용 절감:**
- 원본: 5MB
- 압축 후: 500KB
- 저장 공간 90% 절감
- 다운로드 비용 90% 절감

---

#### 2. CDN 캐싱 (자동)
Firebase Storage는 자동으로 CDN을 사용하므로 추가 설정 불필요!

---

## 📊 **최종 예상 비용**

### 시나리오 1: 소규모 (DAU 100명)
```
- Firestore: 0원 (무료 한도 내)
- Cloud Functions: 0원 (무료 한도 내)
- Storage: 0원 (무료 한도 내)
- Gemini API: 0원 (무료 모델)
- Firebase Auth: 0원 (항상 무료)
───────────────────────────
월 총 비용: 0원 ✅
```

### 시나리오 2: 중규모 (DAU 500명)
```
- Firestore: 0원 (무료 한도 내)
- Cloud Functions: 0원 (무료 한도 내)
- Storage: 0-5천원 (이미지 많을 경우)
- Gemini API: 0원 (무료 한도 내)
- Firebase Auth: 0원
───────────────────────────
월 총 비용: 0-5천원 ✅
```

### 시나리오 3: 대규모 (DAU 2,000명)
```
- Firestore: 0-1만원 (일부 초과)
- Cloud Functions: 0-5천원 (일부 초과)
- Storage: 5천-1만원
- Gemini API: 0원 (여전히 무료 한도 내!)
- Firebase Auth: 0원
───────────────────────────
월 총 비용: 5천-2.5만원
```

---

## 🎯 **권장 구성 (비용 최소화)**

### Phase 1: 초기 배포 (v1.0 - v1.3)
```
✅ gemini-2.0-flash-exp (완전 무료)
✅ Cloud Functions 256MB, minInstances: 0
✅ Firestore Pagination + 캐싱
✅ 이미지 압축 (추가 시)

예상 월 비용: 0원
```

### Phase 2: 성장기 (v1.4 - v2.0)
```
✅ gemini-1.5-flash (무료 한도 큼)
✅ Cloud Functions 256MB, minInstances: 0-1
✅ Firestore 최적화 유지
✅ Storage 압축 유지

예상 월 비용: 0-1만원
```

### Phase 3: 수익화 후 (v2.0+)
```
✅ gemini-1.5-flash 또는 gemini-1.5-pro (필요 시 유료)
✅ Cloud Functions minInstances: 1-2 (빠른 응답)
✅ 광고 수익으로 비용 충당

예상 월 비용: 1-5만원
예상 월 수익: 5-50만원 (광고+구독)
순이익: 0-45만원 ✅
```

---

## 🚨 **비용 초과 방지 알림 설정**

### Firebase Console에서 설정
```
1. Firebase Console > 설정 > 사용량 및 결제
2. "예산 알림" 설정
   - 월 예산: 10,000원
   - 알림: 50%, 90%, 100%
3. 이메일 알림 활성화
```

### 예산 초과 시 자동 차단 (선택)
```
1. Google Cloud Console 접속
2. Billing > Budgets & alerts
3. "Budget alert" 생성
4. Actions: "Disable billing account" (위험!)
```

**주의**: 자동 차단 시 앱 전체가 멈춤! 알림만 설정 권장

---

## 📝 **비용 모니터링 체크리스트**

### 매주 확인
```
□ Firebase Console > 사용량 확인
□ Firestore 읽기/쓰기 횟수
□ Cloud Functions 호출 횟수
□ Storage 사용량
```

### 매월 확인
```
□ Google Cloud Billing 명세서
□ 무료 한도 초과 여부
□ 비용 증가 추세
```

---

## ✅ **결론: 기능 유지하면서 무료 가능!**

### 핵심 전략
1. **Gemini API 무료 모델 사용** (gemini-2.0-flash-exp 또는 1.5-flash)
2. **Cloud Functions 최소 메모리** (256MB, minInstances: 0)
3. **Firestore Pagination + 캐싱**
4. **이미지 압축** (추가 시)
5. **예산 알림 설정** (월 1만원)

### 예상 결과
- **DAU 100-500명**: 월 0원 ✅
- **DAU 500-1,000명**: 월 0-5천원 ✅
- **DAU 1,000-2,000명**: 월 5천-1만원 ✅

### 추가 질문
- **Q**: Gemini 무료 모델이 유료화되면?
- **A**: gemini-1.5-flash로 전환 (무료 한도 150만 토큰/일)

- **Q**: 무료 한도 초과하면?
- **A**: 예산 알림 받고, 최적화 또는 광고 수익으로 충당

---

**결론: Blaze 플랜 업그레이드해도 비용 걱정 없습니다! 무료로 운영 가능!** ✅
