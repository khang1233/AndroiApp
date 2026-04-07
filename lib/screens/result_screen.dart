import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/image_util.dart';
import 'place_detail_screen.dart';

class ResultScreen extends StatefulWidget {
  final String mood;
  final String? budget;
  final String? duration;
  final String? location;
  const ResultScreen({
    super.key, 
    required this.mood, 
    this.budget, 
    this.duration, 
    this.location
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<RealWorldPlace> _places = [];

  @override
  void initState() {
    super.initState();
    _fetchRandomDestinations();
  }

  Future<void> _fetchRandomDestinations() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate AI calculation

    List<RealWorldPlace> list = [];
    String loc = widget.location ?? "Thành phố";
    String moodVal = widget.mood;

    if (loc == "Biển") {
       if (moodVal == "Buồn" || moodVal == "Chữa Lành") {
          list = [
            RealWorldPlace(id: "1", name: "Côn Đảo", lat: 0.0, lon: 0.0, categoryLabel: "Yên Lặng", address: "Bà Rịa", type: "Biển"),
            RealWorldPlace(id: "2", name: "Phú Quốc", lat: 0.0, lon: 0.0, categoryLabel: "Chữa Lành", address: "Kiên Giang", type: "Biển"),
            RealWorldPlace(id: "3", name: "Vịnh Vĩnh Hy", lat: 0.0, lon: 0.0, categoryLabel: "Chill Xả Stress", address: "Ninh Thuận", type: "Biển"),
          ];
       } else {
          list = [
            RealWorldPlace(id: "1", name: "Nha Trang", lat: 0.0, lon: 0.0, categoryLabel: "Sôi Động", address: "Khánh Hòa", type: "Biển"),
            RealWorldPlace(id: "2", name: "Trung Tâm Vũng Tàu", lat: 0.0, lon: 0.0, categoryLabel: "Năng Động", address: "Bà Rịa", type: "Biển"),
            RealWorldPlace(id: "3", name: "Mũi Né", lat: 0.0, lon: 0.0, categoryLabel: "Trải Nghiệm", address: "Bình Thuận", type: "Biển"),
          ];
       }
    } else if (loc == "Núi") {
       if (moodVal == "Buồn" || moodVal == "Chữa Lành") {
          list = [
            RealWorldPlace(id: "1", name: "Núi Chứa Chan", lat: 0.0, lon: 0.0, categoryLabel: "Yên Tĩnh Thiền Định", address: "Đồng Nai", type: "Núi"),
            RealWorldPlace(id: "2", name: "Đà Lạt", lat: 0.0, lon: 0.0, categoryLabel: "Mộng Mơ", address: "Lâm Đồng", type: "Núi"),
            RealWorldPlace(id: "3", name: "Tà Năng", lat: 0.0, lon: 0.0, categoryLabel: "Tự Do Lốc Cốc", address: "Lâm Đồng", type: "Núi"),
          ];
       } else {
          list = [
            RealWorldPlace(id: "1", name: "Sapa", lat: 0.0, lon: 0.0, categoryLabel: "Khám Phá Sương Mù", address: "Lào Cai", type: "Núi"),
            RealWorldPlace(id: "2", name: "Hà Giang", lat: 0.0, lon: 0.0, categoryLabel: "Mạo Hiểm Phượt", address: "Hà Giang", type: "Núi"),
            RealWorldPlace(id: "3", name: "Đỉnh Lảo Thẩn", lat: 0.0, lon: 0.0, categoryLabel: "Săn Mây Đỉnh Cao", address: "Lào Cai", type: "Núi"),
          ];
       }
    } else {
       list = [
         RealWorldPlace(id: "1", name: "Hà Nội", lat: 0.0, lon: 0.0, categoryLabel: "Văn Hóa Cổ Kính", address: "Hà Nội", type: "Thành phố"),
         RealWorldPlace(id: "2", name: "Hồ Chí Minh", lat: 0.0, lon: 0.0, categoryLabel: "24/7 Không Ngủ", address: "TP.HCM", type: "Thành phố"),
         RealWorldPlace(id: "3", name: "Đà Nẵng", lat: 0.0, lon: 0.0, categoryLabel: "Đáng Sống Nhất", address: "Đà Nẵng", type: "Thành phố"),
       ];
    }
    
    if (!mounted) return;
    setState(() {
      _places = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Kết quả AI", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF00A250)),
                  SizedBox(height: 16),
                  Text("AI đang phân tích và thiết kế chuyến đi...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(
                    placeName: place.name,
                    budget: widget.budget,
                    duration: widget.duration,
                    mood: widget.mood,
                    isItineraryMode: true,
                  ))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            ImageUtil.getImg(place.name, ""),
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(height: 180, color: Colors.grey[300]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(place.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFF00A250).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                child: Text(place.categoryLabel, style: const TextStyle(color: Color(0xFF00A250), fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
