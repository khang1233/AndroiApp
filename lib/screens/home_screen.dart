import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/image_util.dart';
import 'place_detail_screen.dart';
import 'mood_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  String _searchQuery = "";
  List<RealWorldPlace> _searchResults = [];
  bool _isSearching = false;
  String _selectedTab = "Nổi bật";
  List<RealWorldPlace> _suggestionPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  void _loadSuggestions() {
    setState(() {
      _suggestionPlaces = _apiService.getDestinationsByTab(_selectedTab);
    });
  }

  void _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
      _isSearching = true;
    });

    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final results = await _apiService.searchLocations(query);
    if (!mounted) return;
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildModernAIBanner(context),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text("Khám phá địa điểm", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1F222B))),
              ),
              const SizedBox(height: 16),
              _buildCategoryTabs(),
              const SizedBox(height: 24),
              if (_searchQuery.isNotEmpty)
                _buildSearchResults()
              else ...[
                _buildMainFocusCard(),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("Gợi ý cho bạn", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1F222B))),
                ),
                const SizedBox(height: 16),
                _buildSuggestionsGrid(),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Chào buổi sáng, ${widget.userName}!", style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const Text("Vibe Trip của bạn", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF2D3142)),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Tìm kiếm địa điểm...",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildModernAIBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodScreen())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF285C2F), // Dark green
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hôm nay tâm trạng thế nào?", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Hãy để AI gợi ý chuyến đi phù hợp", style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Kết quả cho '$_searchQuery'", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (_isSearching) const Padding(padding: EdgeInsets.only(left: 10), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF285C2F)))),
            ],
          ),
          const SizedBox(height: 16),
          if (!_isSearching && _searchResults.isEmpty)
            const Text("Không có địa điểm nào", style: TextStyle(color: Colors.grey))
          else
            ..._searchResults.map((place) => _buildResultCard(place)),
        ],
      ),
    );
  }

  Widget _buildResultCard(RealWorldPlace place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeName: place.name)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                // Use the base query so all 3 mock items load the exact identical province image.
                ImageUtil.getImg(_searchQuery.isNotEmpty ? _searchQuery : place.name, ""),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey[300]),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(place.categoryLabel, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF285C2F).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(place.type, style: const TextStyle(color: Color(0xFF285C2F), fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ["Nổi bật", "Gần đây", "Thiên nhiên"].map((tab) {
          bool isActive = _selectedTab == tab;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedTab = tab);
              _loadSuggestions();
            },
            child: Column(
              children: [
                Text(tab, style: TextStyle(fontSize: 14, fontWeight: isActive ? FontWeight.bold : FontWeight.w600, color: isActive ? const Color(0xFF285C2F) : Colors.black54)),
                if (isActive)
                  Container(margin: const EdgeInsets.only(top: 4), height: 3, width: 20, decoration: BoxDecoration(color: const Color(0xFF285C2F), borderRadius: BorderRadius.circular(2))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainFocusCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlaceDetailScreen(placeName: "Đà Nẵng"))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(ImageUtil.getImg("Đà Nẵng", "")),
            fit: BoxFit.cover,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 10))],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF285C2F).withOpacity(0.85), borderRadius: BorderRadius.circular(8)),
                child: const Text("Cầu Vàng", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              const Text("Đà Nẵng", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const Text("Thành phố đáng sống", style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsGrid() {
    if (_suggestionPlaces.isEmpty) {
       return const SizedBox(height: 220, child: Center(child: Text("Đang tải dữ liệu...")));
    }
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _suggestionPlaces.length,
        itemBuilder: (context, index) {
          final place = _suggestionPlaces[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeName: place.name))),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      ImageUtil.getImg(place.name, ""),
                      height: 120,
                      width: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(height: 120, color: Colors.grey[300]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(place.categoryLabel, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
