import 'dart:convert';
import 'package:http/http.dart' as http;

class RealWorldPlace {
  final String id;
  final String name;
  final double lat;
  final double lon;
  final String categoryLabel;
  final String imageUrl;
  final String address;
  final String type;

  RealWorldPlace({
    required this.id,
    required this.name,
    this.lat = 0.0,
    this.lon = 0.0,
    required this.categoryLabel,
    this.imageUrl = "",
    required this.address,
    required this.type,
  });

  factory RealWorldPlace.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] ?? {};
    final geometry = json['geometry'] ?? {};
    final coords = geometry['coordinates'] as List<dynamic>? ?? [0.0, 0.0];

    return RealWorldPlace(
      id: properties['osm_id']?.toString() ?? "",
      name: properties['name'] ?? "",
      lat: coords[1].toDouble(),
      lon: coords[0].toDouble(),
      categoryLabel: properties['country'] ?? "Việt Nam",
      imageUrl: "",
      address: "${properties['county'] ?? ''}, ${properties['state'] ?? ''}".replaceAll(RegExp(r'^, |,$'), ''),
      type: properties['osm_value'] ?? "Địa điểm",
    );
  }
}

class ApiService {
  static const String _nominatimUrl = "https://photon.komoot.io/api/";

  static final List<RealWorldPlace> _staticPlaces = [
    RealWorldPlace(id: "hanoi", name: "Hà Nội", type: "Thành phố", categoryLabel: "Thủ đô văn hiến", address: "Hà Nội"),
    RealWorldPlace(id: "hcm", name: "TP.HCM", type: "Thành phố", categoryLabel: "Thành phố sôi động", address: "Hồ Chí Minh"),
    RealWorldPlace(id: "danang", name: "Đà Nẵng", type: "Biển", categoryLabel: "Thành phố đáng sống", address: "Đà Nẵng"),
    RealWorldPlace(id: "dalat", name: "Đà Lạt", type: "Núi", categoryLabel: "Thành phố sương mù", address: "Lâm Đồng"),
    RealWorldPlace(id: "nhatrang", name: "Nha Trang", type: "Biển", categoryLabel: "Hòn ngọc biển", address: "Khánh Hòa"),
    RealWorldPlace(id: "vungtau", name: "Vũng Tàu", type: "Biển", categoryLabel: "Thành phố gần bờ", address: "Bà Rịa"),
    RealWorldPlace(id: "halong", name: "Hạ Long", type: "Thiên nhiên", categoryLabel: "Kỳ quan thế giới", address: "Quảng Ninh"),
    RealWorldPlace(id: "sapa", name: "Sapa", type: "Núi", categoryLabel: "Thị trấn sương mù", address: "Lào Cai"),
    RealWorldPlace(id: "bentre", name: "Bến Tre", type: "Thiên nhiên", categoryLabel: "Xứ dừa mộc mạc", address: "Bến Tre"),
    RealWorldPlace(id: "cantho", name: "Cần Thơ", type: "Thành phố", categoryLabel: "Thủ phủ miền Tây", address: "Cần Thơ"),
    RealWorldPlace(id: "phuquoc", name: "Phú Quốc", type: "Biển", categoryLabel: "Đảo ngọc hoang sơ", address: "Kiên Giang"),
    RealWorldPlace(id: "hoian", name: "Hội An", type: "Thành phố", categoryLabel: "Phố cổ trầm mặc", address: "Quảng Nam"),
    RealWorldPlace(id: "hue", name: "Huế", type: "Thành phố", categoryLabel: "Cố đô đượm buồn", address: "Thừa Thiên Huế"),
    RealWorldPlace(id: "ninhbinh", name: "Ninh Bình", type: "Thiên nhiên", categoryLabel: "Hạ Long trên cạn", address: "Ninh Bình"),
    RealWorldPlace(id: "hagiang", name: "Hà Giang", type: "Núi", categoryLabel: "Cao nguyên đá", address: "Hà Giang"),
    RealWorldPlace(id: "muine", name: "Mũi Né", type: "Biển", categoryLabel: "Thủ đô resort", address: "Bình Thuận"),
    RealWorldPlace(id: "tayninh", name: "Tây Ninh", type: "Núi", categoryLabel: "Vùng đất thiêng", address: "Tây Ninh"),
    RealWorldPlace(id: "vinhhy", name: "Vĩnh Hy", type: "Biển", categoryLabel: "Hoang sơ", address: "Ninh Thuận"),
    RealWorldPlace(id: "condao", name: "Côn Đảo", type: "Biển", categoryLabel: "Du lịch tâm linh", address: "Bà Rịa"),
    RealWorldPlace(id: "quynhon", name: "Quy Nhơn", type: "Biển", categoryLabel: "Thành phố thi ca", address: "Bình Định"),
  ];

  Future<List<RealWorldPlace>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];
    
    final q = query.trim().toLowerCase();
    final matches = _staticPlaces.where((p) => p.name.toLowerCase().contains(q) || p.address.toLowerCase().contains(q)).toList();
    
    if (matches.isEmpty) {
      return [
        RealWorldPlace(id: "1", name: query, lat: 0, lon: 0, categoryLabel: "Khu vực", address: "Việt Nam", type: "Tỉnh/Thành phố"),
        RealWorldPlace(id: "2", name: "Trung Tâm", lat: 0, lon: 0, categoryLabel: "Nổi bật", address: query, type: "Khám phá"),
        RealWorldPlace(id: "3", name: "Du Lịch", lat: 0, lon: 0, categoryLabel: "Sinh thái", address: query, type: "Tham quan"),
      ];
    }
    
    final base = matches.first;
    return [
      base,
      RealWorldPlace(id: "sub1", name: "Trung Tâm ${base.name}", type: "Phố cổ", categoryLabel: "Khám Phá", address: base.address),
      RealWorldPlace(id: "sub2", name: "Khu Trải Nghiệm ${base.name}", type: "Sinh thái", categoryLabel: "Tuổi Trẻ", address: base.address),
    ];
  }

  List<RealWorldPlace> getDestinationsByTab(String tab) {
    if (tab == "Thiên nhiên") return _staticPlaces.where((p) => p.type.toLowerCase() == "thiên nhiên" || p.type.toLowerCase() == "núi").toList();
    if (tab == "Gần đây") return _staticPlaces.where((p) => p.type.toLowerCase() == "biển").toList();
    return _staticPlaces.take(6).toList(); // Nổi bật
  }

  List<RealWorldPlace> filterDestinations(String locationType) {
    if (locationType == "Biển") return _staticPlaces.where((p) => p.type.toLowerCase() == "biển").toList();
    if (locationType == "Núi") return _staticPlaces.where((p) => p.type.toLowerCase() == "núi").toList();
    if (locationType == "Thành phố") return _staticPlaces.where((p) => p.type.toLowerCase() == "thành phố").toList();
    return _staticPlaces;
  }
}
