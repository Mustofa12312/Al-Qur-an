import 'dart:convert';
import 'package:alquran/globals.dart';
import 'package:alquran/models/ayat.dart';
import 'package:alquran/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final int noSurah;
  const DetailScreen({super.key, required this.noSurah});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();

  bool autoScroll = false;
  double scrollSpeed = 25;

  // ======================================
  //            AUTO SCROLL SYSTEM
  // ======================================
  void startAutoScroll() async {
    setState(() => autoScroll = true);

    while (autoScroll && _scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 120));

      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        stopAutoScroll();
        break;
      }

      _scrollController.animateTo(
        _scrollController.offset + scrollSpeed,
        duration: const Duration(milliseconds: 120),
        curve: Curves.linear,
      );
    }
  }

  void stopAutoScroll() {
    setState(() => autoScroll = false);
  }

  void showScrollMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF10172D),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, update) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Auto Scroll",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // START / STOP BUTTON
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (autoScroll) {
                        stopAutoScroll();
                      } else {
                        startAutoScroll();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      autoScroll ? "Stop" : "Start",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // SPEED SLIDER
                  Text(
                    "Kecepatan Scroll",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  Slider(
                    min: 5,
                    max: 70,
                    divisions: 12,
                    activeColor: Primary,
                    value: scrollSpeed,
                    onChanged: (v) => update(() => scrollSpeed = v),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ======================================
  //           LOAD SURAH DATA
  // ======================================
  Future<Surah> loadSurah() async {
    String data = await rootBundle.loadString(
      "assets/datas/surah/${widget.noSurah}.json",
    );
    return Surah.fromJson(json.decode(data));
  }

  // ======================================
  //                UI
  // ======================================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      future: loadSurah(),
      builder: (context, s) {
        if (!s.hasData) {
          return Scaffold(backgroundColor: Background);
        }

        final surah = s.data!;

        return Scaffold(
          backgroundColor: Background,

          appBar: AppBar(
            backgroundColor: Background,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: SvgPicture.asset("assets/svgs/kembali.svg"),
                ),
                Text(
                  surah.namaLatin,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),

                // SEARCH
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/svgs/cari.svg"),
                ),

                // AUTO SCROLL
                IconButton(
                  onPressed: showScrollMenu,
                  icon: Icon(
                    autoScroll ? Icons.pause_circle : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          body: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: surah.ayat!.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) return buildHeader(surah);
              return buildAyat(surah.ayat![i - 1]);
            },
          ),
        );
      },
    );
  }

  // ======================================
  //           HEADER SURAH
  // ======================================
  Widget buildHeader(Surah surah) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 25),
      child: Column(
        children: [
          Text(
            surah.namaLatin,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            surah.arti,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            "${surah.tempatTurun.name} • ${surah.jumlahAyat} Ayat",
            style: GoogleFonts.poppins(color: textt),
          ),
          const SizedBox(height: 25),

          if (surah.nomor != 1 && surah.nomor != 9)
            SvgPicture.asset("assets/svgs/bismillah.svg", height: 60),
        ],
      ),
    );
  }

  // ======================================
  //           AYAT ITEM (PREMIUM)
  // ======================================
  Widget buildAyat(Ayat ayat) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TOP ICON BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Gray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // NOMOR AYAT
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "${ayat.nomor}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.share, color: Colors.white),
                const SizedBox(width: 16),
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.bookmark_add_outlined, color: Colors.white),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ============================
          //      TEKS ARAB (KFGQ)
          // ============================
          SelectableText(
            ayat.ar,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: "KFGQ", // FONT KHUSUS AL-QUR'AN
              fontSize: 32,
              height: 1.9,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // TERJEMAH
          if (showTranslation)
            SelectableText(
              ayat.idn,
              style: GoogleFonts.poppins(
                color: textt,
                fontSize: 14,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
