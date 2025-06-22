import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _reportReasons = [
    {
      'text': '욕설/비방',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.orange,
    },
    {'text': '음란성 내용', 'icon': Icons.block_rounded, 'color': Colors.red},
    {
      'text': '도배/광고',
      'icon': Icons.my_library_books_rounded,
      'color': Colors.purple,
    },
    {
      'text': '개인정보 노출',
      'icon': Icons.privacy_tip_rounded,
      'color': Colors.blue,
    },
    {'text': '기타', 'icon': Icons.more_horiz_rounded, 'color': Colors.grey},
  ];

  String? _selectedReason;
  final TextEditingController _etcController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _etcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 헤더
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade400, Colors.red.shade600],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.report_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '게시글 신고',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 신고 사유 목록
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children:
                        _reportReasons.asMap().entries.map((entry) {
                          final index = entry.key;
                          final reason = entry.value;
                          final isSelected = _selectedReason == reason['text'];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.all(index == 0 ? 8 : 4),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? reason['color'].withOpacity(0.1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: reason['color'],
                                        width: 2,
                                      )
                                      : null,
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? reason['color']
                                          : reason['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  reason['icon'],
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : reason['color'],
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                reason['text'],
                                style: TextStyle(
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                  color:
                                      isSelected
                                          ? reason['color']
                                          : Colors.black87,
                                ),
                              ),
                              trailing:
                                  isSelected
                                      ? Icon(
                                        Icons.check_circle,
                                        color: reason['color'],
                                      )
                                      : null,
                              onTap: () {
                                setState(() {
                                  _selectedReason = reason['text'];
                                });
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ),

                // 기타 사유 입력
                if (_selectedReason == '기타') ...[
                  const SizedBox(height: 16),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _etcController,
                        decoration: InputDecoration(
                          labelText: '신고 사유를 입력하세요',
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: Icon(
                            Icons.edit_rounded,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        maxLines: 3,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // 버튼들
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade400, Colors.red.shade600],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_selectedReason == null) {
                              _showSnackBar(
                                context,
                                '신고 사유를 선택하세요.',
                                Colors.orange,
                              );
                              return;
                            }
                            if (_selectedReason == '기타' &&
                                _etcController.text.trim().isEmpty) {
                              _showSnackBar(
                                context,
                                '기타 사유를 입력해주세요.',
                                Colors.orange,
                              );
                              return;
                            }

                            final result =
                                _selectedReason == '기타'
                                    ? '기타 - ${_etcController.text.trim()}'
                                    : _selectedReason;

                            Navigator.pop(context);
                            _showSnackBar(
                              context,
                              '신고가 접수되었습니다. ($result)',
                              Colors.green,
                              icon: Icons.check_circle_rounded,
                            );

                            // TODO: 신고 데이터 처리 로직
                          },
                          child: const Text(
                            '신고하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message,
    Color color, {
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
