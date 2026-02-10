import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';
import '../../models/infographic.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/helpers/download_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InfographicScreen extends StatefulWidget {
  const InfographicScreen({super.key});

  @override
  State<InfographicScreen> createState() => _InfographicScreenState();
}

class _InfographicScreenState extends State<InfographicScreen> {
  late final Future<List<Infographic>> _infographicsFuture;
  final ValueNotifier<List<Infographic>> _infographics =
      ValueNotifier<List<Infographic>>([]);

  @override
  void initState() {
    super.initState();
    _infographicsFuture = ApiService().getInfographic();
    _infographicsFuture.then((infographics) {
      _infographics.value = infographics;
    });
  }

  @override
  void dispose() {
    _infographics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 20),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GestureDetector(
            //   onTap: () => Navigator.pop(context),
            //   child: Container(
            //     width: 44,
            //     height: 44,
            //     decoration: BoxDecoration(
            //       color: Colors.grey.shade100,
            //       shape: BoxShape.circle,
            //     ),
            //     child: const Icon(
            //       Icons.arrow_back_rounded,
            //       color: Color(0xFF007AFF),
            //       size: 22,
            //     ),
            //   ),
            // ),
            const Text(
              'Infografis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.image_rounded,
                color: Color(0xFF007AFF),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FutureBuilder<List<Infographic>>(
      future: _infographicsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState();
        }

        final data = snapshot.data ?? [];

        if (data.isEmpty) {
          return _buildEmptyState();
        }

        return _buildInfographicsList();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF007AFF),
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat infografis...',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFFF3B30),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Gagal memuat infografis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba lagi nanti atau periksa koneksi internet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton(
              onPressed: () => setState(() {
                _infographicsFuture = ApiService().getInfographic();
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.image_not_supported_rounded,
              color: Color(0xFF007AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada infografis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Infografis akan segera tersedia',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfographicsList() {
    return ValueListenableBuilder<List<Infographic>>(
      valueListenable: _infographics,
      builder: (context, infographics, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF007AFF),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${infographics.length} infografis tersedia',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF007AFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: infographics.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) => InfographicCard(
                    infographic: infographics[index],
                  ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InfographicCard extends StatefulWidget {
  final Infographic infographic;

  const InfographicCard({super.key, required this.infographic});

  @override
  State<InfographicCard> createState() => _InfographicCardState();
}

class _InfographicCardState extends State<InfographicCard> {
  bool _isDownloading = false;
  bool _isSharing = false;

  String get _imageUrl =>
      '${ApiConfig.storageUrl}/${widget.infographic.imageUrl}';
  String get _filename =>
      '${widget.infographic.title.replaceAll(' ', '_').toLowerCase()}.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.infographic.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
              ),
            ),
            const SizedBox(height: 12),
            _buildImage(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 12),
            if (widget.infographic.description != null) ...[
              Text(
                widget.infographic.description!,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: CachedNetworkImage(
            imageUrl: _imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF007AFF),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.download_rounded,
            label: 'Unduh',
            isLoading: _isDownloading,
            onTap: _downloadInfographic,
            color: const Color(0xFF34C759),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share_rounded,
            label: 'Bagikan',
            isLoading: _isSharing,
            onTap: _shareInfographic,
            color: const Color(0xFF007AFF),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isLoading,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20, color: color),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _downloadInfographic() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      await DownloadHelper.downloadImage(
        imageUrl: _imageUrl,
        fileName: _filename,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF34C759),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Infografis berhasil diunduh',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFF3B30),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Gagal mengunduh infografis',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<void> _shareInfographic() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final File file = await DownloadHelper.downloadImage(
        imageUrl: _imageUrl,
        fileName: _filename,
      );

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: widget.infographic.title),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFF3B30),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Gagal membagikan infografis',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }
}
