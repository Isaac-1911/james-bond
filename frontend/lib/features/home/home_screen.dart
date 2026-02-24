import 'dart:core';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/models/publication.dart';
import 'package:flutter/cupertino.dart';
import '../notification/notification_screen.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';
import '../../models/news.dart';
import '../../models/infographic.dart';
import '../../models/activity_news.dart';
import '../news/news_detail_screen.dart';
import '../publication/publication_detail_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'widgets/news_carousel_shimmer.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  final Function(String) onOpenLainnya;
  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onOpenLainnya,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<News> _newsList = [];
  bool _isLoadingNews = true;

  final List<Publication> _publications = [];
  bool _isLoadingPublication = true;

  int _currentCarouselIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Future<List<Infographic>> _infographicFuture;
  late Future<List<ActivityNews>> _activityNewsFuture;

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _fetchPublications();
    _activityNewsFuture = ApiService().getActivityNews();
    _infographicFuture = ApiService().getInfographic();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  Future<void> _fetchNews() async {
    try {
      final news = await _apiService.getNews();
      setState(() {
        _newsList = news;
        _isLoadingNews = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingNews = false;
      });
    }
  }

  Future<void> _fetchPublications() async {
    try {
      final result = await _apiService.getPublications(page: 1, limit: 3);
      final List<Publication> items = result['items'] ?? [];

      if (!mounted) return;

      setState(() {
        _publications
          ..clear()
          ..addAll(items);

        _isLoadingPublication = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingPublication = false;
      });

      debugPrint('❌ fetch publications error: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600; // Breakpoint untuk tablet

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF667EEA),
        foregroundColor: Colors.white,
        elevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          _openFeedbackModal(context);
        },
        label: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.rocket_launch_outlined, size: 20),
            ),

            // const SizedBox(width: 12),
            // const Text(
            //   'Kirim Feedback',
            //   style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //     letterSpacing: 0.5,
            //   ),
            // ),
          ],
        ),
      ),

      backgroundColor: const Color(0xFFF2F2F7),
      body: RefreshIndicator(
        color: const Color(0xFF007AFF),
        onRefresh: _refreshAll,
        child: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'James Bond',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1D1D1F),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Notification Button
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const NotificationScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        const Center(
                                          child: Icon(
                                            CupertinoIcons.bell,
                                            color: Color(0xFF007AFF),
                                            size: 22,
                                          ),
                                        ),
                                        // Notification Badge
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFF3B30),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Profile Avatar
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Progress/Status Indicator
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF007AFF),
                                const Color(0xFF007AFF).withValues(alpha: 0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= CAROUSEL NEWS =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const Text(
                        //       'Berita Terbaru',
                        //       style: TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.w700,
                        //         color: Color(0xFF1D1D1F),
                        //       ),
                        //     ),
                        //     if (_newsList.isNotEmpty && !_isLoadingNews)
                        //       GestureDetector(
                        //         onTap: () => widget.onOpenLainnya('brs'),
                        //         child: const Text(
                        //           'Lihat Semua',
                        //           style: TextStyle(
                        //             fontSize: 14,
                        //             color: Color(0xFF007AFF),
                        //             fontWeight: FontWeight.w600,
                        //           ),
                        //         ),
                        //       ),
                        //   ],
                        // ),
                        // const SizedBox(height: 16),

                        // Carousel Container
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _isLoadingNews
                                ? const NewsCarouselShimmer()
                                : _newsList.isEmpty
                                ? _buildEmptyNewsState()
                                : CarouselSlider.builder(
                                    itemCount: _newsList.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return _buildNewsCarouselItem(
                                        _newsList[index],
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 200,
                                      autoPlay: true,
                                      enlargeCenterPage: true,
                                      autoPlayInterval: const Duration(
                                        seconds: 5,
                                      ),
                                      autoPlayAnimationDuration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      pauseAutoPlayOnTouch: true,
                                      viewportFraction: 1.0,
                                      onPageChanged: (index, reason) {
                                        if (mounted) {
                                          setState(() {
                                            _currentCarouselIndex = index;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (!_isLoadingNews && _newsList.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _newsList.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  // Optional: Add manual navigation if needed
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: _currentCarouselIndex == index
                                      ? 24
                                      : 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: _currentCarouselIndex == index
                                        ? const Color(0xFF007AFF)
                                        : Colors.grey.shade300,
                                    boxShadow: _currentCarouselIndex == index
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF007AFF,
                                              ).withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ================= QUICK MENU =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: isTablet ? 2 : 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      children: [
                        _QuickMenuItem(
                          icon: Icons.book,
                          label: 'Publikasi',
                          color: const Color(0xFF4E73DF),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4E73DF), Color(0xFF224ABE)],
                          ),
                          onTap: () {
                            widget.onNavigate(3);
                          },
                        ),
                        _QuickMenuItem(
                          icon: Icons.table_chart,
                          label: 'Tabel',
                          color: const Color(0xFF1CC88A),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1CC88A), Color(0xFF13855C)],
                          ),
                          onTap: () {
                            widget.onNavigate(1);
                          },
                        ),
                        _QuickMenuItem(
                          icon: Icons.image,
                          label: 'Infografis',
                          color: const Color(0xFFF6C23E),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF6C23E), Color(0xFFDDA20A)],
                          ),
                          onTap: () {
                            widget.onOpenLainnya('infografis');
                          },
                        ),
                        _QuickMenuItem(
                          icon: Icons.article,
                          label: 'BRS',
                          color: const Color(0xFFE74A3B),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE74A3B), Color(0xFFC0281B)],
                          ),
                          onTap: () {
                            widget.onOpenLainnya('brs');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ================= SEARCH BAR =================
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(
                  //         20,
                  //       ), // Rounded lebih besar
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withValues(alpha: 0.1),
                  //           blurRadius: 10,
                  //           offset: const Offset(0, 4),
                  //         ),
                  //       ],
                  //     ),
                  //     child: TextField(
                  //       decoration: InputDecoration(
                  //         hintText: 'Cari data di sini',
                  //         prefixIcon: const Icon(
                  //           Icons.search,
                  //           color: Color(0xFF007AFF),
                  //         ),
                  //         filled: true,
                  //         fillColor: Colors.white,
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(20),
                  //           borderSide: BorderSide.none,
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(20),
                  //           borderSide: const BorderSide(
                  //             color: Color(0xFF007AFF),
                  //             width: 2,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(height: 28),

                  // ================= PUBLIKASI TERBARU =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Publikasi Terbaru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1F),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onNavigate(3);
                          },
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // List publikasi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        if (_isLoadingPublication)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_publications.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('Belum ada publikasi'),
                          )
                        else
                          ..._publications.map((pub) {
                            return _buildPublicationItem(context, pub);
                          }),

                        const SizedBox(height: 24),

                        // ==========================
                        // Infografis Terbaru
                        // ==========================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Infografis Terbaru',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onOpenLainnya('infografis');
                              },
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  color: Color(0xFF007AFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 260, // tinggi card (penting)
                          child: FutureBuilder(
                            future: _infographicFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Center(
                                  child: Text('Gagal memuat infografis'),
                                );
                              }

                              final items = snapshot.data!;

                              // ambil 5 terbaru
                              final latest = items.take(5).toList();

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: latest.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final item = latest[index];
                                  return _InfographicHomeCard(
                                    imageUrl:
                                        '${ApiConfig.storageUrl}/${item.imageUrl}',
                                    onTap: () {
                                      widget.onOpenLainnya('infografis');
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        // ==========================
                        // Activity News
                        // ==========================
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Berita Kegiatan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onOpenLainnya('berita-kegiatan');
                              },
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  color: Color(0xFF007AFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 200, // tinggi card (penting)
                          child: FutureBuilder(
                            future: _activityNewsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Center(
                                  child: Text('Gagal memuat infografis'),
                                );
                              }

                              final items = snapshot.data!;

                              // ambil 5 terbaru
                              final latest = items.take(5).toList();

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: latest.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final item = latest[index];
                                  return _InfographicHomeCard(
                                    imageUrl: item.imageUrl ?? '',
                                    onTap: () {
                                      widget.onOpenLainnya('berita-kegiatan');
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ================= FOOTER =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white.withValues(alpha: 0.8),
                    child: const Center(
                      child: Text(
                        '© 2026 Badan Pusat Statistik. All rights reserved.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyNewsState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, color: Colors.grey, size: 40),
            SizedBox(height: 12),
            Text(
              'Belum ada berita',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCarouselItem(News news) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              news.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  news.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshAll() async {
    if (!mounted) return;

    setState(() {
      _isLoadingNews = true;
      _isLoadingPublication = true;

      _infographicFuture = _apiService.getInfographic();
      _activityNewsFuture = _apiService.getActivityNews();
    });

    await Future.wait([_fetchNews(), _fetchPublications()]);
  }

  void _openFeedbackModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _FeedbackSheet();
      },
    );
  }
}

// ===========================================================
// ====================== WIDGET KECIL =======================
// ===========================================================

class _QuickMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Gradient gradient;

  const _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.gradient,
  });

  @override
  State<_QuickMenuItem> createState() => _QuickMenuItemState();
}

class _QuickMenuItemState extends State<_QuickMenuItem>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 18),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildPublicationItem(BuildContext context, Publication pub) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PublicationDetailScreen(publication: pub),
        ),
      );
    },
    child: Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // ================= COVER =================
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 48,
                height: 64,
                child: pub.coverUrl != null
                    ? Image.network(
                        pub.coverUrl!.startsWith('http')
                            ? pub.coverUrl!
                            : '${ApiConfig.storageUrl}/${pub.coverUrl}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return _pdfFallback();
                        },
                      )
                    : _pdfFallback(),
              ),
            ),

            const SizedBox(width: 16),

            // ================= TEXT =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pub.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (pub.releaseDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        pub.releaseDate!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _pdfFallback() {
  return Container(
    color: Colors.red.shade50,
    child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
  );
}

