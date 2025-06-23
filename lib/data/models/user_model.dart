class UserModel {
  final String uid;
  final String email;
  final String nickname;

  UserModel({required this.uid, required this.email, required this.nickname});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'nickname': nickname};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      nickname: map['nickname'] ?? '',
    );
  }
}
