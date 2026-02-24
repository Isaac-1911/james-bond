import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/features/activity_news/activity_news_screen.dart';
import 'package:frontend/features/news/news_list_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/core/services/api_service.dart';
import '../home/home_screen.dart';
import '../statistic/screens/statistic_subject_screen.dart';
import '../publication/publication_list_screen.dart';
import '../infographic/infographic_screen.dart';
import '../release_plan/release_plan_screen.dart';
import '../search/global_search_screen.dart';
import '../../shared/widgets/onboarding_popup.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  String _lainnyaPage = 'infografis';

  List<String> _onboardingImages = [];
  // bool _loadingOnboarding = true;
  bool _hasShownPopupThisSession = false;

  // Variable untuk menangani tombol back
  DateTime? _lastPressedAt;

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadOnboarding();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _showOnboardingIfNeeded() {
    if (_hasShownPopupThisSession) return;
    if (_onboardingImages.isEmpty) return;

    _hasShownPopupThisSession = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OnboardingPopup(
        images: _onboardingImages,
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _loadOnboarding() async {
    try {
      final banners = await ApiService().getOnboardingBanners();

      if (!mounted) return;

      setState(() {
        _onboardingImages = banners.map((e) => e.imageUrl).toList();
      });
    } catch (e) {
      debugPrint('ONBOARDING ERROR: $e');
    } finally {
      // _loadingOnboarding = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOnboardingIfNeeded();
      });
    }
  }

  void openLainnya(String page) {
    setState(() {
      _currentIndex = 4;
      _lainnyaPage = page;
    });
  }

  Future<void> _openTentangKami() async {
    final Uri url = Uri.parse(
      'https://ppid.bps.go.id/app/konten/3511/Profil-BPS.html',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka halaman Tentang Kami');
    }
  }

  Future<void> _openInfoDeveloper() async {
    final Uri url = Uri.parse(
      'https://www.linkedin.com/in/muhammad-anwar-thoriq-702876321',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka halaman Info Developer');
    }
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
                  onTap: () async {
                    Navigator.pop(context);
                    await _openTentangKami();
                  },
                ),
                _menuItem(
                  icon: CupertinoIcons.chevron_left_slash_chevron_right,
                  title: 'Info Developer',
                  onTap: () async {
                    Navigator.pop(context);
                    await _openInfoDeveloper();
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
    HomeScreen(onNavigate: switchTab, onOpenLainnya: openLainnya),
    const StatisticSubjectScreen(),
    const GlobalSearchScreen(),
    const PublicationListScreen(),
    _buildLainnyaPage(),
  ];

  // Fungsi untuk menangani tombol back dengan PopScope
  Future<bool> _onBackPressed() async {
    // Cek apakah user menekan tombol back dalam waktu 2 detik
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      // Set waktu terakhir tombol back ditekan
      _lastPressedAt = DateTime.now();

      // Tampilkan snackbar notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tekan sekali lagi untuk keluar aplikasi',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.all(20),
        ),
      );

      return false; // Jangan keluar aplikasi
    }

    return true; // Keluar aplikasi karena sudah menekan 2 kali
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Kita kontrol sendiri kapan bisa pop
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        // Handle back press
        final shouldPop = await _onBackPressed();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop(result);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                tabBackgroundColor: const Color(
                  0xFF007AFF,
                ).withValues(alpha: 0.1),
                gap: 4,
                padding: const EdgeInsets.all(12),
                tabs: const [
                  GButton(icon: CupertinoIcons.home, text: 'Beranda'),
                  GButton(
                    icon: CupertinoIcons.chart_bar_alt_fill,
                    text: 'Tabel',
                  ),
                  GButton(icon: CupertinoIcons.search, text: 'Cari'),
                  GButton(icon: CupertinoIcons.book, text: 'Publikasi'),
                  GButton(
                    icon: CupertinoIcons.line_horizontal_3,
                    text: 'Lainnya',
                  ),
                ],
              ),
            ),
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
      case 'brs':
        return const NewsListScreen();
      case 'berita-kegiatan':
        return const ActivityNewsScreen();
      default:
        return const InfographicScreen();
    }
  }
}
