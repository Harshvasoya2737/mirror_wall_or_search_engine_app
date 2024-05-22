import 'package:flutter/material.dart';

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
  String _searchEngine = "https://www.google.com/";
  List<String> bookmarks = [];

  final Map<int, String> searchEngines = {
    1: "https://www.google.com/",
    2: "https://www.yahoo.com/",
    3: "https://www.bing.com/",
    4: "https://duckduckgo.com/"
  };

  int get searchEngineValue => _searchEngineValue;

  String get searchEngine => _searchEngine;

  void setSearchEngine(int value) {
    _searchEngineValue = value;
    _searchEngine = searchEngines[value]!;
    notifyListeners();
  }

  void addBookmark(String url) {
    if (!bookmarks.contains(url)) {
      bookmarks.add(url);
      notifyListeners();
    }
  }
  void removeBookmark(String bookmark) {
    bookmarks.remove(bookmark);
    notifyListeners();
  }
}
