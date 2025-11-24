import 'dart:convert';
import 'package:alquran/globals.dart';
import 'package:alquran/models/surah.dart';
import 'package:alquran/screens/detail_screen.dart';
import 'package:alquran/screens/search_screen.dart';
import 'package:alquran/tabs/Hijb_tab.dart';
import 'package:alquran/tabs/Page_tab.dart';
import 'package:alquran/tabs/surah_tab.dart';
import 'package:alquran/tabs/tasbih_tab.dart';
import 'package:alquran/tabs/para_tab.dart';
import './detail_juz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // Halaman Bottom Navigation
  final List<Widget> pages = [
    const _HomeBody(), // Halaman Quran + Tabs
    const HijbTab(), // Tips (sementara Hijb)
    const TasbihTab(), // Tasbih
    const PageTab(), // Doa (sementara Page)
    const SurahTab(), // Bookmark (sementara Surah)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: const _HomeAppBar(),
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Gray,
        currentIndex: selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) => setState(() => selectedIndex = i),
        items: [
          _navItem('assets/svgs/alquran-icon.svg'),
          _navItem('assets/svgs/lampu.svg'),
          _navItem('assets/svgs/sholat.svg'),
          _navItem('assets/svgs/doa.svg'),
          _navItem('assets/svgs/simpan.svg'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(String icon) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(icon, color: textt),
      activeIcon: SvgPicture.asset(icon, color: Primary),
      label: "",
    );
  }
}

// =============================
//      TAB VIEW UTAMA QURAN
// =============================
class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            const SliverToBoxAdapter(child: _GreetingSection()),
            SliverAppBar(
              pinned: true,
              backgroundColor: Background,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: TabBar(
                  indicatorColor: Primary,
                  unselectedLabelColor: textt,
                  labelColor: Colors.white,
                  tabs: const [
                    Tab(child: Text("Surah")),
                    Tab(child: Text("Para")),
                    Tab(child: Text("Hijb")),
                    Tab(child: Text("Page")),
                  ],
                ),
              ),
            ),
          ],

          // TAB KONTEN
          body: const TabBarView(
            children: [
              SurahTab(), // Surah
              JuzListTab(), // FIX: ganti DetailJuzScreen() menjadi daftar Juz
              HijbTab(),
              PageTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================
//      GREETING HEADER
// =============================
class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Assalamualaikum",
          style: GoogleFonts.poppins(fontSize: 18, color: textt),
        ),
        const SizedBox(height: 4),
        Text(
          "Mustofa",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// =============================
//        APP BAR ATAS
// =============================
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Background,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            onPressed: () => _showTranslationMenu(context),
            icon: SvgPicture.asset("assets/svgs/menu-icon.svg"),
          ),
          const SizedBox(width: 24),
          Text(
            "Al Quran",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // SEARCH
          IconButton(
            onPressed: () async {
              String data = await rootBundle.loadString(
                'assets/datas/listsurah.json',
              );
              List<Surah> all = surahFromJson(data);

              // buka search
              final picked = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen(allSurah: all)),
              );

              if (picked != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(noSurah: picked),
                  ),
                );
              }
            },
            icon: SvgPicture.asset("assets/svgs/cari.svg"),
          ),
        ],
      ),
    );
  }

  // MENU TERJEMAH
  static void _showTranslationMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Gray,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tampilkan Terjemahan",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    activeColor: Primary,
                    value: showTranslation,
                    onChanged: (v) {
                      setSheet(() => showTranslation = v);
                      Navigator.pop(context);
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
