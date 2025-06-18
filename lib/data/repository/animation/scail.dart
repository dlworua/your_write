import 'package:flutter/material.dart';

class ScalingImage extends StatefulWidget {
  const ScalingImage({super.key});

  @override
  State<ScalingImage> createState() => _ScalingImageState();
}

class _ScalingImageState extends State<ScalingImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // 커졌다 작아졌다 반복

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset('assets/app_logo.png', width: 100, height: 100),
      ),
    );
  }
}
