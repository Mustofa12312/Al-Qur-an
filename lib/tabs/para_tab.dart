import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/juz.dart';
import '../screens/detail_juz_screen.dart';

class ParaTab extends StatelessWidget {
  final int juzNumber;

  const ParaTab({super.key, required this.juzNumber});

  Future<Juz> _loadJuz(int juz) async {
    final String response = await rootBundle.loadString(
      "assets/datas/juz/$juz.json",
    );
    return Juz.fromJson(json.decode(response)["data"]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Juz>(
      future: _loadJuz(juzNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Data tidak ditemukan."));
        }

        final juzData = snapshot.data!;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailJuzScreen(juz: juzData),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      juzData.juz.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Juz ${juzData.juz}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Dari: ${juzData.juzStartInfo} → ${juzData.juzEndInfo}",
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${juzData.totalVerses} ayat",
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
