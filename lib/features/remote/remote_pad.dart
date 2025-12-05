import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../home/home_page.dart';
import 'shake_mode.dart';

// ============================================================================
// 📐 디자인 상수 (색상, 크기, 스타일)
// ============================================================================

/// 색상 상수
class _AppColors {
  // 주요 색상
  static const Color primaryBlue = Color(0xFF3A7BFF); // 파란색 (버튼, 포인터)
  static const Color powerRed = Color(0xFFE5574E); // 빨간색 (전원 버튼)

  // 회색 계열
  static const Color darkGray = Color(0xFF6D6F71); // 진한 회색 (아이콘, 텍스트)
  static const Color mediumGray = Color(0xFF636468); // 중간 회색 (메뉴 점)
  static const Color lightGray = Color(0xFFD1D3D7); // 연한 회색 (로커 배경)
  static const Color borderGray = Color(0xFFC2C4C8); // 테두리 회색
  static const Color buttonBorderGray = Color(0xFFDADDE0); // 버튼 테두리 회색
  static const Color touchPadGray = Color(0xFFE0E2E6); // 터치패드 배경 회색
  static const Color scrollBarGray = Color(0xFFC9D0DB); // 스크롤바 회색
  static const Color containerGray = Color(0xFFEFF1F5); // 컨테이너 배경 회색
  static const Color bottomButtonGray = Color(0xFFD3D2D7); // 하단 버튼 배경 회색
  static const Color bottomButtonBorderGray = Color(0xFFC0BFC4); // 하단 버튼 테두리 회색

  // 텍스트 색상
  static const Color textDark = Color(0xFF0F1014); // 거의 검은색 (텍스트)
  static const Color textWhite = Colors.white; // 흰색

  // 배경 색상
  static const Color backgroundWhite = Colors.white; // 흰색 배경
  static const Color backgroundOffWhite = Color(0xFFFDFDFD); // 거의 흰색 배경
}

/// 크기 상수
class _AppSizes {
  // 버튼 크기
  static const double powerButtonSize = 48.0; // 전원 버튼 크기
  static const double iconButtonSize = 24.0; // 아이콘 버튼 크기
  static const double circleButtonSize = 60.0; // 원형 버튼 크기
  static const double bottomMainButtonSize = 54.0; // 하단 메인 버튼 크기

  // 자막 버튼 크기
  static const double subtitleButtonWidth = 135.0;
  static const double subtitleButtonHeight = 92.0;

  // 로커 크기
  static const double rockerWidth = 65.0;
  static const double rockerHeight = 210.0;

  // 패딩/마진
  static const double defaultPadding = 24.0; // 기본 패딩
  static const double smallPadding = 8.0; // 작은 패딩
  static const double mediumPadding = 10.0; // 중간 패딩
  static const double largePadding = 16.0; // 큰 패딩

  // 둥근 모서리
  static const double borderRadiusSmall = 7.0; // 작은 둥근 모서리
  static const double borderRadiusMedium = 10.0; // 중간 둥근 모서리
  static const double borderRadiusLarge = 13.0; // 큰 둥근 모서리
  static const double borderRadiusXLarge = 30.0; // 매우 큰 둥근 모서리
  static const double borderRadiusRocker = 80.0; // 로커 둥근 모서리

  // 아이콘/점 크기
  static const double menuDotSize = 3.0; // 메뉴 점 크기
  static const double menuDotSpacing = 3.0; // 메뉴 점 간격
  static const double circleIconSize = 8.0; // 원형 아이콘 크기

  // 터치 포인터
  static const double touchPointerSize = 16.0; // 터치 포인터 크기
  static const double touchPointerOffset = 8.0; // 터치 포인터 오프셋
  static const double touchPointerBorderWidth = 2.0; // 터치 포인터 테두리 두께

  // 스크롤바
  static const double scrollBarWidth = 14.0; // 스크롤바 너비
  static const double scrollBarPadding = 14.0; // 스크롤바 패딩
  static const double scrollHandleSize = 11.2; // 스크롤 핸들 크기
  static const double scrollHandleHeight = 14.0; // 스크롤 핸들 높이
  static const double scrollHandleInnerSize = 7.0; // 스크롤 핸들 내부 크기
  static const double scrollHandleDotSize = 2.1; // 스크롤 핸들 점 크기

