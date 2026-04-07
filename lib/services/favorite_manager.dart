import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager extends ChangeNotifier {
  List<String> _favorites = [];

  List<String> get favorites => _favorites;

  FavoriteManager() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String placeName) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(placeName)) {
      _favorites.remove(placeName);
    } else {
      _favorites.add(placeName);
    }
    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  bool isFavorite(String placeName) {
    return _favorites.contains(placeName);
  }
}
