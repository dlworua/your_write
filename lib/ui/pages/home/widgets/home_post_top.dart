import 'package:flutter/material.dart';

class HomePostTop extends StatelessWidget {
  const HomePostTop({super.key});

  void _showReportDialog(BuildContext context) {
    final List<String> reportReasons = [
      '욕설/비방',
      '음란성 내용',
      '광고성 게시글',
      '개인정보 노출',
      '기타',
    ];
    String? selectedReason;
    final TextEditingController etcController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('게시글 신고'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...reportReasons.map(
                      (reason) => RadioListTile<String>(
                        title: Text(reason),
                        value: reason,
                        groupValue: selectedReason,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),
                    ),
                    if (selectedReason == '기타') ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: etcController,
                        decoration: const InputDecoration(
                          labelText: '신고 사유를 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (selectedReason == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('신고 사유를 선택하세요.')),
                        );
                        return;
                      }

                      if (selectedReason == '기타' &&
                          etcController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('기타 사유를 입력해주세요.')),
                        );
                        return;
                      }

                      final reason =
                          selectedReason == '기타'
                              ? '기타 - ${etcController.text.trim()}'
                              : selectedReason;

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('신고가 접수되었습니다. ($reason)')),
                      );

                      // TODO: 여기에 서버로 신고 전송 또는 저장 처리 추가
                    },
                    child: const Text('신고'),
                  ),
                ],
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/app_logo.png', fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Text('닉네임'),
            Spacer(),
            IconButton(
              onPressed: () => _showReportDialog(context),
              icon: Icon(Icons.flag),
            ),
          ],
        ),
      ),
    );
  }
}
