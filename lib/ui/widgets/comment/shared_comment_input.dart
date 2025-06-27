import 'package:flutter/material.dart';

class SharedCommentInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  const SharedCommentInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.send,
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          onSubmitted(value.trim());
        }
      },
      decoration: InputDecoration(
        hintText: '댓글을 입력하세요...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onSubmitted(controller.text.trim());
              controller.clear();
            }
          },
        ),
      ),
    );
  }
}
