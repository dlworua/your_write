import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final List<String> _reportReasons = [
    '욕설/비방',
    '음란성 내용',
    '도배/광고',
    '개인정보 노출',
    '기타',
  ];

  String? _selectedReason;
  final TextEditingController _etcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('게시글 신고'),
      backgroundColor: Color(0XDFFFF8E1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._reportReasons.map(
            (reason) => RadioListTile<String>(
              title: Text(reason),
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),
          ),
          if (_selectedReason == '기타')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _etcController,
                decoration: const InputDecoration(
                  labelText: '신고 사유를 입력하세요',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소', style: TextStyle(color: Colors.blue[800])),
        ),
        TextButton(
          onPressed: () {
            if (_selectedReason == null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('신고 사유를 선택하세요.')));
              return;
            }
            if (_selectedReason == '기타' && _etcController.text.trim().isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('기타 사유를 입력해주세요.')));
              return;
            }

            final result =
                _selectedReason == '기타'
                    ? '기타 - ${_etcController.text.trim()}'
                    : _selectedReason;

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '신고가 접수되었습니다. ($result)',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.teal[50],
              ),
            );

            // TODO: 신고 데이터 처리 로직
          },
          child: Text('신고', style: TextStyle(color: Colors.red[600])),
        ),
      ],
    );
  }
}
