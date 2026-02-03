import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:frontend/features/publication/publication_list_screen.dart';
import 'package:frontend/features/statistic/screens/statistic_subject_screen.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import '../home/home_screen.dart';
import '../infographic/infographic_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'James Bond Menu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              _menuItem(
                icon: CupertinoIcons.bell,
                title: 'Notifikasi',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: CupertinoIcons.news,
                title: 'Berita Resmi Statistik',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: CupertinoIcons.calendar,
                title: 'Rencana Terbit',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: CupertinoIcons.photo,
                title: 'Infografis',
                onTap: () {
                  Navigator.pop(context);
                  switchTab(4); // Assuming switchTab is defined elsewhere
                },
              ),
              _menuItem(
                icon: CupertinoIcons.doc_text,
                title: 'Berita Kegiatan',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: CupertinoIcons.info,
                title: 'Tentang Kami',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

  late final List<Widget> _pages = [
    HomeScreen(onNavigate: switchTab),
    const StatisticSubjectScreen(),
    const Center(child: Text('Cari')),
    const PublicationListScreen(),
    const InfographicScreen(),
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
}
