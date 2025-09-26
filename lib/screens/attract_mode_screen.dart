import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'kiosk_home_screen.dart';

class AttractModeScreen extends StatefulWidget {
  const AttractModeScreen({super.key});

  @override
  State<AttractModeScreen> createState() => _AttractModeScreenState();
}

class _AttractModeScreenState extends State<AttractModeScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late Timer _slideTimer;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  int _currentSlide = 0;
  final List<AttractSlide> _slides = [
    AttractSlide(
      title: "AI Photobooth Experience",
      subtitle: "Professional AI-powered portraits in seconds",
      description: "Transform your look with cutting-edge AI technology. Get stunning professional photos instantly!",
      imagePath: "assets/images/photobooth.png",
      color: Color(0xFF00004c),
    ),
    AttractSlide(
      title: "AI Health Consultation",
      subtitle: "Instant health insights powered by AI",
      description: "Get personalized health recommendations and wellness insights from advanced AI analysis.",
      imagePath: "assets/images/qhealth.png",
      color: Color(0xFF0074a8),
    ),
    AttractSlide(
      title: "AI Consultation Avatar",
      subtitle: "Talk to our interactive AI avatar",
      description: "Have a conversation with our AI-powered avatar for instant assistance and consultation.",
      imagePath: "assets/images/qbavatar.png",
      color: Color(0xFF4C0074),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _floatAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
    _startSlideTimer();
  }

  void _startSlideTimer() {
    _slideTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_currentSlide < _slides.length - 1) {
        _currentSlide++;
      } else {
        _currentSlide = 0;
      }

      _pageController.animateToPage(
        _currentSlide,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _navigateToKiosk() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const KioskHomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  void dispose() {
    _slideTimer.cancel();
    _pageController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: _navigateToKiosk,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentSlide = index;
                });
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return _buildSlide(_slides[index], screenSize);
              },
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: _buildPageIndicators(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildTouchToOrderFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(AttractSlide slide, Size screenSize) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              slide.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        slide.color,
                        slide.color.withValues(alpha: 0.8),
                        slide.color.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      slide.color.withValues(alpha: 0.7),
                      slide.color.withValues(alpha: 0.5),
                      slide.color.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: CirclePatternPainter(
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatAnimation.value * 0.5),
                            child: Text(
                              slide.title,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -2,
                                height: 0.9,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatAnimation.value * 0.3),
                            child: Text(
                              slide.subtitle,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.025,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_floatAnimation.value * 0.2),
                            child: Text(
                              slide.description,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.018,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      _buildFeatureHighlights(slide.color),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildMediaDisplay(slide),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaDisplay(AttractSlide slide) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Container(
            margin: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                slide.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          slide.color,
                          slide.color.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.white54,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureHighlights(Color themeColor) {
    final features = ['AI-Powered', 'Easy to Use'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                feature,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_slides.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentSlide == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentSlide == index
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildTouchToOrderFooter() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app,
                      color: Color(0xFF00004c),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'TOUCH TO ORDER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00004c),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AttractSlide {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color color;

  AttractSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}

class CirclePatternPainter extends CustomPainter {
  final Color color;

  CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        canvas.drawCircle(
          Offset(i * 100.0, j * 100.0),
          20,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}