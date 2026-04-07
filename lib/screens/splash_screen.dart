import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final prefs = await SharedPreferences.getInstance();
      User? user;
      try {
        user = FirebaseAuth.instance.currentUser;
      } catch (e) {
        debugPrint("Firebase chưa sẵn sàng: $e");
      }

      if (user != null) {
        bool useBio = prefs.getBool('use_biometric') ?? false;
        if (useBio) {
          bool canCheckBiometrics = false;
          try {
            canCheckBiometrics = await auth.canCheckBiometrics;
          } catch (_) {}
          
          if (canCheckBiometrics) {
            try {
              bool didAuthenticate = await auth.authenticate(
                localizedReason: 'Cần xác thực vân tay/khuôn mặt để mở Vibe Trip',
              );
              if (didAuthenticate) {
                _navToMain(user.displayName ?? user.email ?? "Bạn");
              } else {
                _navToLogin();
              }
              return;
            } catch (e) {
              debugPrint("Lỗi sinh trắc học: $e");
            }
          }
        }
        _navToMain(user.displayName ?? user.email ?? "Bạn");
      } else {
        bool isGuest = prefs.getBool('isGuest') ?? false;
        if (isGuest) {
          _navToMain("Khách");
        } else {
          _navToLogin();
        }
      }
    } catch (e) {
      debugPrint("Lỗi splash: $e");
      _navToLogin(); // Fail-safe: luôn về login nếu có lỗi
    }
  }

  void _navToMain(String displayName) {
    if(!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen(userName: displayName)));
  }

  void _navToLogin() {
    if(!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF285C2F),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
