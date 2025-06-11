import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const CommentInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 📝 입력창
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200], // 밝은 회색 배경
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '댓글을 입력하세요...',
                border: InputBorder.none,
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 📤 전송 버튼
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              FocusScope.of(context).unfocus(); // 키보드 내리기
              onSubmitted(text);
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: const Size(0, 40),
            foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.amber,
          ),
          child: const Text(
            '전송',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
