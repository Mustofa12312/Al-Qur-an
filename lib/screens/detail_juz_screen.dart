import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/juz.dart';
import '../globals.dart';

class DetailJuzScreen extends StatefulWidget {
  final Juz juz;

  const DetailJuzScreen({super.key, required this.juz});

  @override
  State<DetailJuzScreen> createState() => _DetailJuzScreenState();
}

class _DetailJuzScreenState extends State<DetailJuzScreen> {
  final ScrollController _scrollController = ScrollController();

  bool autoScroll = false;
  double scrollSpeed = 25;

  /// --------------------------
  /// AUTO SCROLL + STOP OTOMATIS
  /// --------------------------
  void startAutoScroll() async {
    setState(() => autoScroll = true);

    while (autoScroll && _scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));

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

  /// --------------------------
  /// MENU AUTO SCROLL
  /// --------------------------
  void _showAutoScrollMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF121931),
      context: context,
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
                  const SizedBox(height: 15),

                  /// BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9055FF),
                    ),
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
                    activeColor: const Color(0xFF9055FF),
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

  @override
  Widget build(BuildContext context) {
    final verses = widget.juz.verses;

    return Scaffold(
      backgroundColor: const Color(0xFF121931),

      /// --------------------------
      /// APP BAR
      /// --------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF121931),
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: SvgPicture.asset('assets/svgs/kembali.svg'),
            ),
            const SizedBox(width: 12),
            Text(
              "Juz ${widget.juz.juz}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            const Spacer(),

            /// ICON PLAY/PAUSE AUTO SCROLL
            IconButton(
              onPressed: () => _showAutoScrollMenu(context),
              icon: Icon(
                autoScroll ? Icons.pause_circle : Icons.play_circle_fill,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),

      /// --------------------------
      /// ISI HALAMAN (HEADER + AYAT)
      /// --------------------------
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: verses.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _header(widget.juz);
          return _ayatItem(verses[index - 1]);
        },
      ),
    );
  }

  /// --------------------------
  /// HEADER JUZ (ikut scroll)
  /// --------------------------
  Widget _header(Juz juz) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Column(
        children: [
          Text(
            "Juz ${juz.juz}",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${juz.totalVerses} Ayat",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// --------------------------
  /// ITEM AYAT
  /// --------------------------
  Widget _ayatItem(Verse ayah) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2849),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9055FF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "${ayah.numberInSurah ?? ayah.number}",
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
            ayah.arab,
            style: GoogleFonts.amiri(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 2,
            ),
            textAlign: TextAlign.right,
          ),

          /// TERJEMAH (menyesuaikan setting)
          if (showTranslation && ayah.translation.isNotEmpty)
            SelectableText(
              ayah.translation,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.justify,
            ),
        ],
      ),
    );
  }
}
