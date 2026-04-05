# 보안 패치 진행 현황

**작성일**: 2026-02-16
**브랜치**: dlworua/issue25
**목표**: Gemini API 키 서버 이전 + Firestore Rules 강화

---

## 전체 진행 현황

| Day | 목표 | 상태 | 완료일 |
|-----|------|------|--------|
| Day 1 | Firebase Cloud Functions 초기 설정 | ✅ 완료 | - |
| Day 2 | generateAI Cloud Function 코드 작성 | ✅ 완료 | - |
| Day 3 | Cloud Function 배포 및 Flutter 테스트 | ✅ 완료 | 2026-02-16 |
| Day 4 | ai_write_service.dart Cloud Functions로 교체 | ✅ 완료 | 2026-02-16 |
| Day 5 | .env 제거 및 Firestore Rules 강화 | ✅ 완료 | 2026-02-16 |
| Day 6 | 통합 테스트 및 최종 정리 | ✅ 완료 | 2026-02-16 |

---

## Day 3 상세 내역 (완료)

### 주요 이슈: Gemini 모델 API 버전 불일치
- **원인**: Node.js `@google/generative-ai` 라이브러리가 v1beta API 사용
- **Flutter 클라이언트**: `google_generative_ai ^0.4.7` → v1 API 사용
- **결과**: v1beta에서 `gemini-2.0-flash` 모델 404 오류 발생

### 해결책: 라이브러리 제거 후 REST API 직접 호출
```javascript
// @google/generative-ai 제거
// Node.js 내장 https 모듈로 직접 v1 API 호출
const url = `https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent?key=${apiKey}`;
```

### 추가 이슈: MissingPluginException
- **원인**: `cloud_functions` 패키지 추가 후 네이티브 레이어 미등록
- **해결**: `flutter clean` → `pod deintegrate` → `pod install` → 앱 완전 재빌드

### 최종 확인 로그
```
flutter: 🔐 현재 사용자: xqe0Mi3mhnTaXAOUiezNqQLXmiO2
flutter: ✍️ 프롬프트: 나는 멋진 사람입니다.
flutter: ✅ 응답 데이터: {success: true, text: 당신이 멋진 사람이라고 생각하시는군요!...}
```

---

## Day 4 상세 내역 (완료)

### 변경 파일: `lib/ui/pages/ai/ai_write/ai_write_service.dart`

| 항목 | Before | After |
|------|--------|-------|
| API 호출 방식 | `google_generative_ai` SDK | Cloud Functions HTTP 호출 |
| API 키 | `.env`에서 로드 | 서버에만 존재 (제거됨) |
| 에러 처리 | 일반 Exception | `FirebaseFunctionsException` 코드별 처리 |

### Cold Start 보완 전략
1. **warmUp()** 메서드 추가: AI 탭 진입 시 더미 호출로 함수 웜업
2. **동적 로딩 메시지**: 3초마다 순환 (체감 대기시간 감소)
   - "AI가 생각을 시작하고 있어요..."
   - "아이디어를 정리하는 중..."
   - "글을 써 내려가는 중..."
   - "마무리 손질 중..."

---

## Day 5 상세 내역 (완료)

### 변경 파일 목록

#### 1. `lib/main.dart`
- `flutter_dotenv` import 제거
- `dotenv.load()` 제거
- `print(GEMINI_API_KEY)` 보안 로그 제거
- `ProviderScope`, `SystemUiOverlayStyle` const 추가

#### 2. `pubspec.yaml`
- `google_generative_ai: ^0.4.7` 제거
- `flutter_dotenv: ^5.2.1` 제거
- 에셋에서 `.env` 항목 제거

#### 3. `firestore.rules` (신규 생성 + 배포 완료)

**보안 정책 요약:**
```
미인증 사용자 → 전체 차단
인증된 사용자 → 컬렉션별 세밀한 권한 제어
```

| 컬렉션 | 읽기 | 쓰기 | 수정/삭제 |
|--------|------|------|-----------|
| users | 인증 사용자 | 본인만 | 본인만 |
| home_posts | 인증 사용자 | 인증 사용자 | 본인 글만 |
| random_writes | 인증 사용자 | 인증 사용자 | 본인 글만 |
| ai_writes | 인증 사용자 | 인증 사용자 | 본인 글만 |
| likes/saves | 인증 사용자 | 본인 UID만 | 본인만 |
| comments | 인증 사용자 | 인증 사용자 | 본인만 |
| reports | 인증 사용자 | 생성만 가능 | 불가 |

#### 4. `firebase.json`
- `firestore.rules` 경로 설정 추가

---

## Before vs After 비교

| 항목 | Before | After |
|------|--------|-------|
| Gemini API 키 위치 | 클라이언트 `.env` 파일 | 서버 Firebase Functions Config |
| 클라이언트 의존성 | `google_generative_ai`, `flutter_dotenv` | 제거됨 |
| API 호출 경로 | 앱 → Gemini API | 앱 → Cloud Functions → Gemini API |
| 인증 확인 | 없음 | Cloud Function에서 강제 확인 |
| Firestore 규칙 | 미설정 (취약) | 컬렉션별 세밀한 권한 |
| Cold Start 대응 | 없음 | warmUp() + 동적 로딩 메시지 |

---

## Day 6 상세 내역 (완료)

### 변경 파일

- `ai_write_page.dart`: 잘못된 `await` 사용 제거 (기존 코드 버그 수정)
- `my_profile_page.dart`: 테스트용 버그 아이콘 버튼 제거
- `app_routes.dart`: `/test-cloud-function` 라우트 및 import 제거

### flutter analyze 최종 결과
```
1 issue found (info only - 기존 코드 lint 경고, 동작에 영향 없음)
에러: 0개
```

## ✅ 보안 패치 완료 (2026-02-16)

| 항목 | 상태 |
|------|------|
| Gemini API 키 클라이언트 제거 | ✅ |
| Cloud Functions 서버 이전 | ✅ |
| Firestore 보안 규칙 적용 | ✅ |
| dotenv 의존성 완전 제거 | ✅ |
| google_generative_ai SDK 제거 | ✅ |
| Cold Start 보완 | ✅ |
| 테스트 코드 정리 | ✅ |

---

## 현재 배포 정보

| 항목 | 값 |
|------|-----|
| 함수명 | generateAI |
| 리전 | asia-northeast3 (서울) |
| 메모리 | 256MB |
| 타임아웃 | 60초 |
| 모델 | gemini-2.0-flash (v1 API) |
| Firestore Rules | 배포 완료 |
