import 'package:flutter/material.dart';
import 'package:frontend/features/publication/publication_list_screen.dart';
import 'package:frontend/features/statistic/screens/statistic_list_screen.dart';
import 'package:frontend/features/statistic/screens/statistic_subject_screen.dart';
import '../home/home_screen.dart';

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

  late final List<Widget> _pages = [
    HomeScreen(onNavigate: switchTab), 
    const StatisticSubjectScreen(),
    const Center(child: Text('Cari')),
    const PublicationListScreen(),
    const Center(child: Text('Lainnya')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // Background iOS-like
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Margin untuk kesan floating
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
            onTap: switchTab, // ✅ Pakai satu sumber kebenaran
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true, // Tampilkan label untuk kesan premium
            showUnselectedLabels: true,
            backgroundColor: Colors.transparent, // Background transparan untuk custom container
            elevation: 0, // Elevation dihapus karena sudah ada shadow di container
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