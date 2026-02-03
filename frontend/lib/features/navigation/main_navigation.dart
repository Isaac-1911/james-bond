import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:frontend/features/publication/publication_list_screen.dart';
import 'package:frontend/features/statistic/screens/statistic_subject_screen.dart';
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
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.95), // Futuristic glassmorphism effect
              Colors.blue.shade50.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Enhanced drag handle with futuristic glow
              Container(
                width: 50,
                height: 6,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade300.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // Title for the menu, inspired by BPS (Badan Pusat Statistik) theme
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'James Bond Menu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Menu items with enhanced styling
              _menuItem(
                icon: Icons.notifications_none,
                title: 'Notifikasi',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: Icons.newspaper_outlined,
                title: 'Berita Resmi Statistik',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: Icons.calendar_today_outlined,
                title: 'Rencana Terbit',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: Icons.image_outlined,
                title: 'Infografis',
                onTap: () {
                  Navigator.pop(context);
                  switchTab(4); // Assuming switchTab is defined elsewhere
                },
              ),
              _menuItem(
                icon: Icons.article_outlined,
                title: 'Berita Kegiatan',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation logic here
                },
              ),
              _menuItem(
                icon: Icons.info_outline,
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
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.shade100.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 24, color: Colors.blue.shade700),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade900,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
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
          GButton(
            icon: Icons.home_outlined,
            text: 'Beranda',
          ),
          GButton(
            icon: Icons.table_chart_outlined,
            text: 'Tabel',
          ),
          GButton(
            icon: Icons.search_outlined,
            text: 'Cari',
          ),
          GButton(
            icon: Icons.menu_book_outlined,
            text: 'Publikasi',
          ),
          GButton(
            icon: Icons.menu_outlined,
            text: 'Lainnya',
          ),
        ],
      ),
    ),
  ),
);
  }
}
