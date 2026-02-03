import 'package:flutter/material.dart';
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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                _menuItem(
                  icon: Icons.notifications_none,
                  title: 'Notifikasi',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _menuItem(
                  icon: Icons.newspaper_outlined,
                  title: 'Berita Resmi Statistik',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _menuItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Rencana Terbit',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _menuItem(
                  icon: Icons.image_outlined,
                  title: 'Infografis',
                  onTap: () {
                    Navigator.pop(context);
                    switchTab(4);
                  },
                ),
                _menuItem(
                  icon: Icons.article_outlined,
                  title: 'Berita Kegiatan',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _menuItem(
                  icon: Icons.info_outline,
                  title: 'Tentang Kami',
                  onTap: () {
                    Navigator.pop(context);
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
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
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
      backgroundColor: const Color(0xFFF2F2F7), // Background iOS-like
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ), // Margin untuk kesan floating
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24), // Rounded lebih besar
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 4) {
                _showMoreMenu(context);
                return;
              }
              switchTab(index);
            },

            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true, // Tampilkan label untuk kesan premium
            showUnselectedLabels: true,
            backgroundColor: Colors
                .transparent, // Background transparan untuk custom container
            elevation:
                0, // Elevation dihapus karena sudah ada shadow di container
            selectedItemColor: const Color(0xFF007AFF), // Warna biru iOS
            unselectedItemColor: Colors.grey.shade500,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF007AFF),
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 28), // Icon lebih besar
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.table_chart_outlined, size: 28),
                label: 'Tabel',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 28),
                label: 'Cari',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined, size: 28),
                label: 'Publikasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu, size: 28),
                label: 'Lainnya',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
