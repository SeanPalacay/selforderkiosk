import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'providers/cart_provider.dart';
import 'screens/attract_mode_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable kiosk mode on app start
  await _enableKioskMode();

  runApp(const KioskApp());
}

Future<void> _enableKioskMode() async {
  try {
    // Prevent screenshots and screen recording
    await ScreenProtector.preventScreenshotOn();

    // Hide system UI (status bar, navigation bar) for full kiosk experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Lock orientation to portrait for kiosk setup
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Prevent the app from being minimized
    await ScreenProtector.protectDataLeakageOn();
  } catch (e) {
    // Handle any errors in kiosk mode setup
    debugPrint('Error setting up kiosk mode: $e');
  }
}

class KioskApp extends StatelessWidget {
  const KioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MaterialApp(
        title: 'AI Services Kiosk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            // Primary colors - Deep Navy Blue
            primary: Color(0xFF00004c),
            onPrimary: Color(0xFFFFFFFF),
            primaryContainer: Color(0xFFE3F2FD),
            onPrimaryContainer: Color(0xFF00004c),

            // Secondary colors - Blue accent
            secondary: Color(0xFF0074a8),
            onSecondary: Color(0xFFFFFFFF),
            secondaryContainer: Color(0xFFE1F5FE),
            onSecondaryContainer: Color(0xFF0074a8),

            // Tertiary colors - Lighter blue
            tertiary: Color(0xFF42A5F5),
            onTertiary: Color(0xFFFFFFFF),
            tertiaryContainer: Color(0xFFE3F2FD),
            onTertiaryContainer: Color(0xFF0074a8),

            // Background and surfaces
            surface: Color(0xFFFFFFFF),
            onSurface: Color(0xFF00004c),
            surfaceContainerHighest: Color(0xFFF5F5F5),
            onSurfaceVariant: Color(0xFF666666),

            // Outline colors
            outline: Color(0xFFCCCCCC),
            outlineVariant: Color(0xFFE0E0E0),

            // Error colors
            error: Color(0xFFD32F2F),
            onError: Color(0xFFFFFFFF),
            errorContainer: Color(0xFFFFEBEE),
            onErrorContainer: Color(0xFFD32F2F),

            // Shadow and other colors
            shadow: Color(0xFF000000),
            scrim: Color(0xFF000000),
            inverseSurface: Color(0xFF00004c),
            onInverseSurface: Color(0xFFFFFFFF),
            inversePrimary: Color(0xFF90CAF9),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF00004c),
            foregroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 28,
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF00004c),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: const Color(0xFF00004c).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0074a8),
              foregroundColor: Colors.white,
              elevation: 3,
              shadowColor: const Color(0xFF0074a8).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0074a8),
              side: const BorderSide(
                color: Color(0xFF0074a8),
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shadowColor: const Color(0xFF00004c).withValues(alpha: 0.15),
            surfaceTintColor: const Color(0xFFE3F2FD),
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFFE1F5FE),
            labelStyle: const TextStyle(
              color: Color(0xFF0074a8),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(
              color: Color(0xFF0074a8),
              width: 1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF00004c),
            contentTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            actionTextColor: const Color(0xFF42A5F5),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF0074a8),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFCCCCCC),
                width: 1,
              ),
            ),
            labelStyle: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFFE0E0E0),
            thickness: 1,
            space: 1,
          ),
          listTileTheme: const ListTileThemeData(
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00004c),
              letterSpacing: 0.15,
            ),
            subtitleTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              letterSpacing: 0.25,
            ),
          ),
          // Add text theme for consistent typography
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF00004c),
              letterSpacing: -0.8,
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF00004c),
              letterSpacing: -0.5,
            ),
            displaySmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00004c),
              letterSpacing: 0,
            ),
            headlineLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00004c),
              letterSpacing: 0,
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00004c),
              letterSpacing: 0.15,
            ),
            headlineSmall: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00004c),
              letterSpacing: 0.15,
            ),
            titleLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00004c),
              letterSpacing: 0.15,
            ),
            titleMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00004c),
              letterSpacing: 0.25,
            ),
            titleSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0074a8),
              letterSpacing: 0.3,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              letterSpacing: 0.15,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              letterSpacing: 0.25,
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
              letterSpacing: 0.4,
            ),
          ),
        ),
        home: const KioskWrapper(),
      ),
    );
  }
}

class KioskWrapper extends StatefulWidget {
  const KioskWrapper({super.key});

  @override
  State<KioskWrapper> createState() => _KioskWrapperState();
}

class _KioskWrapperState extends State<KioskWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Prevent users from using hardware buttons to exit
    _preventHardwareButtonExit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _preventHardwareButtonExit() {
    // Override system back button behavior
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') {
        // Prevent the default back button behavior
        // In kiosk mode, users shouldn't be able to exit the app
        return;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Re-enable kiosk mode if the app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _reEnableKioskMode();
    }
  }

  void _reEnableKioskMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent back gesture/button from closing the app
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // Do nothing - this prevents users from accidentally exiting
        // Staff can still use the staff override to exit
      },
      child: const AttractModeScreen(),
    );
  }
}