  // 로커 아이콘 위치
  static const double rockerIconLeft = 20.5; // 로커 아이콘 왼쪽 위치
  static const double rockerIconTop = 17.0; // 로커 아이콘 상단 위치
  static const double rockerIconSize = 24.0; // 로커 아이콘 크기
}

/// 텍스트 스타일 상수
class _AppTextStyles {
  // 자막 버튼 텍스트 스타일
  static const TextStyle subtitleButton = TextStyle(
    color: _AppColors.primaryBlue,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontFamily: 'Pretendard',
    height: 1.19,
    decoration: TextDecoration.none, // 밑줄 제거
  );

  // 로커 라벨 텍스트 스타일
  static const TextStyle rockerLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: _AppColors.textDark,
    decoration: TextDecoration.none, // 밑줄 제거
  );
}

/// TV 화면 비율 상수
class _TVConstants {
  static const double contentWidth = 1780.0; // TV 콘텐츠 가로 크기
  static const double contentHeight = 1020.0; // TV 콘텐츠 세로 크기
  static const double scaleRatio = 0.3; // 터치패드 스케일 비율
}

// ============================================================================
// 🎨 스타일 헬퍼 함수
// ============================================================================

/// 자막 버튼 스타일 생성
BoxDecoration _buildSubtitleButtonDecoration() {
  return BoxDecoration(
    color: _AppColors.backgroundOffWhite,
    borderRadius: BorderRadius.circular(_AppSizes.borderRadiusLarge),
    border: Border.all(
      color: _AppColors.primaryBlue.withOpacity(0.6),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: _AppColors.primaryBlue.withOpacity(0.4),
        blurRadius: 7,
        spreadRadius: 1,
      ),
    ],
  );
}

/// 원형 버튼 스타일 생성
BoxDecoration _buildCircleButtonDecoration({Color? borderColor}) {
  return BoxDecoration(
    shape: BoxShape.circle,
    color: _AppColors.backgroundWhite,
    border: Border.all(color: borderColor ?? _AppColors.buttonBorderGray),
  );
}

/// 홈버튼
BoxDecoration _buildHomeButtonDecoration() {
  return BoxDecoration(
    shape: BoxShape.circle,
    color: _AppColors.backgroundWhite,
    border: Border.all(color: _AppColors.buttonBorderGray),
    boxShadow: [],
  );
}

/// 로커 스타일 생성
BoxDecoration _buildRockerDecoration() {
  return BoxDecoration(
    color: _AppColors.lightGray,
    borderRadius: BorderRadius.circular(_AppSizes.borderRadiusRocker),
    border: Border.all(color: _AppColors.borderGray),
  );
}

/// 터치 포인터 스타일 생성
BoxDecoration _buildTouchPointerDecoration() {
  return BoxDecoration(
    shape: BoxShape.circle,
    color: _AppColors.primaryBlue.withOpacity(0.8),
    border: Border.all(
      color: _AppColors.textWhite,
      width: _AppSizes.touchPointerBorderWidth,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 4,
        spreadRadius: 1,
      ),
    ],
  );
}

/// Figma 에서 선택한 리모컨 패드 영역 구현
class RemotePad extends StatefulWidget {
  const RemotePad({super.key});

  @override
  State<RemotePad> createState() => _RemotePadState();
}

class _RemotePadState extends State<RemotePad> {
  double _volume = 50.0; //음량 값(초기값 50)
  int _channel = 1; //현재 채널 번호 (초기 값 1)
  bool _isSubtitleModeOn = false; // ⚠️⚠️⚠️⚠️⚠️자막 모드 상태 (초기 값 꺼짐)
  bool _isTVOn = true; // TV 전원 상태
  bool _isQuickPanelOpen = false; // 퀵 패널 열림/닫힘 상태
  StreamSubscription<AccelerometerEvent>?
  _accelerometerSubscription; //흔들림 감지 리스너
  DateTime? _lastShakeTime;
  static const double _shakeThreshold = 10.0; // ⚠️⚠️⚠️⚠️⚠️얼마나 세게 흔들렸는지 감지
  static const Duration _shakeCooldown = Duration(
    milliseconds: 500,
  ); // 진동 간격 제한

