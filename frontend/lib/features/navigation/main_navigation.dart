import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/features/news/news_list_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../home/home_screen.dart';
import '../statistic/screens/statistic_subject_screen.dart';
import '../publication/publication_list_screen.dart';
import '../infographic/infographic_screen.dart';
import '../release_plan/release_plan_screen.dart';
import 'package:frontend/features/common/simple_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  String _lainnyaPage = 'infografis';
  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void openLainnya(String page) {
    setState(() {
      _currentIndex = 4;
      _lainnyaPage = page;
    });
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Lainnya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                _menuItem(
                  icon: CupertinoIcons.calendar,
                  title: 'Rencana Terbit',
                  onTap: () {
                    Navigator.pop(context);
                    openLainnya('rencana-terbit');
                  },
                ),
                _menuItem(
                  icon: CupertinoIcons.photo,
                  title: 'Infografis',
                  onTap: () {
                    Navigator.pop(context);
                    openLainnya('infografis');
                  },
                ),
                _menuItem(
                  icon: CupertinoIcons.bell,
                  title: 'Notifikasi',
                  onTap: () {
                    Navigator.pop(context);
                    openLainnya('notifikasi');
                  },
                ),
                _menuItem(
                  icon: CupertinoIcons.news,
                  title: 'Berita Resmi Statistik',
                  onTap: () {
                    Navigator.pop(context);
                    openLainnya('brs');
                  },
                ),
                _menuItem(
                  icon: CupertinoIcons.doc_text,
                  title: 'Berita Kegiatan',
                  onTap: () {
                    Navigator.pop(context);
                    openLainnya('berita-kegiatan');
                  },
                ),
                _menuItem(
                  icon: CupertinoIcons.info,
                  title: 'Tentang Kami',
                  onTap: () {
                    Navigator.pop(context);
                    openLainnya('tentang-kami');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, size: 24, color: const Color(0xFF007AFF)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  List<Widget> get _pages => [
    HomeScreen(onNavigate: switchTab, onOpenLainnya: openLainnya,),
    const StatisticSubjectScreen(),
    const Center(child: Text('Cari')),
    const PublicationListScreen(),
    _buildLainnyaPage(), // TAB "LAINNYA"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              if (index == 4) {
                _showMoreMenu(context);
                return;
              }
              switchTab(index);
            },
            backgroundColor: Colors.transparent,
            color: Colors.grey.shade500,
            activeColor: const Color(0xFF007AFF),
            tabBackgroundColor: const Color(0xFF007AFF).withOpacity(0.1),
            gap: 4,
            padding: const EdgeInsets.all(12),
            tabs: const [
              GButton(icon: CupertinoIcons.home, text: 'Beranda'),
              GButton(icon: CupertinoIcons.chart_bar_alt_fill, text: 'Tabel'),
              GButton(icon: CupertinoIcons.search, text: 'Cari'),
              GButton(icon: CupertinoIcons.book, text: 'Publikasi'),
              GButton(icon: CupertinoIcons.line_horizontal_3, text: 'Lainnya'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLainnyaPage() {
    switch (_lainnyaPage) {
      case 'rencana-terbit':
        return const ReleasePlanScreen();

      case 'infografis':
        return const InfographicScreen();

      case 'notifikasi':
        return const SimplePage(title: 'Notifikasi');

      case 'brs':
        return const NewsListScreen();

      case 'berita-kegiatan':
        return const SimplePage(title: 'Berita Kegiatan');

      case 'tentang-kami':
        return const SimplePage(title: 'Tentang Kami');

      default:
        return const InfographicScreen();
    }
  }
}
