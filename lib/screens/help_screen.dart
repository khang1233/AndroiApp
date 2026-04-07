import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Trợ giúp & Phản hồi", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.info_outline, size: 80, color: Color(0xFF285C2F)),
            const SizedBox(height: 24),
            const Text(
              "Vibe Trip",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 16),
            const Text(
              "Vibe Trip là ứng dụng du lịch thông minh sử dụng sức mạnh của AI để thiết kế các lộ trình trải nghiệm cá nhân hóa. Với Vibe Trip, mọi chuyến đi đều được đo ni đóng giày theo ngân sách, thời gian, và tâm trạng của riêng bạn.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBE5C3)),
              ),
              child: const Column(
                children: [
                   Text("Mọi thắc mắc liên hệ email:", style: TextStyle(color: Colors.black54, fontSize: 14)),
                   SizedBox(height: 4),
                   Text("Khangnga42@gmail.com", style: TextStyle(color: Color(0xFF285C2F), fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
