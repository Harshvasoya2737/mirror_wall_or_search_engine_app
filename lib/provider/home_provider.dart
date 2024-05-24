import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoad = true;
  double webProgress = 0;

  void onChangeLoad(bool isLoad) {
    this.isLoad = isLoad;
    notifyListeners();
  }

  void onWebProgress(double webProgress) {
    this.webProgress = webProgress;
    notifyListeners();
  }

  int _searchEngineValue = 1;
  String _searchEngine = "https://www.google.com/search?q=";
  List<String> bookmarks = [];

  final Map<int, String> searchEngines = {
    1: "https://www.google.com/search?q=",
    2: "https://search.yahoo.com/search?p=",
    3: "https://www.bing.com/search?q=",
    4: "https://duckduckgo.com/?q="
  };

  int get searchEngineValue => _searchEngineValue;

  String get searchEngine => _searchEngine;

  HomeProvider() {
    loadBookmarks();
  }

  void setSearchEngine(int value) {
    _searchEngineValue = value;
    _searchEngine = searchEngines[value]!;
    notifyListeners();
  }

  void addBookmark(String url) async {
    if (!bookmarks.contains(url)) {
      bookmarks.add(url);
      notifyListeners();
      await saveBookmarks();
    }
  }

  void removeBookmark(String bookmark) async {
    bookmarks.remove(bookmark);
    notifyListeners();
    await saveBookmarks();
  }

  Future<void> saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', bookmarks);
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookmarks = prefs.getStringList('bookmarks') ?? [];
    notifyListeners();
  }
}
