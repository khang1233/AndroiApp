import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController(); 
  bool _isLoading = false;
  bool _isLoginMode = true; 

  void _navToMain(String displayName) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(userName: displayName)),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green));
  }

  Future<void> _submitEmailForm() async {
    setState(() => _isLoading = true);
    try {
      if (_isLoginMode) {
        // LOGIN
        final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailCtrl.text.trim(), password: _passCtrl.text.trim());
        _navToMain(cred.user?.displayName ?? cred.user?.email ?? "Bạn");
      } else {
        // REGISTER
        if (_passCtrl.text != _confirmPassCtrl.text) {
          setState(() => _isLoading = false);
          _showError("Mật khẩu nhập lại không khớp!");
          return;
        }
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailCtrl.text.trim(), password: _passCtrl.text.trim());
        _showSuccess("Đăng ký thành công! Vui lòng đăng nhập.");
        setState(() {
          _isLoginMode = true;
          _passCtrl.clear();
          _confirmPassCtrl.clear();
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        _showError("Sai tài khoản hoặc mật khẩu.");
      } else if (e.code == 'email-already-in-use') {
        _showError("Email này đã được sử dụng.");
      } else if (e.code == 'weak-password') {
        _showError("Mật khẩu quá yếu.");
      } else {
        _showError("Lỗi: ${e.message}");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final gsi = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await gsi.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await FirebaseAuth.instance.signInWithCredential(credential);
      _navToMain(cred.user?.displayName ?? cred.user?.email ?? "Bạn");
    } catch (e) {
      _showError("Lỗi Google: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGitHub() async {
    setState(() => _isLoading = true);
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      final cred = await FirebaseAuth.instance.signInWithProvider(githubProvider);
      _navToMain(cred.user?.displayName ?? cred.user?.email ?? "Bạn");
    } catch (e) {
      _showError("Lỗi GitHub: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginAsGuest() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); 
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuest', true);
    _navToMain("Khách");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/img_danang.png', 
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          // Titles
                          const Text(
                            "Vibe Trip",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Khám phá hành trình theo cảm xúc",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const Spacer(),

                          // White Card Box
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isLoginMode ? "Đăng nhập để bắt đầu" : "Tạo tài khoản mới",
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 24),
                                
                                // Email Field
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: TextField(
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: TextField(
                                    controller: _passCtrl,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "Mật khẩu",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                
                                if (!_isLoginMode) ...[
                                  const SizedBox(height: 16),
                                  // Confirm Password Field
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: TextField(
                                      controller: _confirmPassCtrl,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: "Nhập lại mật khẩu",
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 24),

                                // Action Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _submitEmailForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF285C2F),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                      elevation: 0,
                                    ),
                                    child: _isLoading 
                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                        : Text(
                                            _isLoginMode ? "ĐĂNG NHẬP" : "ĐĂNG KÝ", 
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0)
                                          ),
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Toggle Mode
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isLoginMode = !_isLoginMode;
                                      _passCtrl.clear();
                                      _confirmPassCtrl.clear();
                                    });
                                  },
                                  child: Text(
                                    _isLoginMode ? "Chưa có tài khoản? Đăng ký" : "Đã có tài khoản? Đăng nhập", 
                                    style: const TextStyle(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.w600)
                                  ),
                                ),
                                
                                if (_isLoginMode) ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(color: Colors.black12),
                                  ),

                                  // Social Circles
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildSocialCircle(Icons.g_mobiledata, Colors.red, _loginWithGoogle),
                                      const SizedBox(width: 16),
                                      _buildSocialCircle(Icons.code, Colors.black, _loginWithGitHub),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 24),
                                
                                // Guest text
                                GestureDetector(
                                  onTap: _loginAsGuest,
                                  child: const Text("Tiếp tục với tư cách Khách", style: TextStyle(color: Colors.black54, fontSize: 14)),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCircle(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFFEBEBEB),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
