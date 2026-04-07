import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  final String userName;
  const MainScreen({super.key, required this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(userName: widget.userName),
      const FavoriteScreen(),
      const NotificationScreen(), // Replaced mapping tab with notif to match 4 tabs
      ProfileScreen(userName: widget.userName),
    ];
  }

  void _onTabTapped(int index) async {
    if (index == 2) {
      // The 3rd tab in native app opened explicit Map Intent.
      final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=địa điểm du lịch");
      launchUrl(url, mode: LaunchMode.externalApplication);
      return; 
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00A250),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Khám Phá"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Yêu Thích"),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: "Hành Trình"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Hồ Sơ"),
        ],
      ),
    );
  }
}
