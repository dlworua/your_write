const functions = require("firebase-functions");
const https = require("https");

// Gemini API Key
const getApiKey = () => functions.config().gemini.key;

/**
 * AI 텍스트 생성 Cloud Function
 * @param {Object} data - { prompt: string }
 * @param {Object} context - Firebase Auth Context
 * @return {Object} - { success: boolean, text: string }
 */
exports.generateAI = functions
    .region("asia-northeast3") // 서울 리전 (빠른 응답)
    .runWith({
      timeoutSeconds: 60, // 최대 60초
      memory: "256MB", // 최소 메모리 (비용 절감)
    })
    .https.onCall(async (data, context) => {
      // ===== 1. 인증 확인 =====
      if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "로그인이 필요합니다.",
        );
      }

      // ===== 2. 입력값 검증 =====
      const {prompt} = data;

      if (!prompt) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "프롬프트가 필요합니다.",
        );
      }

      if (typeof prompt !== "string") {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "프롬프트는 문자열이어야 합니다.",
        );
      }

      if (prompt.length < 10) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "프롬프트는 최소 10자 이상이어야 합니다.",
        );
      }

      if (prompt.length > 5000) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "프롬프트는 최대 5000자까지 가능합니다.",
        );
      }

      // ===== 3. Rate Limiting (선택) =====
      // TODO: Firestore로 사용자별 호출 횟수 제한 구현
      // 예: 하루 50회 제한

      console.log("🔐 사용자:", context.auth.uid);
      console.log("✍️ 프롬프트 길이:", prompt.length);

      try {
        // ===== 4. Gemini API 호출 (REST API 직접 호출) =====
        const apiKey = getApiKey();
        const modelName = "gemini-2.0-flash"; // Flutter와 동일한 모델
        const url = `https://generativelanguage.googleapis.com/v1/models/${modelName}:generateContent?key=${apiKey}`;

        const requestBody = JSON.stringify({
          contents: [{
            parts: [{
              text: prompt,
            }],
          }],
        });

        const response = await new Promise((resolve, reject) => {
          const req = https.request(url, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "Content-Length": Buffer.byteLength(requestBody),
            },
          }, (res) => {
            let data = "";
            res.on("data", (chunk) => {
              data += chunk;
            });
            res.on("end", () => {
              if (res.statusCode === 200) {
                resolve(JSON.parse(data));
              } else {
                reject(new Error(`API 에러: ${res.statusCode} - ${data}`));
              }
            });
          });

          req.on("error", (error) => {
            reject(error);
          });

          req.write(requestBody);
          req.end();
        });

        const text = response.candidates?.[0]?.content?.parts?.[0]?.text ||
          "응답을 생성할 수 없습니다.";

        console.log("✅ AI 생성 성공, 길이:", text.length);

        // ===== 5. 응답 반환 =====
        return {
          success: true,
          text: text,
          timestamp: new Date().toISOString(),
        };
      } catch (error) {
        // ===== 6. 에러 처리 =====
        console.error("❌ Gemini API 오류:", error);

        // 사용자 친화적 에러 메시지
        let errorMessage = "AI 생성 중 오류가 발생했습니다.";

        if (error.message && error.message.includes("429")) {
          errorMessage = "API 할당량이 초과되었습니다. " +
            "잠시 후 다시 시도해주세요.";
        } else if (error.message && error.message.includes("quota")) {
          errorMessage = "API 할당량이 초과되었습니다. " +
            "잠시 후 다시 시도해주세요.";
        } else if (error.message && error.message.includes("RESOURCE_EXHAUSTED")) {
          errorMessage = "API 할당량이 초과되었습니다. " +
            "1-2분 후 다시 시도해주세요.";
        } else if (error.message && error.message.includes("invalid")) {
          errorMessage = "유효하지 않은 요청입니다.";
        } else if (error.message && error.message.includes("timeout")) {
          errorMessage = "요청 시간이 초과되었습니다. 다시 시도해주세요.";
        }

        throw new functions.https.HttpsError(
            "internal",
            errorMessage,
            error.message,
        );
      }
    });

// 테스트 함수는 삭제 (또는 주석 처리)
// exports.helloWorld = functions.https.onCall((data, context) => {
//   return {
//     message: 'Hello from Cloud Functions!',
//     timestamp: new Date().toISOString(),
//   };
// });
