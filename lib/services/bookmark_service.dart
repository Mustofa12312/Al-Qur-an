import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookmarkService {
  static const String key = "BOOKMARK_LIST";

  /// Ambil semua bookmark
  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);

    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  /// Tambah bookmark
  static Future<void> addBookmark(Map<String, dynamic> bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> list = await getBookmarks();

    // Cegah duplikat
    bool exist = list.any(
      (b) => b["surah"] == bookmark["surah"] && b["ayat"] == bookmark["ayat"],
    );

    if (!exist) {
      list.add(bookmark);
      await prefs.setString(key, json.encode(list));
    }
  }

  /// Hapus bookmark
  static Future<void> removeBookmark(int surah, int ayat) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> list = await getBookmarks();

    list.removeWhere((b) => b["surah"] == surah && b["ayat"] == ayat);
    await prefs.setString(key, json.encode(list));
  }

  /// Cek apakah ayat dibookmark
  static Future<bool> isBookmarked(int surah, int ayat) async {
    List list = await getBookmarks();
    return list.any((b) => b["surah"] == surah && b["ayat"] == ayat);
  }
}
