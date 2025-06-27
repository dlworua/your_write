class UserModel {
  final String uid;
  final String email;
  final String nickname;
  final bool agreeMarketing;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    this.agreeMarketing = false, // 기본값 false
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'agreeMarketing': agreeMarketing,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      nickname: map['nickname'] ?? '',
      agreeMarketing: map['agreeMarketing'] ?? false,
    );
  }
}
