import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../home/home_page.dart';
import 'shake_mode.dart';

/// Figma 에서 선택한 리모컨 패드 영역 구현
class RemotePad extends StatefulWidget {
  const RemotePad({super.key});

  @override
  State<RemotePad> createState() => _RemotePadState();
}

class _RemotePadState extends State<RemotePad> {
  double _volume = 50.0;
  int _channel = 1;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  static const double _shakeThreshold = 12.0; // 흔들림 감지 임계값
  static const Duration _shakeCooldown = Duration(
    milliseconds: 500,
  ); // 진동 간격 제한

  // 터치 포인터 관련
  Offset? _touchPointerPosition;
  Timer? _pointerTimer;

  void _handlePower() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('전원 버튼을 눌렀습니다')));
  }

  void _handleMenu() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('메뉴 버튼을 눌렀습니다')));
  }

  void _handleSquare() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

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

  void _handleChannelUp() {
    setState(() {
      _channel++;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('채널: $_channel')));
  }

  void _handleChannelDown() {
    setState(() {
      if (_channel > 1) _channel--;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('채널: $_channel')));
  }

  void _handleHome() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('음소거 버튼이 눌렸습니다.')));
  }

  void _handleSettings() async {
    // 진동 기능 실행
    // await ShakeMode.vibrate();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('홈 버튼이 눌렀습니다.')));
  }

  void _handleTV() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('뒤로가기 버튼이 눌렀습니다.')));
  }

  void _handleCircle() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('원형 버튼을 눌렀습니다')));
  }

  void _handleOK() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('확인 버튼을 눌렀습니다')));
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

  void _handlePointerTap(TapDownDetails details) {
    // 터치 위치 저장 (Stack의 좌표계 기준)
    setState(() {
      _touchPointerPosition = details.localPosition;
    });

    // 1초 후 포인터 제거
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
    // 리스너 정리
    _accelerometerSubscription?.cancel();
    _pointerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 크기에 따라 마진과 패딩 조정
        final isSmallScreen = constraints.maxHeight < 700;
        final margin = isSmallScreen ? 8.0 : 16.0;
        final verticalSpacing = isSmallScreen ? 16.0 : 24.0;

        return Stack(
          children: [
            GestureDetector(
              onTapDown: _handlePointerTap,
              behavior: HitTestBehavior.translucent,
              child: Container(
                margin: EdgeInsets.all(margin),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1F5),
                  borderRadius: BorderRadius.circular(30),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                              _CircleButton(
                                imagePath: 'assets/back_button.png',
                                onTap: _handleTV,
                              ),
                              SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                              _SettingsButton(onTap: _handleSettings),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 자막 모드 켜기/끄기 버튼
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('자막 모드 켜기/끄기 버튼을 눌렀습니다'),
                                ),
                              );
                            },
                            child: Container(
                              width: 140,
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDFDFD),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: const Color(
                                    0xFF3A7BFF,
                                  ).withOpacity(0.6),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '자막 모드 켜기/끄기',
                                  style: TextStyle(
                                    color: const Color(0xFF3A7BFF),
                                    fontSize: 15.17,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Pretendard',
                                    height: 1.19,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // 자막 세부 설정 버튼
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('자막 세부 설정 버튼을 눌렀습니다'),
                                ),
                              );
                            },
                            child: Container(
                              width: 140,
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDFDFD),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: const Color(
                                    0xFF3A7BFF,
                                  ).withOpacity(0.6),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '자막 세부 설정',
                                  style: TextStyle(
                                    color: const Color(0xFF3A7BFF),
                                    fontSize: 15.17,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Pretendard',
                                    height: 1.19,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20.0 : 32.0),
                    // 하단 스크롤 영역
                    _ScrollArea(),
                    SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                    // 하단 큰 원형 버튼 (확인)
                    _BottomMainButton(onTap: _handleOK),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
            // 터치 포인터 표시
            if (_touchPointerPosition != null)
              Positioned(
                left: _touchPointerPosition!.dx - 8,
                top: _touchPointerPosition!.dy - 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3A7BFF).withOpacity(0.8),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 빨간 전원 버튼 (power.png 이미지 사용)
          GestureDetector(
            onTap: onPower,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE5574E),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                child: Container(
                  width: 24,
                  height: 24,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF636468),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF636468),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF636468),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 사각형 버튼 (quit.png 이미지 사용)
              GestureDetector(
                onTap: onSquare,
                child: Container(
                  width: 24,
                  height: 24,
                  child: Image.asset('assets/quit.png', fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
      width: 65,
      height: 210,
      decoration: BoxDecoration(
        color: const Color(0xFFD1D3D7),
        borderRadius: BorderRadius.circular(80),
        border: Border.all(color: const Color(0xFFC2C4C8)),
      ),
      child: Stack(
        children: [
          // 위쪽 아이콘 버튼
          Positioned(
            left: 20.5,
            top: 17,
            child: GestureDetector(
              onTap: onUp,
              child: SizedBox(
                width: 24,
                height: 24,
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
            left: 20.5,
            bottom: 17,
            child: GestureDetector(
              onTap: onDown,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CustomPaint(
                  painter: isChannel
                      ? _DownArrowIconPainter()
                      : _MinusIconPainter(),
                ),
              ),
            ),
          ),
          // 중앙 텍스트
          Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F1014),
              ),
            ),
          ),
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
      ..color = const Color(0xFF6B6C70)
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
      ..color = const Color(0xFF6B6C70)
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
      ..color = const Color(0xFF6B6C70)
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
      ..color = const Color(0xFF6B6C70)
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
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDADDE0)),
        ),
        child: imagePath != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(imagePath!, fit: BoxFit.contain),
              )
            : Icon(icon, color: const Color(0xFF6D6F71)),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SettingsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFF3A7BFF), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A7BFF).withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/home_button.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

class _ScrollArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E2E6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // 스크롤바
          Positioned(
            right: 14,
            top: 14,
            bottom: 14,
            child: Container(
              width: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFC9D0DB),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Stack(
                children: [
                  // 스크롤바 상단 핸들
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9D0DB),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 11.2,
                          height: 11.2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6D6F71),
                              width: 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF6D6F71),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 2.1,
                                  height: 2.1,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF6D6F71),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 스크롤바 하단 핸들
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9D0DB),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 11.2,
                          height: 11.2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6D6F71),
                              width: 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF6D6F71),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 2.1,
                                  height: 2.1,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF6D6F71),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDADDE0)),
        ),
        child: isCircle
            ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF6D6F71)),
                  ),
                ),
              )
            : imagePath != null
            ? Padding(
                padding: EdgeInsets.all(
                  imagePath == 'assets/환경설정.png' ? 16.0 : 12.0,
                ),
                child: Image.asset(imagePath!, fit: BoxFit.contain),
              )
            : Icon(icon, color: const Color(0xFF6D6F71)),
      ),
    );
  }
}

class _BottomMainButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BottomMainButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD3D2D7),
            border: Border.all(color: const Color(0xFFC0BFC4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/마이크.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