class _InfographicHomeCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _InfographicHomeCard({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 3 / 4, // mirip screenshot BPS
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(color: Colors.grey.shade200);
            },
          ),
        ),
      ),
    );
  }
}

class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet();

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  int _rating = 0;
  String? _job;
  final Set<String> _tags = {};
  final TextEditingController _controller = TextEditingController();

  final List<String> _jobs = [
    'Pelajar / Mahasiswa',
    'ASN',
    'Swasta',
    'Wiraswasta',
    'Lainnya',
  ];

  final List<String> _tagsList = [
    'Tampilan',
    'Pencarian Data',
    'Kelengkapan Data',
    'Metadata',
    'Fitur',
    'Performa Akses',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kirim Feedback',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1D1F),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Color(0xFF6E6E73),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bantu kami meningkatkan menjadi lebih baik😉',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6E6E73),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Seberapa puas Anda dengan aplikasi James Bond?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 400) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(3, (index) {
                                    return _buildRatingItem(index);
                                  }),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(2, (index) {
                                    return _buildRatingItem(index + 3);
                                  }),
                                ),
                              ],
                            );
                          } else if (constraints.maxWidth < 350) {
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: List.generate(5, (index) {
                                return _buildRatingItem(index);
                              }),
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(5, (index) {
                                return _buildRatingItem(index);
                              }),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Pekerjaan Terakhir',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            value: _job,
                            items: _jobs
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _job = v),
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                              padding: EdgeInsets.only(left: 16, right: 8),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              iconSize: 24,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                            ),
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Pilih Pekerjaan',
                                style: TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Apa yang dapat kami tingkatkan?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _tagsList.map((tag) {
                          final selected = _tags.contains(tag);
                          return FilterChip(
                            label: Text(
                              tag,
                              style: TextStyle(
                                color: selected
                                    ? const Color(0xFF007AFF)
                                    : const Color(0xFF1D1D1F),
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: selected,
                            onSelected: (_) {
                              setState(() {
                                selected ? _tags.remove(tag) : _tags.add(tag);
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(
                              0xFF007AFF,
                            ).withValues(alpha: 0.1),
                            checkmarkColor: const Color(0xFF007AFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: selected
                                    ? const Color(0xFF007AFF)
                                    : Colors.grey.shade300,
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Saran dan Masukkan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: 5,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: 'Tuliskan saran Anda...',
                            hintStyle: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _rating == 0
                                ? const Color(0xFFC7C7CC)
                                : const Color(0xFF007AFF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _rating == 0
                              ? null
                              : () async {
                                  try {
                                    await ApiService().submitFeedback(
                                      rating: _rating,
                                      job: _job,
                                      tags: _tags.toList(),
                                      message: _controller.text,
                                    );

                                    if (!context.mounted) return;

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color(
                                          0xFF34C759,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        content: const Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Terima kasih atas feedback Anda',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color(
                                          0xFFFF3B30,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        content: const Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Gagal mengirim feedback',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: const Text(
                            'Kirim Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingItem(int index) {
    final emojis = ['😞', '😐', '🙂', '😄', '😍'];
    final labels = ['Buruk', 'Cukup', 'Baik', 'Sangat Baik', 'Luar Biasa'];
    final isSelected = _rating == index + 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 350 ? 72.0 : 64.0;

        return GestureDetector(
          onTap: () => setState(() => _rating = index + 1),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF007AFF).withValues(alpha: 0.08)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF007AFF)
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(emojis[index], style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: constraints.maxWidth < 350 ? 11 : 12,
                    color: isSelected
                        ? const Color(0xFF007AFF)
                        : const Color(0xFF6E6E73),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
