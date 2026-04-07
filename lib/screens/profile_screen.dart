import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBioSetting();
  }

  Future<void> _loadBioSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('use_biometric') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Stack(
        children: [
          // Green top block
          Container(
            height: 220,
            color: const Color(0xFF528B55), // Dark green header block
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                    ],
                  ),
                ),
                // Profile Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(widget.userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                      const Text("thephongfaifai11@gmail.com", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Cài đặt tài khoản", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 12),
                      _buildSettingsBlock([
                        _buildActionTile(Icons.edit, "Chỉnh sửa hồ sơ"),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        _buildActionTile(Icons.notifications, "Thông báo"),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        _buildToggleTile(Icons.fingerprint, "Bảo mật sinh trắc học", "Vân tay / Khuôn mặt khi mở app", _biometricEnabled, (val) => setState(() => _biometricEnabled = val)),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        _buildSubActionTile(Icons.language, "Ngôn ngữ", "🇻🇳 Tiếng Việt"),
                      ]),
                      const SizedBox(height: 24),
                      const Text("Khác", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 12),
                      _buildSettingsBlock([
                        _buildActionTile(Icons.help, "Trợ giúp & Phản hồi", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()))),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        _buildActionTile(Icons.logout, "Đăng xuất", color: Colors.redAccent, onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('isGuest');
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }),
                      ]),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBlock(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildActionTile(IconData icon, String title, {Color color = const Color(0xFF2D3142), VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildSubActionTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF285C2F)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF285C2F)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: Switch(
        value: value,
        onChanged: (val) async {
          onChanged(val);
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('use_biometric', val);
        },
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF285C2F),
      ),
    );
  }
}
