import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDialog extends StatefulWidget {
  final String boardType; // 예: 'home_posts', 'ai_writes', 'random_writes'
  final String postId;

  const ReportDialog({
    super.key,
    required this.boardType,
    required this.postId,
  });

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
  bool _isLoading = false;

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

  Future<void> _handleReport() async {
    if (_selectedReason == null) {
      _showSnackBar(context, '신고 사유를 선택하세요.', Colors.orange);
      return;
    }
    if (_selectedReason == '기타' && _etcController.text.trim().isEmpty) {
      _showSnackBar(context, '기타 사유를 입력해주세요.', Colors.orange);
      return;
    }

    final reason =
        _selectedReason == '기타'
            ? '기타 - ${_etcController.text.trim()}'
            : _selectedReason!;

    setState(() {
      _isLoading = true;
    });

    try {
      final docRef = FirebaseFirestore.instance
          .collection(widget.boardType)
          .doc(widget.postId);

      final reportsCollection = FirebaseFirestore.instance.collection(
        'reports',
      );

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception('게시글이 존재하지 않습니다.');
        }

        final data = snapshot.data()!;
        final currentCount = (data['reportCount'] ?? 0) as int;
        final newCount = currentCount + 1;

        if (newCount >= 5) {
          // 5회 이상 신고 시 게시글 삭제
          transaction.delete(docRef);
        } else {
          // 신고 카운트만 증가
          transaction.update(docRef, {'reportCount': newCount});
        }

        // 신고 로그 저장
        reportsCollection.add({
          'postId': widget.postId,
          'boardType': widget.boardType,
          'reason': reason,
          'reportCount': newCount,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });

      Navigator.pop(context);
      _showSnackBar(
        context,
        '신고가 접수되었습니다. ($reason)',
        Colors.green,
        icon: Icons.check_circle_rounded,
      );
    } catch (e) {
      _showSnackBar(context, '신고 처리 중 오류가 발생했습니다.', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                          onPressed:
                              _isLoading ? null : () => Navigator.pop(context),
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
                          onPressed: _isLoading ? null : _handleReport,
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
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
