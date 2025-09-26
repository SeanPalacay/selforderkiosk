import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class IdleTimer {
  static const Duration _idleTimeout = Duration(minutes: 2); // Return to attract mode after 2 minutes
  Timer? _timer;
  final VoidCallback? _onIdle;

  IdleTimer({VoidCallback? onIdle}) : _onIdle = onIdle;

  void startTimer() {
    _timer?.cancel();
    _timer = Timer(_idleTimeout, () {
      _onIdle?.call();
    });
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}

// Session timeout notifier to coordinate between IdleDetector and IdleStatusIndicator
class SessionTimeoutNotifier extends ChangeNotifier {
  static final SessionTimeoutNotifier _instance = SessionTimeoutNotifier._internal();
  factory SessionTimeoutNotifier() => _instance;
  SessionTimeoutNotifier._internal();

  double _progress = 0.0;
  bool _isWarning = false;
  int _secondsRemaining = 0;

  double get progress => _progress;
  bool get isWarning => _isWarning;
  int get secondsRemaining => _secondsRemaining;

  void updateProgress(double progress) {
    _progress = progress;
    notifyListeners();
  }

  void updateWarning(bool isWarning, int secondsRemaining) {
    _isWarning = isWarning;
    _secondsRemaining = secondsRemaining;
    notifyListeners();
  }

  void reset() {
    _progress = 0.0;
    _isWarning = false;
    _secondsRemaining = 0;
    notifyListeners();
  }
}

class IdleDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onIdle;
  final Duration idleTimeout;
  final Duration warningDuration;

  const IdleDetector({
    super.key,
    required this.child,
    this.onIdle,
    this.idleTimeout = const Duration(minutes: 2),
    this.warningDuration = const Duration(seconds: 30), // Show warning 30 seconds before timeout
  });

  @override
  State<IdleDetector> createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector>
    with TickerProviderStateMixin {
  Timer? _idleTimer;
  Timer? _warningTimer;
  Timer? _countdownTimer;
  Timer? _progressTimer;
  DateTime? _startTime;
  bool _showWarning = false;
  int _secondsRemaining = 0;
  late AnimationController _pulseController;
  late AnimationController _overlayController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _overlayAnimation;
  final SessionTimeoutNotifier _timeoutNotifier = SessionTimeoutNotifier();

  @override
  void initState() {
    super.initState();

    // Animation controllers with enhanced timings
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeOutExpo,
    ));

    _startIdleTimer();
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();
    _warningTimer?.cancel();
    _countdownTimer?.cancel();
    _progressTimer?.cancel();

    if (_showWarning) {
      setState(() {
        _showWarning = false;
      });
      _overlayController.reverse();
      _pulseController.stop();
    }

    // Reset the notifier
    _timeoutNotifier.reset();

    // Record start time
    _startTime = DateTime.now();

    // Start progress timer to update the indicator
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_startTime != null) {
        final elapsed = DateTime.now().difference(_startTime!).inMilliseconds;
        final progress = elapsed / widget.idleTimeout.inMilliseconds;
        _timeoutNotifier.updateProgress(progress.clamp(0.0, 1.0));

        if (progress >= 1.0) {
          timer.cancel();
        }
      }
    });

    // Start warning timer (triggers before idle timeout)
    _warningTimer = Timer(widget.idleTimeout - widget.warningDuration, () {
      _showIdleWarning();
    });

    // Start main idle timer
    _idleTimer = Timer(widget.idleTimeout, () {
      widget.onIdle?.call();
    });
  }

  void _showIdleWarning() {
    setState(() {
      _showWarning = true;
      _secondsRemaining = widget.warningDuration.inSeconds;
    });

    _overlayController.forward();
    _pulseController.repeat(reverse: true);

    // Update the notifier with warning state
    _timeoutNotifier.updateWarning(true, _secondsRemaining);

    // Start countdown timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });

      // Update the notifier with countdown
      _timeoutNotifier.updateWarning(true, _secondsRemaining);

      if (_secondsRemaining <= 0) {
        timer.cancel();
      }
    });
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _warningTimer?.cancel();
    _countdownTimer?.cancel();
    _progressTimer?.cancel();

    if (_showWarning) {
      setState(() {
        _showWarning = false;
      });
      _overlayController.reverse();
      _pulseController.stop();
    }

    _startIdleTimer();
  }

  void _continueSession() {
    _resetIdleTimer();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _warningTimer?.cancel();
    _countdownTimer?.cancel();
    _progressTimer?.cancel();
    _pulseController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetIdleTimer,
      onPanDown: (details) => _resetIdleTimer(),
      onScaleStart: (details) => _resetIdleTimer(),
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          widget.child,

          // Enhanced idle warning overlay with sophisticated animations
          if (_showWarning)
            AnimatedBuilder(
              animation: _overlayAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * _overlayAnimation.value),
                  child: Opacity(
                    opacity: _overlayAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.5,
                          colors: [
                            Colors.black.withValues(alpha: 0.6 * _overlayAnimation.value),
                            Colors.black.withValues(alpha: 0.8 * _overlayAnimation.value),
                          ],
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(
                          sigmaX: 5 * _overlayAnimation.value,
                          sigmaY: 5 * _overlayAnimation.value,
                        ),
                        child: Center(
                          child: Transform.translate(
                            offset: Offset(0, 50 * (1 - _overlayAnimation.value)),
                            child: _buildIdleWarningDialog(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildIdleWarningDialog() {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(32),
            constraints: const BoxConstraints(maxWidth: 460),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                  blurRadius: 60,
                  offset: const Offset(0, 0),
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Enhanced warning icon with glow effect
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                                  const Color(0xFFE53935).withValues(alpha: 0.1),
                                ],
                              ),
                              border: Border.all(
                                color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.access_time_filled_rounded,
                              size: 48,
                              color: Color(0xFFFF6B6B),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Enhanced title with gradient
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            colorScheme.onSurface,
                            colorScheme.onSurface.withValues(alpha: 0.8),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Session Timeout',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1.2,
                            height: 1.1,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Enhanced countdown with sophisticated design
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFF6B6B),
                              Color(0xFFE53935),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.timer_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  '$_secondsRemaining',
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                    height: 1.0,
                                  ),
                                ),
                                const Text(
                                  'seconds',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                // Removed custom underline below 'seconds'
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Enhanced message
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Your session will return to the main screen due to inactivity',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            letterSpacing: 0.15,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Enhanced action buttons
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: OutlinedButton.icon(
                                onPressed: () => widget.onIdle?.call(),
                                icon: const Icon(Icons.home_rounded, size: 22),
                                label: const Text(
                                  'Return to Main',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  side: BorderSide(
                                    color: colorScheme.outline.withValues(alpha: 0.6),
                                    width: 2,
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.primary.withValues(alpha: 0.9),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: FilledButton.icon(
                                onPressed: _continueSession,
                                icon: const Icon(Icons.touch_app_rounded, size: 22),
                                label: const Text(
                                  'Continue Session',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Enhanced touch hint
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primaryContainer.withValues(alpha: 0.6),
                              colorScheme.primaryContainer.withValues(alpha: 0.4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app_outlined,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Touch anywhere to continue',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}