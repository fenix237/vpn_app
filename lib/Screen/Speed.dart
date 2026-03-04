import 'dart:math';
import 'package:flutter/material.dart';

import '../Utils/Global.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late double targetUploadMain;
  late double targetDownload;
  late double targetPing;
  late double targetUploadStat;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _generateRandomTargets(); 
    _animationController.forward();
  }

  void _generateRandomTargets() {
    final random = Random();
    targetUploadMain = random.nextDouble() * 75; 
    targetDownload = random.nextDouble() * 100;
    targetPing = 10 + random.nextDouble() * 190; 
    targetUploadStat = random.nextDouble() * 100;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 10),
              _buildNetworkInfoBars(),
              const Spacer(),
              _buildSpeedometer(),
              const Spacer(),
              _buildStatsRow(),
              const SizedBox(height: 30),
              _buildRequestButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2640),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 16),
          ),
          const Text(
            'Speed Test',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2640),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkInfoBars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoChip(Icons.bar_chart, 'Ping-165ms'),
          _infoChip(null,"${selectedServerGlobal.flagEmoji} ${selectedServerGlobal.country}", isCenter: true),
          _infoChip(Icons.wifi_tethering, 'Jitter-165ms'),
        ],
      ),
    );
  }

  Widget _infoChip(IconData? icon, String text, {bool isCenter = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF151D33),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: isCenter ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: isCenter ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedometer() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = _animation.value * targetUploadMain;
        
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(
                painter: SpeedometerPainter(
                  currentValue: currentValue,
                  maxValue: 1000, 
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Uploading',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  currentValue.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Mbps',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentDownload = (_animation.value * targetDownload).toStringAsFixed(1);
        final currentPing = (_animation.value * targetPing).toStringAsFixed(1);
        final currentUpload = (_animation.value * targetUploadStat).toStringAsFixed(1);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('Download', '$currentDownload Mbps', false),
              _statItem('Ping', '$currentPing ms', false),
              _statItem('Upload', '$currentUpload Mbps', true),
            ],
          ),
        );
      },
    );
  }

  Widget _statItem(String label, String value, bool isHighlight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isHighlight)
              const Icon(Icons.arrow_upward, color: Colors.grey, size: 14),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            _generateRandomTargets();
          });
          _animationController.reset();
          _animationController.forward();
        },
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2B58), Color(0xFF0F172A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: const Color(0xFF2B3A6B), width: 1),
          ),
          child: const Center(
            child: Text(
              'Request Connection',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double currentValue;
  final double maxValue;

  SpeedometerPainter({required this.currentValue, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    const startAngle = 135 * pi / 180; 
    const sweepAngle = 270 * pi / 180; 

    final backgroundPaint = Paint()
      ..color = const Color(0xFF1A223B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 30),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    final tickPaint = Paint()
      ..color = const Color(0xFF2B3A6B)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const totalTicks = 40;
    for (int i = 0; i <= totalTicks; i++) {
      final angle = startAngle + (i / totalTicks) * sweepAngle;
      final start = Offset(
        center.dx + cos(angle) * (radius - 10),
        center.dy + sin(angle) * (radius - 10),
      );
      final end = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      canvas.drawLine(start, end, tickPaint);
    }

    double progressRatio = (currentValue / 100)
        .clamp(0.0, 1.0); 
    double progressAngle = sweepAngle * progressRatio;

    final progressPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [Color(0xFF00B4DB), Color(0xFF0083B0), Color(0xFF1A4CFF)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius - 30))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFF1A4CFF).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    if (progressAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 30),
        startAngle,
        progressAngle,
        false,
        glowPaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 30),
        startAngle,
        progressAngle,
        false,
        progressPaint,
      );
    }

    _drawTextAtAngle(canvas, center, radius, startAngle, "0");
    _drawTextAtAngle(
        canvas, center, radius, startAngle + sweepAngle * 0.15, "20");
    _drawTextAtAngle(
        canvas, center, radius, startAngle + sweepAngle * 0.35, "50");
    _drawTextAtAngle(
        canvas, center, radius, startAngle + sweepAngle * 0.5, "100");
    _drawTextAtAngle(
        canvas, center, radius, startAngle + sweepAngle * 0.7, "200");
    _drawTextAtAngle(
        canvas, center, radius, startAngle + sweepAngle * 0.85, "500");
    _drawTextAtAngle(canvas, center, radius, startAngle + sweepAngle, "1g");
  }

  void _drawTextAtAngle(
      Canvas canvas, Offset center, double radius, double angle, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offset = Offset(
      center.dx + cos(angle) * (radius - 60) - (textPainter.width / 2),
      center.dy + sin(angle) * (radius - 60) - (textPainter.height / 2),
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.currentValue != currentValue;
  }
}