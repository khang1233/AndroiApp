import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_manager.dart';
import '../services/api_service.dart';
import '../utils/image_util.dart';
import 'place_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Yêu Thích", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
        centerTitle: false,
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Consumer<FavoriteManager>(
        builder: (context, favManager, child) {
          final favorites = favManager.favorites;
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150, height: 150,
                    decoration: const BoxDecoration(color: Color(0xFFE8EFE9), shape: BoxShape.circle),
                    child: const Center(child: Icon(Icons.favorite_border, size: 64, color: Color(0xFF285C2F))),
                  ),
                  const SizedBox(height: 32),
                  const Text("Chưa có địa điểm yêu thích", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text("Các địa điểm bạn lưu sẽ xuất hiện ở đây để dễ dàng xem lại.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),
                  ),
                ],
              ),
            );
          }

          final ApiService apiService = ApiService();
          List<RealWorldPlace> allPlaces = apiService.filterDestinations("Thành phố") + apiService.filterDestinations("Biển") + apiService.filterDestinations("Núi") + apiService.filterDestinations("Thiên nhiên");
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final placeName = favorites[index];
              final matchingPlace = allPlaces.firstWhere((p) => p.name == placeName, orElse: () => RealWorldPlace(id: '0', name: placeName, lat: 0, lon: 0, categoryLabel: 'Địa điểm', address: '', type: ''));
              
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeName: placeName))),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                        child: Image.asset(
                          ImageUtil.getImg(placeName, ""),
                          width: 120, height: 100, fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(width: 120, height: 100, color: Colors.grey[200]),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(placeName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(matchingPlace.categoryLabel, style: const TextStyle(color: Color(0xFF285C2F), fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => favManager.toggleFavorite(placeName),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