  // ============================================================================
  /// ⭐️🚨⭐️🚨⭐️🚨TV를 끄는 기능 (나중에 구현 예정)⭐️🚨⭐️🚨⭐️🚨
  /// ============================================================================
  Future<void> _turnOffTV() async {
    // ⭐️🚨TODO: TV를 끄는 로직 구현
    // 예: API 호출, 블루투스 명령 전송 등
    setState(() {
      _isTVOn = false;
    });
  }

  void _handlePower() {
    if (_isTVOn) {
      // TV가 켜져 있으면 끄기
      _turnOffTV();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('TV를 끄는 중...')));
    } else {
      // ⭐️🚨 TV가 꺼져 있으면 켜기 (나중에 구현 가능)
      setState(() {
        _isTVOn = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('TV를 켜는 중...')));
    }
  }

  //점세개 메뉴 버튼 (나중에 메뉴 기능 추가 가능)
  void _handleMenu() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('메뉴 버튼을 눌렀습니다')));
  }

  //엑스 버튼, 홈 버튼 눌렀을 때 화면 전환 로직
  void _handleSquare() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 새 페이지: 왼쪽에서 오른쪽으로 슬라이드
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  //음량 조절
  void _handleVolumeUp() {
    setState(() {
      _volume = (_volume + 5).clamp(0, 100);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('음량: ${_volume.toInt()}%')));
  }

  void _handleVolumeDown() {
    setState(() {
      _volume = (_volume - 5).clamp(0, 100);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('음량: ${_volume.toInt()}%')));
  }

  // ============================================================================
  /// ⭐️🚨⭐️🚨⭐️🚨TV 채널 변경 시 화면 전환 로직 (나중에 구현 예정)⭐️🚨⭐️🚨⭐️🚨
  /// ============================================================================
  /// 채널 번호에 따라 TV 화면이 전환되는 기능
  Future<void> _changeTVChannel(int channelNumber) async {
    // TODO: TV와 연결하여 채널 변경 시 화면 전환 로직 구현
    // 예: API 호출, 블루투스 명령 전송 등
    // 채널 번호에 따라 TV 화면이 해당 채널의 콘텐츠로 전환됨
  }

  void _handleChannelUp() {
    setState(() {
      _channel++;
    });
    // ⭐️🚨채널 변경 시 TV 화면 전환 로직 호출
    _changeTVChannel(_channel);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('채널: $_channel')));
  }

  void _handleChannelDown() {
    setState(() {
      if (_channel > 1) _channel--;
    });
    // 채널 변경 시 TV 화면 전환 로직 호출
    _changeTVChannel(_channel);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('채널: $_channel')));
  }

  void _handleHome() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('음소거 버튼이 눌렸습니다.')));
  }

  // ============================================================================
  /// ⭐️🚨⭐️🚨⭐️🚨 핸드폰 흔들었을 때 진동 후 퀵패널 열리기 (나중에 구현 예정)⭐️🚨⭐️🚨⭐️🚨
  /// ============================================================================

  /// 퀵 패널을 여는 함수 (나중에 구현 예정)
  Future<void> _openQuickPanel() async {
    // ⭐️🚨 TODO: 퀵 패널을 여는 로직 구현
    // 예: BottomSheet, Dialog, 또는 커스텀 위젯 표시
    setState(() {
      _isQuickPanelOpen = true;
    });
  }

  /// 퀵 패널을 닫는 함수 (나중에 구현 예정)
  Future<void> _closeQuickPanel() async {
    // ⭐️🚨 TODO: 퀵 패널을 닫는 로직 구현
    setState(() {
      _isQuickPanelOpen = false;
    });
  }

  /// 퀵 패널을 토글하는 함수 (나중에 구현 예정)
  Future<void> _toggleQuickPanel() async {
    if (_isQuickPanelOpen) {
      await _closeQuickPanel();
    } else {
      await _openQuickPanel();
    }
  }

  void _handleHome() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('홈 버튼이 눌렀습니다.')));
  }

  void _handleTV() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('뒤로가기 버튼이 눌렀습니다.')));
  }

  // ============================================================================
  /// ⭐️🚨⭐️🚨⭐️🚨 TV 자막 켜기/끄기 로직 (나중에 구현 예정)⭐️🚨⭐️🚨⭐️🚨
  /// ============================================================================

  /// TV 자막을 켜는 함수 (나중에 구현 예정)
  Future<void> _turnOnTVSubtitle() async {
    // ⭐️🚨 TODO: TV와 연결하여 자막을 켜는 로직 구현
    // 예: API 호출, 블루투스 명령 전송 등
    // TV의 자막 기능이 활성화됨
  }

  /// TV 자막을 끄는 함수 (나중에 구현 예정)
  Future<void> _turnOffTVSubtitle() async {
    // ⭐️🚨 TODO: TV와 연결하여 자막을 끄는 로직 구현
    // 예: API 호출, 블루투스 명령 전송 등
    // TV의 자막 기능이 비활성화됨
  }

  void _handleSubtitleToggle() {
    setState(() {
      _isSubtitleModeOn = !_isSubtitleModeOn;
    });

    // TV 자막 켜기/끄기 로직 호출
    if (_isSubtitleModeOn) {
      _turnOnTVSubtitle();
    } else {
      _turnOffTVSubtitle();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSubtitleModeOn ? '자막 모드가 켜졌습니다' : '자막 모드가 꺼졌습니다'),
      ),
    );
  }

  // ============================================================================
  /// ⭐️🚨⭐️🚨⭐️🚨 터치 패드 좌표를 TV로 전송하는 로직 (나중에 구현 예정)⭐️🚨⭐️🚨⭐️🚨
  /// ============================================================================

  /// 터치 패드에서 받은 좌표를 TV로 전송하는 함수 (나중에 구현 예정)
  /// [x] x 좌표 (0.0 ~ 1.0 범위의 비율 값)
  /// [y] y 좌표 (0.0 ~ 1.0 범위의 비율 값)
  Future<void> _sendTouchPositionToTV(double x, double y) async {
    // ⭐️🚨 TODO: TV와 연결하여 터치 좌표를 전송하는 로직 구현
    // 예: API 호출, 블루투스 명령 전송 등
    //
    // 좌표 정보:
    // - x: 0.0 (왼쪽) ~ 1.0 (오른쪽)
    // - y: 0.0 (위쪽) ~ 1.0 (아래쪽)
    //
    // TV 화면 크기에 맞춰 실제 픽셀 좌표로 변환하여 전송
    // 예:
    //   final tvX = (x * tvScreenWidth).toInt();
    //   final tvY = (y * tvScreenHeight).toInt();
    //   await tvApi.sendPointerPosition(tvX, tvY);

    // 디버깅용: 현재 좌표 출력
    // print('터치 좌표 전송: x=$x, y=$y');
  }

  /// 터치 패드 위치 변경 핸들러
  void _handleTouchPadPositionChanged(double x, double y) {
    // 터치 좌표를 TV로 전송
    _sendTouchPositionToTV(x, y);
  }

  void _handleMicrophone() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('녹음'),
          content: const Text('녹음 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // TODO: 녹음 시작 로직 구현
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _handleShake(AccelerometerEvent event) {
    // 가속도 벡터의 크기 계산
    final acceleration =
        (event.x * event.x + event.y * event.y + event.z * event.z) /
        9.81 /
        9.81;

    // 흔들림 감지
    if (acceleration > _shakeThreshold) {
      final now = DateTime.now();

      // 마지막 진동 이후 일정 시간이 지났는지 확인 (너무 자주 진동하지 않도록)
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > _shakeCooldown) {
        _lastShakeTime = now;
        ShakeMode.vibrate(duration: 100);

        // ⭐️🚨⭐️🚨⭐️🚨TODO: 진동 후 퀵 패널 열기/닫기 로직 구현
        // ⭐️🚨⭐️🚨⭐️🚨흔들림 감지 시 진동 후 퀵 패널 토글
        // _toggleQuickPanel();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // 가속도계 센서 리스너 시작
    _accelerometerSubscription = accelerometerEventStream().listen(
      _handleShake,
    );
  }

  @override
  void dispose() {
    // 리스너 정리
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 크기에 따라 마진과 패딩 조정
        // 화면 크기에 따라 마진과 패딩 조정
        final isSmallScreen = constraints.maxHeight < 700;
        final margin = isSmallScreen ? 8.0 : 16.0;
        final verticalSpacing = isSmallScreen ? 16.0 : 24.0;

        return Container(
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            color: _AppColors.containerGray,
            borderRadius: BorderRadius.circular(_AppSizes.borderRadiusXLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: verticalSpacing),
              _TopBar(
                onPower: _handlePower,
                onMenu: _handleMenu,
                onSquare: _handleSquare,
              ),
              SizedBox(height: verticalSpacing),
              // 피그마 디자인에 맞춘 가로 배치: 음량 로커 | 중간 버튼들 | 채널 로커
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _AppSizes.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 왼쪽: 음량 로커
                    _VerticalRocker(
                      label: '음량',
                      icon: Icons.remove,
                      secondaryIcon: Icons.add,
                      onUp: _handleVolumeUp,
                      onDown: _handleVolumeDown,
                    ),
                    // 가운데: 세로로 배치된 버튼들 (홈, TV, 환경설정)
                    Column(
                      children: [
                        _CircleButton(
                          imagePath: 'assets/no_sound.png',
                          onTap: _handleHome,
                        ),
                        SizedBox(
                          height: isSmallScreen
                              ? _AppSizes.mediumPadding
                              : _AppSizes.largePadding,
                        ),
                        _CircleButton(
                          imagePath: 'assets/back_button.png',
                          onTap: _handleTV,
                        ),
                        SizedBox(
                          height: isSmallScreen
                              ? _AppSizes.mediumPadding
                              : _AppSizes.largePadding,
                        ),
                        _HomeButton(onTap: _handleHome),
                      ],
                    ),
                    // 오른쪽: 채널 로커
                    _VerticalRocker(
                      label: '채널',
                      icon: Icons.keyboard_arrow_up,
                      secondaryIcon: Icons.keyboard_arrow_down,
                      onUp: _handleChannelUp,
                      onDown: _handleChannelDown,
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 20.0 : 32.0),
              // 자막 모드 버튼들
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _AppSizes.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 자막 모드 켜기/끄기 버튼
                    GestureDetector(
                      onTap: _handleSubtitleToggle,
                      child: Container(
                        width: _AppSizes.subtitleButtonWidth,
                        height: _AppSizes.subtitleButtonHeight,
                        decoration: _buildSubtitleButtonDecoration(),
                        child: Center(
                          child: Text(
                            '자막 모드\n켜기/끄기',
                            style: _AppTextStyles.subtitleButton,
                          ),
                        ),
                      ),
                    ),
                    // 자막 세부 설정 버튼
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('자막 세부 설정 버튼을 눌렀습니다')),
                        );
                      },
                      child: Container(
                        width: _AppSizes.subtitleButtonWidth,
                        height: _AppSizes.subtitleButtonHeight,
                        decoration: _buildSubtitleButtonDecoration(),
                        child: Center(
                          child: Text(
                            '자막 모드\n세부 설정',
                            style: _AppTextStyles.subtitleButton,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 20.0 : 32.0),
              // 하단 터치 패드 영역
              TouchPad(onPositionChanged: _handleTouchPadPositionChanged),
              SizedBox(height: isSmallScreen ? 20.0 : 28.0),
              // 하단 녹음 아이콘
              _MicrophoneButton(onTap: _handleMicrophone),
              SizedBox(height: verticalSpacing),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onPower;
  final VoidCallback onMenu;
  final VoidCallback onSquare;

  const _TopBar({
    required this.onPower,
    required this.onMenu,
    required this.onSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _AppSizes.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 빨간 전원 버튼 (power.png 이미지 사용)
          GestureDetector(
            onTap: onPower,
            child: Container(
              width: _AppSizes.powerButtonSize,
              height: _AppSizes.powerButtonSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _AppColors.powerRed,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(_AppSizes.smallPadding),
                  child: Image.asset('assets/power.png', fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Row(
            children: [
              // 메뉴 버튼 (점 3개)
              GestureDetector(
                onTap: onMenu,
                child: SizedBox(
                  width: _AppSizes.iconButtonSize,
                  height: _AppSizes.iconButtonSize,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 메뉴 점 3개
                      Container(
                        width: _AppSizes.menuDotSize,
                        height: _AppSizes.menuDotSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _AppColors.mediumGray,
                        ),
                      ),
                      SizedBox(height: _AppSizes.menuDotSpacing),
                      Container(
                        width: _AppSizes.menuDotSize,
                        height: _AppSizes.menuDotSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _AppColors.mediumGray,
                        ),
                      ),
                      SizedBox(height: _AppSizes.menuDotSpacing),
                      Container(
                        width: _AppSizes.menuDotSize,
                        height: _AppSizes.menuDotSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: _AppSizes.largePadding),
              // 엑스 버튼 (아이콘 사용)
              GestureDetector(
                onTap: onSquare,
                child: SizedBox(
                  width: _AppSizes.iconButtonSize,
                  height: _AppSizes.iconButtonSize,
                  child: Icon(
                    Icons.close,
                    color: _AppColors.darkGray,
                    size: _AppSizes.iconButtonSize,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//로커 버튼
class _VerticalRocker extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData secondaryIcon;
  final VoidCallback onUp;
  final VoidCallback onDown;

  const _VerticalRocker({
    required this.label,
    required this.icon,
    required this.secondaryIcon,
    required this.onUp,
    required this.onDown,
  });

  @override
  Widget build(BuildContext context) {
    final isChannel = label == '채널';

    return Container(
      width: _AppSizes.rockerWidth,
      height: _AppSizes.rockerHeight,
      decoration: _buildRockerDecoration(),
      child: Stack(
        children: [
          // 위쪽 아이콘 버튼
          Positioned(
            left: _AppSizes.rockerIconLeft,
            top: _AppSizes.rockerIconTop,
            child: GestureDetector(
              onTap: onUp,
              child: SizedBox(
                width: _AppSizes.rockerIconSize,
                height: _AppSizes.rockerIconSize,
                child: CustomPaint(
                  painter: isChannel
                      ? _UpArrowIconPainter()
                      : _PlusIconPainter(),
                ),
              ),
            ),
          ),
          // 아래쪽 아이콘 버튼
          Positioned(
            left: _AppSizes.rockerIconLeft,
            bottom: _AppSizes.rockerIconTop,
            child: GestureDetector(
              onTap: onDown,
              child: SizedBox(
                width: _AppSizes.rockerIconSize,
                height: _AppSizes.rockerIconSize,
                child: CustomPaint(
                  painter: isChannel
                      ? _DownArrowIconPainter()
                      : _MinusIconPainter(),
                ),
              ),
            ),
          ),
          // 중앙 텍스트
          Center(child: Text(label, style: _AppTextStyles.rockerLabel)),
        ],
      ),
    );
  }
}

// + 아이콘 페인터
class _PlusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _AppColors.darkGray
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 가로선 (20px 길이)
    canvas.drawLine(
      Offset(centerX - 10, centerY),
      Offset(centerX + 10, centerY),
      paint,
    );

    // 세로선 (20px 높이)
    canvas.drawLine(
      Offset(centerX, centerY - 10),
      Offset(centerX, centerY + 10),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// - 아이콘 페인터
class _MinusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _AppColors.darkGray
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 가로선만 (20px 길이)
    canvas.drawLine(
      Offset(centerX - 10, centerY),
      Offset(centerX + 10, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 위 화살표 아이콘 페인터
class _UpArrowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _AppColors.darkGray
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 위쪽 화살표 (^)
    final path = Path();
    // 왼쪽 대각선
    path.moveTo(centerX - 7, centerY + 3);
    path.lineTo(centerX, centerY - 7);
    // 오른쪽 대각선
    path.lineTo(centerX + 7, centerY + 3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 아래 화살표 아이콘 페인터
class _DownArrowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _AppColors.darkGray
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 아래쪽 화살표 (v)
    final path = Path();
    // 왼쪽 대각선
    path.moveTo(centerX - 7, centerY - 3);
    path.lineTo(centerX, centerY + 7);
    // 오른쪽 대각선
    path.lineTo(centerX + 7, centerY - 3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircleButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onTap;

  const _CircleButton({this.icon, this.imagePath, required this.onTap})
    : assert(
        icon != null || imagePath != null,
        'icon or imagePath must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _AppSizes.circleButtonSize,
        height: _AppSizes.circleButtonSize,
        decoration: _buildCircleButtonDecoration(),
        child: imagePath != null
            ? Padding(
                padding: const EdgeInsets.all(_AppSizes.mediumPadding),
                child: Image.asset(imagePath!, fit: BoxFit.contain),
              )
            : Icon(icon, color: _AppColors.darkGray),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HomeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _AppSizes.circleButtonSize,
        height: _AppSizes.circleButtonSize,
        decoration: _buildHomeButtonDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_AppSizes.borderRadiusXLarge),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/home_button.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

//--------------------------------------------------------
///👉👉 터치 패드 영역 위젯
/// 터치/드래그 시 좌표를 0~1 비율로 변환하여 콜백으로 전달
class TouchPad extends StatefulWidget {
  final void Function(double x, double y)? onPositionChanged;
  const TouchPad({super.key, this.onPositionChanged});
  @override
  State<TouchPad> createState() => _TouchPadState();
}

class _TouchPadState extends State<TouchPad> {
  // TV 화면 비율에 맞춘 터치패드 크기 계산
  // final double padWidth = _TVConstants.contentWidth * _TVConstants.scaleRatio;
  // final double padHeight = _TVConstants.contentHeight * _TVConstants.scaleRatio;
  late double padWidth;
  late double padHeight;
  // 터치 포인터 관련
  Offset? _touchPointerPosition;
  Timer? _pointerTimer;

  void _updatePosition(Offset localPosition) {
    // 1) 패드 영역 안에서 값 제한
    final clampedX = localPosition.dx.clamp(0.0, padWidth);
    final clampedY = localPosition.dy.clamp(0.0, padHeight);

    // 2) 🔥 비율 값으로 변환 (0~1)
    final nx = (clampedX / padWidth).clamp(0.0, 1.0);
    final ny = (clampedY / padHeight).clamp(0.0, 1.0);

    // 3) 부모에게 비율 전달
    widget.onPositionChanged?.call(nx, ny);

    // 4) 화면에 보여줄 포인터는 "픽셀" 기준으로 유지
    setState(() {
      _touchPointerPosition = Offset(clampedX, clampedY);
    });

    // 5) 1초 후 포인터 사라지기
    _pointerTimer?.cancel();
    _pointerTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _touchPointerPosition = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _pointerTimer?.cancel();
    super.dispose();
  }

  //--------------------------------------------------------
  ///👉👉 터치 패드 크기
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1) 기본 TV 비율에 맞춘 크기
        final baseWidth = _TVConstants.contentWidth * _TVConstants.scaleRatio;
        final baseHeight = _TVConstants.contentHeight * _TVConstants.scaleRatio;
        final ratio = baseWidth / baseHeight;

        // 2) pad 크기 초기 설정
        padWidth = baseWidth;
        padHeight = baseHeight;

        // 3) 화면이 작으면 자동 축소
        if (padHeight > constraints.maxHeight * 0.35) {
          padHeight = constraints.maxHeight * 0.35;
          padWidth = padHeight * ratio;
        }

        // 4) 가로 폭을 넘으면 또 줄이기
        if (padWidth > constraints.maxWidth - _AppSizes.defaultPadding * 2) {
          padWidth = constraints.maxWidth - _AppSizes.defaultPadding * 2;
          padHeight = padWidth / ratio;
        }
        return Container(
          width: padWidth,
          height: padHeight,
          margin: const EdgeInsets.symmetric(
            horizontal: _AppSizes.defaultPadding,
          ),
          decoration: BoxDecoration(
            color: _AppColors.touchPadGray,
            borderRadius: BorderRadius.circular(_AppSizes.borderRadiusMedium),
          ),
          child: Stack(
            children: [
              GestureDetector(
                onPanDown: (details) => _updatePosition(details.localPosition),
                onPanUpdate: (details) =>
                    _updatePosition(details.localPosition),
                behavior: HitTestBehavior.opaque,
                child: Stack(children: [_buildScrollBar()]),
              ),
              // 터치 포인터 표시
              if (_touchPointerPosition != null)
                Positioned(
                  left:
                      _touchPointerPosition!.dx - _AppSizes.touchPointerOffset,
                  top: _touchPointerPosition!.dy - _AppSizes.touchPointerOffset,
                  child: Container(
                    width: _AppSizes.touchPointerSize,
                    height: _AppSizes.touchPointerSize,
                    decoration: _buildTouchPointerDecoration(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // _buildScrollBar()는 기존 그대로 유지
}

/// 스크롤바 UI 빌드
Widget _buildScrollBar() {
  return Positioned(
    right: _AppSizes.scrollBarPadding,
    top: _AppSizes.scrollBarPadding,
    bottom: _AppSizes.scrollBarPadding,
    child: Container(
      width: _AppSizes.scrollBarWidth,
      decoration: BoxDecoration(
        color: _AppColors.scrollBarGray,
        borderRadius: BorderRadius.circular(_AppSizes.borderRadiusSmall),
      ),
      child: Stack(
        children: [
          // 스크롤바 상단 핸들
          _buildScrollHandle(isTop: true),
          // 스크롤바 하단 핸들
          _buildScrollHandle(isTop: false),
        ],
      ),
    ),
  );
}

/// 스크롤 핸들 UI 빌드
Widget _buildScrollHandle({required bool isTop}) {
  return Positioned(
    top: isTop ? 0 : null,
    bottom: isTop ? null : 0,
    left: 0,
    right: 0,
    child: Container(
      height: _AppSizes.scrollHandleHeight,
      decoration: BoxDecoration(
        color: _AppColors.scrollBarGray,
        borderRadius: isTop
            ? const BorderRadius.only(
                topLeft: Radius.circular(_AppSizes.borderRadiusSmall),
                topRight: Radius.circular(_AppSizes.borderRadiusSmall),
              )
            : const BorderRadius.only(
                bottomLeft: Radius.circular(_AppSizes.borderRadiusSmall),
                bottomRight: Radius.circular(_AppSizes.borderRadiusSmall),
              ),
      ),
      child: Center(
        child: Container(
          width: _AppSizes.scrollHandleSize,
          height: _AppSizes.scrollHandleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _AppColors.darkGray, width: 1),
          ),
          child: Stack(
            children: [
              // 외부 원
              Center(
                child: Container(
                  width: _AppSizes.scrollHandleInnerSize,
                  height: _AppSizes.scrollHandleInnerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _AppColors.darkGray, width: 1),
                  ),
                ),
              ),
              // 중앙 점
              Center(
                child: Container(
                  width: _AppSizes.scrollHandleDotSize,
                  height: _AppSizes.scrollHandleDotSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _AppColors.darkGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _BottomIconButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onTap;
  final bool isCircle;

  const _BottomIconButton({
    this.icon,
    this.imagePath,
    required this.onTap,
    this.isCircle = false,
  }) : assert(
         icon != null || imagePath != null || isCircle,
         'icon, imagePath, or isCircle must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _AppSizes.circleButtonSize,
        height: _AppSizes.circleButtonSize,
        decoration: _buildCircleButtonDecoration(),
        child: isCircle
            ? Center(
                child: Container(
                  width: _AppSizes.circleIconSize,
                  height: _AppSizes.circleIconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _AppColors.darkGray),
                  ),
                ),
              )
            : imagePath != null
            ? Padding(
                padding: EdgeInsets.all(
                  imagePath == 'assets/환경설정.png'
                      ? _AppSizes.largePadding
                      : _AppSizes.mediumPadding,
                ),
                child: Image.asset(imagePath!, fit: BoxFit.contain),
              )
            : Icon(icon, color: _AppColors.darkGray),
      ),
    );
  }
}

//아래 음성 아이콘
class _MicrophoneButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MicrophoneButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: _AppSizes.bottomMainButtonSize,
          height: _AppSizes.bottomMainButtonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _AppColors.bottomButtonGray,
            border: Border.all(color: _AppColors.bottomButtonBorderGray),
          ),
          child: Padding(
            padding: const EdgeInsets.all(_AppSizes.mediumPadding),
            child: Image.asset('assets/마이크.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
