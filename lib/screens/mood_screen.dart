import 'package:flutter/material.dart';
import 'details_screen.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD), // Very slight off white
      appBar: AppBar(
        title: const Text("Vibe Trip", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background soft blurred circle layout hack mapping the screenshot
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red[50]),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.teal[50]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Hôm nay bạn\ncảm thấy thế nào?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF2D3142), height: 1.2),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Chọn tâm trạng để Vibe Trip\ngợi ý chuyến đi phù hợp nhất nhé! 🗺️",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    children: [
                      _buildGradientCard(
                        context,
                        "Vui vẻ & Hào hứng",
                        "Sẵn sàng khám phá\nmọi điều thú vị!",
                        "🥳",
                        const [Color(0xFFFFAE70), Color(0xFFFFCC70)],
                      ),
                      const SizedBox(height: 16),
                      _buildGradientCard(
                        context,
                        "Đang buồn",
                        "Để không gian mới\nvực dậy tinh thần bạn",
                        "💙",
                        const [Color(0xFF5D9CF9), Color(0xFF3F6AC8)],
                      ),
                      const SizedBox(height: 16),
                      _buildGradientCard(
                        context,
                        "Mệt mỏi & Cần chữa lành",
                        "Tìm nơi bình yên\nthả lỏng tâm hồn",
                        "🌿",
                        const [Color(0xFF65AC51), Color(0xFF458334)],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context, String title, String subtitle, String emoji, List<Color> colors) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(mood: title))),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: colors.last.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3)),
          ],
        ),
      ),
    );
  }
}
