import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah.dart';

class SearchScreen extends StatefulWidget {
  final List<Surah> allSurah;

  const SearchScreen({super.key, required this.allSurah});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Surah> results = [];
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1324),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1324),
        elevation: 0,
        title: TextField(
          autofocus: true,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Cari Surah...",
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value.trim().toLowerCase();
              results = widget.allSurah.where((s) {
                return s.namaLatin.toLowerCase().contains(query) ||
                    s.nama.toLowerCase().contains(query) ||
                    s.nomor.toString() == query;
              }).toList();
            });
          },
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Text(
                query.isEmpty ? "Cari Surah..." : "Tidak ditemukan",
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final surah = results[index];
                return ListTile(
                  title: Text(
                    surah.namaLatin,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  subtitle: Text(
                    surah.nama,
                    style: GoogleFonts.amiri(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, surah.nomor);
                  },
                );
              },
            ),
    );
  }
}
