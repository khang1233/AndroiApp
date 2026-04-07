import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {"title": "Mùa hè vẫy gọi!", "desc": "Giảm ngay 20% các chuyến bay nội địa", "time": "2 giờ trước"},
      {"title": "Gợi ý mới cho bạn", "desc": "Khám phá địa điểm bí ẩn tại Đà Lạt ngay", "time": "1 ngày trước"},
      {"title": "Tính năng AI mới", "desc": "Gemini 2.5 đã sẵn sàng hỗ trợ bạn", "time": "3 ngày trước"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Thông Báo", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF00A250),
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text(notif['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif['desc']!, style: const TextStyle(color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(notif['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
