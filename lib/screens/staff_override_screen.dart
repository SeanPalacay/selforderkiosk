import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StaffOverrideScreen extends StatefulWidget {
  const StaffOverrideScreen({super.key});

  @override
  State<StaffOverrideScreen> createState() => _StaffOverrideScreenState();
}

class _StaffOverrideScreenState extends State<StaffOverrideScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _isLoading = false;
  String _errorMessage = '';

  // In a real app, this should be securely stored and configurable
  static const String _staffPassword = 'STAFF2024';

  @override
  void initState() {
    super.initState();
    // Auto-focus the password field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _passwordFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text(
          'Staff Override',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.all(32),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 80,
                    color: Colors.red[700],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Staff Access Required',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter the staff password to access admin functions or exit kiosk mode.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: const TextStyle(letterSpacing: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red[700]!),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.red[700],
                      ),
                      errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                    ),
                    onSubmitted: (_) => _validatePassword(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _validatePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Access',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Warning: This will exit kiosk mode',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validatePassword() async {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 1));

    if (_passwordController.text == _staffPassword) {
      setState(() {
        _isLoading = false;
      });

      // Show success and options
      _showSuccessDialog();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid password';
      });

      // Clear the password field
      _passwordController.clear();
      _passwordFocus.requestFocus();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600]),
              const SizedBox(width: 8),
              const Text('Access Granted'),
            ],
          ),
          content: const Text(
            'Staff access verified. What would you like to do?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close staff override screen
              },
              child: const Text('Return to Kiosk'),
            ),
            ElevatedButton(
              onPressed: _exitKioskMode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Exit Kiosk Mode'),
            ),
          ],
        );
      },
    );
  }

  void _exitKioskMode() {
    // In a real implementation, this would:
    // 1. Disable kiosk mode
    // 2. Allow access to system settings
    // 3. Potentially close the app or show admin interface

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Kiosk Mode'),
          content: const Text(
            'Kiosk mode has been disabled. The application can now be minimized or closed.\n\n'
            'To re-enable kiosk mode, restart the application.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                // In a real app, you might call SystemNavigator.pop()
                // or implement proper app closure
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Close App'),
            ),
          ],
        );
      },
    );
  }
}