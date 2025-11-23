import 'dart:convert';
import 'package:alquran/globals.dart';
import 'package:alquran/models/ayat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../models/surah.dart';

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

  /// --------------------------
  /// AUTO SCROLL DENGAN STOP OTOMATIS
  /// --------------------------
  void startAutoScroll() async {
    setState(() => autoScroll = true);

    while (autoScroll && _scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));

      // Hentikan otomatis jika sudah sampai bawah
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        stopAutoScroll();
        break;
      }

      _scrollController.animateTo(
        _scrollController.offset + scrollSpeed,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    }
  }

  void stopAutoScroll() {
    setState(() => autoScroll = false);
  }

  void updateSpeed(double value) {
    setState(() => scrollSpeed = value);
  }

  Future<Surah> _getDetailSurah() async {
    String data = await rootBundle.loadString(
      "assets/datas/surah/${widget.noSurah}.json",
    );
    return Surah.fromJson(json.decode(data));
  }

  /// --------------------------
  /// MENU PENGATURAN AUTO SCROLL
  /// --------------------------
  void _showAutoScrollMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Gray,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Auto Scroll",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Primary),
                    onPressed: () {
                      Navigator.pop(context);
                      if (autoScroll) {
                        stopAutoScroll();
                      } else {
                        startAutoScroll();
                      }
                    },
                    child: Text(
                      autoScroll ? "Stop" : "Start",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Kecepatan Scroll",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  Slider(
                    min: 5,
                    max: 80,
                    divisions: 15,
                    activeColor: Primary,
                    value: scrollSpeed,
                    onChanged: (v) {
                      setSheet(() => scrollSpeed = v);
                      updateSpeed(v);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// --------------------------
  /// BUILD UI
  /// --------------------------
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      future: _getDetailSurah(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(backgroundColor: Background);
        }

        Surah surah = snapshot.data!;

        return Scaffold(
          backgroundColor: Background,
          appBar: _AppBar(
            context: context,
            surah: surah,
            autoScroll: autoScroll,
            onAutoScrollPressed: () => _showAutoScrollMenu(context),
          ),

          /// --------------------------
          /// SEMUA KONTEN DALAM LISTVIEW
          /// HEADER + AYAT IKUT SCROLL
          /// --------------------------
          body: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: surah.ayat!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _headerSurah(surah);
              return _ayatItem(ayat: surah.ayat![index - 1]);
            },
          ),
        );
      },
    );
  }

  /// --------------------------
  /// HEADER SURAH (Ikut scroll)
  /// --------------------------
  Widget _headerSurah(Surah surah) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Column(
        children: [
          Text(
            surah.namaLatin,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            surah.arti,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${surah.tempatTurun.name} • ${surah.jumlahAyat} Ayat",
            style: GoogleFonts.poppins(color: textt, fontSize: 14),
          ),
          const SizedBox(height: 20),

          if (surah.nomor != 1 && surah.nomor != 9)
            SvgPicture.asset("assets/svgs/bismillah.svg"),
        ],
      ),
    );
  }

  /// --------------------------
  /// ITEM AYAT
  /// --------------------------
  Widget _ayatItem({required Ayat ayat}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: Gray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: Primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "${ayat.nomor}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.share, color: Colors.white),
                const SizedBox(width: 16),
                const Icon(
                  Icons.play_circle_outline_outlined,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.bookmark_add_outlined, color: Colors.white),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// ARAB
          SelectableText(
            ayat.ar,
            style: GoogleFonts.amiri(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 2,
            ),
            textAlign: TextAlign.right,
          ),

          /// TERJEMAH
          if (showTranslation)
            SelectableText(
              ayat.idn,
              style: GoogleFonts.poppins(color: textt, fontSize: 14),
              textAlign: TextAlign.justify,
            ),
        ],
      ),
    );
  }
}

/// --------------------------
/// APP BAR
/// --------------------------
AppBar _AppBar({
  required BuildContext context,
  required Surah surah,
  required bool autoScroll,
  required Function onAutoScrollPressed,
}) {
  return AppBar(
    backgroundColor: Background,
    elevation: 0,
    title: Row(
      children: [
        IconButton(
          onPressed: (() => Navigator.of(context).pop()),
          icon: SvgPicture.asset('assets/svgs/kembali.svg'),
        ),
        const SizedBox(width: 20),
        Text(
          surah.namaLatin,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),

        /// SEARCH ICON
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/svgs/cari.svg"),
        ),

        /// AUTO SCROLL ICON
        IconButton(
          onPressed: () => onAutoScrollPressed(),
          icon: Icon(
            autoScroll ? Icons.pause_circle_filled : Icons.play_circle_fill,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    ),
  );
}
