const functions = require('firebase-functions');

// 간단한 테스트 함수
exports.helloWorld = functions.https.onCall((data, context) => {
  return {
    message: 'Hello from Cloud Functions!',
    timestamp: new Date().toISOString(),
  };
});
