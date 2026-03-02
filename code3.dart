import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VPN Home Screen',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0B1021),
        fontFamily: 'Roboto', 
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Timer _timer;
  Duration _duration = const Duration(minutes: 34, seconds: 37); // Départ comme sur l'image

  // Timer pour simuler l'animation des petits graphiques en bas
  late Timer _graphTimer;
  List<double> _downloadBars = List.generate(15, (index) => Random().nextDouble());
  List<double> _uploadBars = List.generate(15, (index) => Random().nextDouble());

  @override
  void initState() {
    super.initState();

    // 1. Animation de pulsation (répétée en boucle)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // 2. Chronomètre
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });

    // 3. Animation des graphiques (mise à jour aléatoire toutes les 500ms)
    _graphTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _downloadBars = List.generate(15, (index) => Random().nextDouble());
        _uploadBars = List.generate(15, (index) => Random().nextDouble());
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer.cancel();
    _graphTimer.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}.$twoDigitMinutes.$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 20),
            _buildConnectionStatus(),
            const SizedBox(height: 10),
            Text(
              formatDuration(_duration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            _buildLocationDropdown(),
            const Spacer(),
            _buildPulseButton(),
            const Spacer(),
            const Text(
              'Tap to Connect',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 30),
            _buildBottomStats(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- WIDGETS ---

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: Colors.white),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700), // Jaune premium
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.workspace_premium, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Text(
                  'Premium',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(Icons.support_agent, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return const Text(
      'Secure connection',
      style: TextStyle(color: Colors.grey, fontSize: 14),
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF151D33),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('🇺🇸', style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Text('United States', style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
        ],
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
            // Effet de radar en arrière-plan
            SizedBox(
              width: 320,
              height: 320,
              child: CustomPaint(
                painter: PulsePainter(_pulseController.value),
              ),
            ),
            // Bouton central sombre avec effet Neumorphique inversé
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF14192B), // Couleur sombre centrale
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: const Color(0xFF2B3A6B).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: -2,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border.all(color: const Color(0xFF1E2640), width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatColumn('DOWNLOAD', '36.5', 'MB/s', true, _downloadBars),
          _buildStatColumn('UPLOAD', '36.5', 'MB/s', false, _uploadBars),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String unit, bool isDownload, List<double> bars) {
    Color graphColor = isDownload ? const Color(0xFF00FF7F) : const Color(0xFFFFD700);
    IconData icon = isDownload ? Icons.keyboard_double_arrow_down : Icons.keyboard_double_arrow_up;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Icon(icon, color: Colors.grey, size: 12),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              unit,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Mini graphique animé
        SizedBox(
          height: 15,
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: bars.map((val) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 3,
                height: 15 * val.clamp(0.2, 1.0), // Hauteur minimale de 20%
                decoration: BoxDecoration(
                  color: graphColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF0B1021),
        border: Border(top: BorderSide(color: Color(0xFF1E2640), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, 'Home', true), // Home est actif ici
          _navItem(Icons.public, 'Server', false),
          // Bouton central flottant
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1A4CFF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A4CFF).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const Icon(Icons.power_settings_new, color: Colors.white, size: 28),
          ),
          _navItem(Icons.workspace_premium_outlined, 'Premium', false),
          _navItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? Colors.blueAccent : Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blueAccent : Colors.grey,
            fontSize: 10,
          ),
        )
      ],
    );
  }
}

// --- LOGIQUE DE L'ANIMATION RADAR ---

class PulsePainter extends CustomPainter {
  final double animationValue;

  PulsePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Dessiner 3 vagues concentriques décalées dans le temps
    _drawWave(canvas, center, maxRadius, animationValue);
    _drawWave(canvas, center, maxRadius, (animationValue + 0.33) % 1.0);
    _drawWave(canvas, center, maxRadius, (animationValue + 0.66) % 1.0);

    // Cercle intérieur avec les traits (Dashboard-like)
    _drawDashedCircle(canvas, center, 80);
  }

  void _drawWave(Canvas canvas, Offset center, double maxRadius, double value) {
    final paint = Paint()
      ..color = const Color(0xFF2B3A6B).withOpacity((1 - value) * 0.5) // Fading au fur et à mesure
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final radius = 60 + (maxRadius - 60) * value; // Commence après le bouton central
    canvas.drawCircle(center, radius, paint);
  }

  // Permet de dessiner le cercle interne en pointillés/tirets typique de l'image
  void _drawDashedCircle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = const Color(0xFF2B3A6B).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const int dashCount = 60;
    const double dashLength = 4.0;
    const double dashSpace = 4.0;
    final double circumference = 2 * pi * radius;
    final double dashAngle = (dashLength / circumference) * 2 * pi;
    final double spaceAngle = (dashSpace / circumference) * 2 * pi;

    double currentAngle = 0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        dashAngle,
        false,
        paint,
      );
      currentAngle += dashAngle + spaceAngle;
    }
  }

  @override
  bool shouldRepaint(covariant PulsePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
