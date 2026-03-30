import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:your_write/data/models/app_popup_model.dart';
import 'package:your_write/services/popup_service.dart';

class AppPopupDialog extends StatefulWidget {
  final List<AppPopupModel> popups;

  const AppPopupDialog({
    super.key,
    required this.popups,
  });

  @override
  State<AppPopupDialog> createState() => _AppPopupDialogState();
}

class _AppPopupDialogState extends State<AppPopupDialog> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onDontShowToday() async {
    // 현재 팝업만 "오늘 하루 열지 않기" 처리
    await PopupService.setDontShowToday(widget.popups[_currentPage].id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFFDF4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.campaign_rounded,
                      color: const Color(0xFFD4AF37),
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '공지',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6B4E3D),
                    ),
                  ),
                  const Spacer(),
                  // 페이지 인디케이터 (팝업이 여러 개일 때만)
                  if (widget.popups.length > 1)
                    Text(
                      '${_currentPage + 1}/${widget.popups.length}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8B6F47),
                      ),
                    ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: _onClose,
                    icon: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: const Color(0xFF8B6F47),
                    ),
                    padding: EdgeInsets.all(6.w),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // 컨텐츠 영역 (PageView)
            Flexible(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.popups.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final popup = widget.popups[index];
                      return _PopupContentWidget(popup: popup);
                    },
                  ),

                  // 좌우 화살표 버튼 (팝업이 여러 개일 때만)
                  if (widget.popups.length > 1) ...[
                    // 왼쪽 화살표
                    if (_currentPage > 0)
                      Positioned(
                        left: 12.w,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // 오른쪽 화살표
                    if (_currentPage < widget.popups.length - 1)
                      Positioned(
                        right: 12.w,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),

            // 하단 인디케이터 및 버튼 영역
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 페이지 인디케이터 (팝업이 여러 개일 때만)
                  if (widget.popups.length > 1) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.popups.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          width: _currentPage == index ? 20.w : 6.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFFD4AF37).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],

                  // 버튼
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _onDontShowToday,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8B6F47),
                            side: BorderSide(
                              color: const Color(0xFFD4AF37).withOpacity(0.4),
                              width: 1.5.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            '오늘 하루 열지 않기',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _onClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            '닫기',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 팝업 컨텐츠 위젯 (이미지 또는 WebView)
class _PopupContentWidget extends StatefulWidget {
  final AppPopupModel popup;

  const _PopupContentWidget({required this.popup});

  @override
  State<_PopupContentWidget> createState() => _PopupContentWidgetState();
}

class _PopupContentWidgetState extends State<_PopupContentWidget> {
  late WebViewController? _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // WebView인 경우에만 컨트롤러 초기화
    if (widget.popup.contentType == PopupContentType.webview) {
      _initWebView();
    } else {
      _webViewController = null;
      _isLoading = false;
    }
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('[PopupContent] WebView 오류: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.popup.contentUrl));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.popup.contentType == PopupContentType.image) {
      // 이미지 타입
      return Container(
        color: Colors.white,
        child: Center(
          child: Image.network(
            widget.popup.contentUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFFD4AF37),
                  strokeWidth: 2.5,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.sp,
                      color: const Color(0xFF8B6F47).withOpacity(0.5),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '이미지를 불러올 수 없습니다',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF8B6F47),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } else {
      // WebView 타입
      return Container(
        color: Colors.white,
        child: Stack(
          children: [
            if (_webViewController != null)
              WebViewWidget(controller: _webViewController!),
            if (_isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFD4AF37),
                    strokeWidth: 2.5,
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
}
