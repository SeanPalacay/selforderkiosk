import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/idle_timer.dart';

class IdleStatusIndicator extends StatefulWidget {
  final Duration idleTimeout;
  final Duration warningDuration;
  final VoidCallback? onReset;

  const IdleStatusIndicator({
    super.key,
    this.idleTimeout = const Duration(minutes: 2),
    this.warningDuration = const Duration(seconds: 30),
    this.onReset,
  });

  @override
  State<IdleStatusIndicator> createState() => _IdleStatusIndicatorState();
}

class _IdleStatusIndicatorState extends State<IdleStatusIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  final SessionTimeoutNotifier _timeoutNotifier = SessionTimeoutNotifier();
  bool _isWarning = false;
  double _progress = 0.0;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // No need for explicit listener since we use AnimatedBuilder
  }

  void resetProgress() {
    widget.onReset?.call();
    // The reset is now handled by the SessionTimeoutNotifier
    // No need to manually control animations here
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: 24,
      right: 24,
      child: GestureDetector(
        onTap: resetProgress,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _glowAnimation, _timeoutNotifier]),
          builder: (context, child) {
            // Update state from notifier
            _progress = _timeoutNotifier.progress;
            final newIsWarning = _timeoutNotifier.isWarning;
            _secondsRemaining = _timeoutNotifier.secondsRemaining;

            // Handle animation state changes
            if (newIsWarning != _isWarning) {
              _isWarning = newIsWarning;
              if (_isWarning && !_pulseController.isAnimating) {
                _pulseController.repeat(reverse: true);
                _glowController.repeat(reverse: true);
              } else if (!_isWarning && _pulseController.isAnimating) {
                _pulseController.stop();
                _glowController.stop();
              }
            }
            return Transform.scale(
              scale: _isWarning ? _pulseAnimation.value : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow effect when warning
                  if (_isWarning)
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(44),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B6B).withValues(alpha: 0.4 * _glowAnimation.value),
                            blurRadius: 20 + (10 * _glowAnimation.value),
                            spreadRadius: 2 + (4 * _glowAnimation.value),
                          ),
                        ],
                      ),
                    ),

                  // Main container with glassmorphism effect
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.95),
                          Colors.white.withValues(alpha: 0.85),
                        ],
                      ),
                      border: Border.all(
                        color: _isWarning
                            ? const Color(0xFFFF6B6B).withValues(alpha: 0.3)
                            : colorScheme.outline.withValues(alpha: 0.15),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Progress ring with enhanced styling
                        Center(
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: CustomPaint(
                              painter: _ProgressRingPainter(
                                progress: _progress,
                                isWarning: _isWarning,
                                primaryColor: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),

                        // Center icon with subtle background
                        Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: _isWarning
                                  ? const Color(0xFFFF6B6B).withValues(alpha: 0.1)
                                  : colorScheme.primary.withValues(alpha: 0.1),
                            ),
                            child: Icon(
                              _isWarning ? Icons.schedule_rounded : Icons.access_time_rounded,
                              size: 18,
                              color: _isWarning
                                  ? const Color(0xFFFF6B6B)
                                  : colorScheme.primary,
                            ),
                          ),
                        ),

                        // Enhanced countdown badge
                        if (_isWarning)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFE53935),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '$_secondsRemaining',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                        // Subtle active indicator when not warning
                        if (!_isWarning && _progress > 0.1)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final bool isWarning;
  final Color primaryColor;

  _ProgressRingPainter({
    required this.progress,
    required this.isWarning,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background ring
    final backgroundPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress ring
    final progressPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isWarning
            ? [
                const Color(0xFFFF6B6B),
                const Color(0xFFE53935),
              ]
            : [
                primaryColor,
                primaryColor.withValues(alpha: 0.7),
              ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Add subtle inner glow for warning state
    if (isWarning) {
      final glowPaint = Paint()
        ..color = const Color(0xFFFF6B6B).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}