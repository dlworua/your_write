import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'My Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
          ), // 프로필 사진
          const SizedBox(height: 8),
          const Text(
            '수줍은 잡화점',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('@sujubeun819', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _FollowInfo(title: '팔로잉', count: 37),
              SizedBox(width: 16),
              _FollowInfo(title: '팔로잉', count: 370),
              SizedBox(width: 16),
              _FollowInfo(title: '팔로잉', count: 102),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () {}, child: const Text('Edit Profile')),
        ],
      ),
    );
  }
}

class _FollowInfo extends StatelessWidget {
  final String title;
  final int count;

  const _FollowInfo({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
