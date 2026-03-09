import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Models/Server.dart';
import '../Utils/Global.dart';
import '../Utils/Theme.dart';

class Home extends StatefulWidget {
  final ServerModel selectedServer;
  final VoidCallback onTapLocation;
  final VoidCallback onTapPremium;

  const Home(
      {super.key, required this.selectedServer, required this.onTapLocation, required this.onTapPremium});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;
  Timer? _graphTimer;
  //bool isConnectedGlobal = false;
  Duration _duration = Duration.zero;
  List<double> _downloadBars = List.generate(15, (index) => 0.1);
  List<double> _uploadBars = List.generate(15, (index) => 0.1);
  double _currentDownload = 0.0;
  double _currentUpload = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (isConnectedGlobal) {
      _toggleConnection2();
    }
  }

  void _toggleConnection2() {
    setState(() {
      if (isConnectedGlobal) {
        _pulseController.repeat();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            duration += const Duration(seconds: 1);
          });
        });
        _graphTimer =
            Timer.periodic(const Duration(milliseconds: 800), (timer) {
          setState(() {
            _currentDownload = 20 + Random().nextDouble() * 40;
            _currentUpload = 10 + Random().nextDouble() * 30;
            _downloadBars = List.generate(15, (index) => Random().nextDouble());
            _uploadBars = List.generate(15, (index) => Random().nextDouble());
          });
        });
      } else {
        _pulseController.stop();
        _pulseController.reset();
        _timer?.cancel();
        _graphTimer?.cancel();
        duration = Duration.zero;
        _currentDownload = 0.0;
        _currentUpload = 0.0;
        _downloadBars = List.generate(15, (index) => 0.1);
        _uploadBars = List.generate(15, (index) => 0.1);
      }
    });
  }

  void _toggleConnection() {
    setState(() {
      isConnectedGlobal = !isConnectedGlobal;

      if (isConnectedGlobal) {
        _pulseController.repeat();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            duration += const Duration(seconds: 1);
          });
        });
        _graphTimer =
            Timer.periodic(const Duration(milliseconds: 800), (timer) {
          setState(() {
            _currentDownload = 20 + Random().nextDouble() * 40;
            _currentUpload = 10 + Random().nextDouble() * 30;
            _downloadBars = List.generate(15, (index) => Random().nextDouble());
            _uploadBars = List.generate(15, (index) => Random().nextDouble());
          });
        });
      } else {
        _pulseController.stop();
        _pulseController.reset();
        _timer?.cancel();
        _graphTimer?.cancel();
        duration = Duration.zero;
        _currentDownload = 0.0;
        _currentUpload = 0.0;
        _downloadBars = List.generate(15, (index) => 0.1);
        _uploadBars = List.generate(15, (index) => 0.1);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    _graphTimer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String mm = twoDigits(duration.inMinutes.remainder(60));
    String ss = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}.$mm.$ss";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          isConnectedGlobal = false;
        });
        return Future.value(true); 
      },
      child: Scaffold(
        backgroundColor: PRIMARYCOLOR,
        body: Stack(
          children: [
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 100,
              child: Opacity(
                opacity: 0.20,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.2, 0.8, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    'assets/images/monde2.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  Text(
                    isConnectedGlobal ? 'Secure connection' : 'Not Connected',
                    style: TextStyle(
                        color:
                            isConnectedGlobal ? Colors.greenAccent : Colors.grey,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formatDuration(duration),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: widget.onTapLocation,
                    child: _buildLocationDropdown(),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleConnection,
                    child: _buildPulseButton(),
                  ),
                  const Spacer(),
                  Text(
                    isConnectedGlobal ? '' : 'Tap to Connect',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  _buildBottomStats(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (isConnectedGlobal)
              SizedBox(
                width: 280,
                height: 280,
                child:
                    CustomPaint(painter: PulsePainter(_pulseController.value)),
              ),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF14192B),
                boxShadow: [
                  BoxShadow(
                    color: isConnectedGlobal
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(
                  color: isConnectedGlobal
                      ? Colors.blueAccent
                      : const Color(0xFF1E2640),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.power_settings_new,
                  color: isConnectedGlobal ? Colors.blueAccent : Colors.white,
                  size: 50,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFF151D33),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(selectedServerGlobal.flagEmoji,
            style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(selectedServerGlobal.country,
            style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
      ]),
    );
  }

  Widget _buildBottomStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatColumn('DOWNLOAD', _currentDownload.toStringAsFixed(1),
              'MB/s', true, _downloadBars),
          _buildStatColumn('UPLOAD', _currentUpload.toStringAsFixed(1), 'MB/s',
              false, _uploadBars),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return InkWell(
      onTap: widget.onTapPremium,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.menu, color: Colors.white),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(Icons.workspace_premium, color: Colors.black, size: 16),
                  SizedBox(width: 4),
                  Text('Premium',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.support_agent, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String unit,
      bool isDownload, List<double> bars) {
    Color graphColor =
        isDownload ? const Color(0xFF00FF7F) : const Color(0xFFFFD700);
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: isDownload ? 8 : 0, left: isDownload ? 0 : 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A223B)
              .withOpacity(0.1), 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF2B3A6B).withOpacity(0.5),
            width: 1,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color(0xFF1E2640).withOpacity(0.8),
          //     blurRadius: 10,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                isDownload
                    ? Icon(Icons.arrow_drop_down, color: Colors.grey)
                    : Icon(Icons.arrow_drop_up, color: Colors.grey)
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text(unit,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 15,
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: bars
                    .map((val) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 3,
                          height: 15 * val.clamp(0.2, 1.0),
                          decoration: BoxDecoration(
                              color: graphColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(2)),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PulsePainter extends CustomPainter {
  final double animationValue;
  PulsePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    _drawWave(canvas, center, maxRadius, animationValue);
    _drawWave(canvas, center, maxRadius, (animationValue + 0.33) % 1.0);
    _drawWave(canvas, center, maxRadius, (animationValue + 0.66) % 1.0);
    _drawDashedCircle(canvas, center, 80);
  }

  void _drawWave(Canvas canvas, Offset center, double maxRadius, double value) {
    final paint = Paint()
      ..color = const Color(0xFF2B3A6B).withOpacity((1 - value) * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, 60 + (maxRadius - 60) * value, paint);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = const Color(0xFF2B3A6B).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    for (int i = 0; i < 60; i++) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          i * (2 * pi / 60), (2 * pi / 120), false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PulsePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class CustomEarthClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.3, 0, // Sommet arrondi
      size.width, size.height * 0.2, // Fin courbe haut droite
    );

    path.lineTo(size.width, size.height); // Bas droite
    path.lineTo(0, size.height); // Bas gauche
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomEarthClipper oldClipper) => false;
}
