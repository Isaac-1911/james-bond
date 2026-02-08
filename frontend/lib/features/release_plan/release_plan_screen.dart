import 'package:flutter/material.dart';
import 'package:frontend/models/release_plan.dart';
import 'package:frontend/core/services/api_service.dart';
import 'widgets/release_type_segment.dart';
import 'widgets/month_selector.dart';
import 'widgets/release_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReleasePlanScreen extends StatefulWidget {
  const ReleasePlanScreen({super.key});

  @override
  State<ReleasePlanScreen> createState() => _ReleasePlanScreenState();
}

class _ReleasePlanScreenState extends State<ReleasePlanScreen> {
  String _selectedType = 'publikasi';
  int _selectedMonth = DateTime.now().month;
  late Future<List<ReleasePlan>> _futureReleasePlans;
  final ValueNotifier<List<ReleasePlan>> _filteredPlans =
      ValueNotifier<List<ReleasePlan>>([]);
  final ValueNotifier<bool> _isFiltering = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _futureReleasePlans = ApiService().getReleasePlans();
    _futureReleasePlans.then((plans) {
      _applyFilters(plans);
    });
  }

  @override
  void dispose() {
    _filteredPlans.dispose();
    _isFiltering.dispose();
    super.dispose();
  }

  void _applyFilters(List<ReleasePlan> allPlans) {
    _isFiltering.value = true;

    Future.microtask(() {
      final filtered = allPlans.where((item) {
        return item.type == _selectedType &&
            item.plannedDate.month == _selectedMonth;
      }).toList();

      _filteredPlans.value = filtered;
      _isFiltering.value = false;
    });
  }

  void _onTypeChanged(String type) {
    if (_selectedType == type) return;

    setState(() {
      _selectedType = type;
    });

    _futureReleasePlans.then((plans) {
      _applyFilters(plans);
    });
  }

  void _onMonthChanged(int month) {
    if (_selectedMonth == month) return;

    setState(() {
      _selectedMonth = month;
    });

    _futureReleasePlans.then((plans) {
      _applyFilters(plans);
    });
  }

  String _getCurrentMonthName() {
    final monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return monthNames[_selectedMonth - 1];
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
            _buildFiltersSection(),
            const SizedBox(height: 20),
            _buildContent(),
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
            color: Colors.black.withOpacity(0.05),
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
              'Rencana Terbit',
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
                color: const Color(0xFF007AFF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF007AFF),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReleaseTypeSegment(
            selected: _selectedType,
            onChanged: _onTypeChanged,
          ),
          const SizedBox(height: 20),
          MonthSelector(
            selectedMonth: _selectedMonth,
            onChanged: _onMonthChanged,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withOpacity(0.1),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rencana Terbit $_selectedType',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF007AFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bulan ${_getCurrentMonthName()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: FutureBuilder<List<ReleasePlan>>(
        future: _futureReleasePlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          return _buildPlansList();
        },
      ),
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
            'Memuat rencana terbit...',
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
              color: const Color(0xFFFF3B30).withOpacity(0.1),
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
            'Gagal memuat data',
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
                _futureReleasePlans = ApiService().getReleasePlans();
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
              color: const Color(0xFF007AFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: Color(0xFF007AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tidak ada rencana terbit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada $_selectedType yang direncanakan terbit bulan ${_getCurrentMonthName()}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                final now = DateTime.now();
                setState(() {
                  _selectedMonth = now.month;
                });
                _futureReleasePlans.then((plans) {
                  _applyFilters(plans);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lihat Bulan Ini',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList() {
    return ValueListenableBuilder<List<ReleasePlan>>(
      valueListenable: _filteredPlans,
      builder: (context, filteredPlans, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isFiltering,
          builder: (context, isFiltering, child) {
            if (isFiltering) {
              return _buildFilteringState();
            }

            if (filteredPlans.isEmpty) {
              return _buildNoResultsState();
            }

            return _buildFilteredPlansList(filteredPlans);
          },
        );
      },
    );
  }

  Widget _buildFilteringState() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Color(0xFF007AFF),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF007AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada $_selectedType yang direncanakan terbit bulan ${_getCurrentMonthName()}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredPlansList(List<ReleasePlan> plans) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF34C759),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${plans.length} rencana terbit ditemukan',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF34C759),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: plans.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => ReleaseCard(
                item: plans[index],
              ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms),
            ),
          ),
        ],
      ),
    );
  }
}
