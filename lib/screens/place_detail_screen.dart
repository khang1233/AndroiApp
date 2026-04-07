import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../services/favorite_manager.dart';
import '../utils/image_util.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeName;
  final String? budget;
  final String? duration;
  final String? mood;
  final bool isItineraryMode;

  const PlaceDetailScreen({
    super.key, 
    required this.placeName,
    this.budget,
    this.duration,
    this.mood,
    this.isItineraryMode = false,
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final AiService _aiService = AiService();
  String _rawAiOutput = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAiDescription();
  }

  Future<void> _fetchAiDescription() async {
    final output = await (widget.isItineraryMode
      ? _aiService.generateItinerary(
          widget.placeName,
          budget: widget.budget ?? "",
          duration: widget.duration ?? "",
          mood: widget.mood ?? "",
        )
      : _aiService.generateIntro(widget.placeName));

    if (!mounted) return;
    setState(() {
      _rawAiOutput = output;
      _isLoading = false;
    });
  }

  Future<void> _openGoogleMaps() async {
    final query = Uri.encodeComponent(widget.placeName);
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể mở Google Maps')));
      }
    }
  }

  // Parses raw output safely
  Map<String, dynamic>? _getParsedItinerary() {
    try {
      final text = _rawAiOutput.replaceAll("```json", "").replaceAll("```", "").trim();
      return jsonDecode(text);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showTimeline = widget.isItineraryMode && _getParsedItinerary() != null;
    final parsedMap = _getParsedItinerary() ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F5),
      appBar: AppBar(
        title: Text(_isLoading ? "Đang kết nối..." : widget.placeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Consumer<FavoriteManager>(
            builder: (context, favManager, child) {
              final isFav = favManager.isFavorite(widget.placeName);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.black87),
                onPressed: () => favManager.toggleFavorite(widget.placeName),
              );
            },
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF285C2F)),
                SizedBox(height: 16),
                Text("AI đang xây dựng lịch trình và tính toán chi phí...", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            )
          )
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            ImageUtil.getImg(widget.placeName, ""),
                            height: 240, width: double.infinity, fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(height: 240, color: Colors.grey[300]),
                          ),
                          Container(
                            height: 240,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                colors: [Colors.black54, Colors.transparent, Colors.black87],
                              )
                            ),
                          ),
                          Positioned(
                            bottom: 16, left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.placeName, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.wb_sunny, color: Colors.orange, size: 16),
                                    const SizedBox(width: 4),
                                    Text("24°C - Trời nắng ráo", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: showTimeline 
                            ? _buildNativeItinerary(parsedMap)
                            : _buildStandardIntro(),
                      ),
                    ],
                  ),
                ),
              ),
              if (showTimeline) _buildStickyFooter(parsedMap),
            ],
          ),
    );
  }

  Widget _buildNativeItinerary(Map<String, dynamic> data) {
    final intro = data['intro'] ?? "";
    final List items = data['itinerary'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.auto_awesome, color: Color(0xFF285C2F)),
            SizedBox(width: 8),
            Text("Lịch trình Gen Z thiết kế bởi AI", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF285C2F))),
          ],
        ),
        const SizedBox(height: 12),
        Text(intro, style: const TextStyle(fontSize: 15, color: Color(0xFF285C2F), fontWeight: FontWeight.w500, height: 1.5)),
        const SizedBox(height: 24),
        
        ...items.map((item) {
          final dayStr = item['day']?.toString() ?? "";
          final timeStr = item['time']?.toString() ?? "";
          final titleStr = item['title']?.toString() ?? "";
          final descStr = item['desc']?.toString() ?? "";
          final costStr = item['cost']?.toString() ?? "";

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dayStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285C2F), fontSize: 16)),
                      Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285C2F), fontSize: 14)),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(titleStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Text(descStr, style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4)),
                        const SizedBox(height: 12),
                        Text("Chi phí ước tính: $costStr", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4DB6AC))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStandardIntro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_rawAiOutput, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _openGoogleMaps,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color(0xFF285C2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.location_on),
            label: const Text("Dẫn đường đến đây", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      )
    );
  }

  Widget _buildStickyFooter(Map<String, dynamic> data) {
    final total = data['totalCost']?.toString() ?? "";
    final List breakdown = data['costBreakdown'] ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (breakdown.isNotEmpty) ...[
              ...breakdown.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("${item['label']} (${item['percentage']})", style: const TextStyle(fontSize: 14, color: Colors.black54), overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Text("${item['amount']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                );
              }).toList(),
              const Divider(height: 24, thickness: 1, color: Colors.black12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng chi phí tối ưu:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(total.replaceAll("Tổng chi phí tối ưu:", "").trim(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF285C2F))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse("https://www.agoda.com/");
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    debugPrint("Could not launch Agoda");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF285C2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.verified),
                label: const Text("Đặt phòng ngay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
