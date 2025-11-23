import 'package:alquran/globals.dart';
import 'package:alquran/tabs/Hijb_tab.dart';
import 'package:alquran/tabs/Page_tab.dart';
import 'package:alquran/tabs/surah_tab.dart';
import 'package:alquran/tabs/tasbih_tab.dart'; // <-- tambahkan
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // HALAMAN SESUAI BOTTOM NAVIGATION
  final List<Widget> pages = [
    const _HomeBody(), // → Quran (Tab Surah/Para/Hijb/Page)
    const HijbTab(), // → Tips (sementara hijb)
    const TasbihTab(), // → Tasbih
    const PageTab(), // → Doa (sementara page)
    const SurahTab(), // → Bookmark (sementara surah)
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

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: [
          _bottomBarItem(icon: 'assets/svgs/alquran-icon.svg', label: 'Quran'),
          _bottomBarItem(icon: 'assets/svgs/lampu.svg', label: 'Tips'),
          _bottomBarItem(icon: 'assets/svgs/sholat.svg', label: 'Tasbih'),
          _bottomBarItem(icon: 'assets/svgs/doa.svg', label: 'Doa'),
          _bottomBarItem(icon: 'assets/svgs/simpan.svg', label: 'Bookmark'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _bottomBarItem({
    required String icon,
    required String label,
  }) => BottomNavigationBarItem(
    icon: SvgPicture.asset(icon, color: textt),
    activeIcon: SvgPicture.asset(icon, color: Primary),
    label: label,
  );
}

// =============================
//   HEADER + TAB VIEW QURAN
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
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverToBoxAdapter(child: _GreetingSection()),
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Background,
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: TabBar(
                  unselectedLabelColor: textt,
                  labelColor: Colors.white,
                  indicatorColor: Primary,
                  indicatorWeight: 3,
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
          body: const TabBarView(
            children: [
              SurahTab(),
              // gunakan JuzListTab jika ada file-nya
              // atau gunakan ParaTab jika ingin 30 juz
              // sementara pakai SurahTab agar tidak error
              SurahTab(),
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
//  GREETING BAGIAN ATAS
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
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textt,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mustofa',
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
//       APP BAR MENU
// =============================
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Background,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              _showTranslationMenu(context);
            },
            icon: SvgPicture.asset('assets/svgs/menu-icon.svg'),
          ),
          const SizedBox(width: 24),
          Text(
            'Al Quran',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/svgs/cari.svg"),
          ),
        ],
      ),
    );
  }

  static void _showTranslationMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Gray,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                      setSheetState(() {
                        showTranslation = v;
                      });
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
