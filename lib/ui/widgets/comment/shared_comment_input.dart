import 'package:flutter/material.dart';

class SharedCommentInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const SharedCommentInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
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
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              FocusScope.of(context).unfocus();
              onSubmitted(text);
            }
          },
          style: TextButton.styleFrom(backgroundColor: Colors.amber),
          child: const Text(
            '전송',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
