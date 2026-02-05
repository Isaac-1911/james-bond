import 'package:flutter/material.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'package:frontend/models/release_plan.dart';
import 'package:frontend/core/services/api_service.dart';

import 'widgets/release_type_segment.dart';
import 'widgets/month_selector.dart';
import 'widgets/release_card.dart';

class ReleasePlanScreen extends StatefulWidget {
  const ReleasePlanScreen({super.key});

  @override
  State<ReleasePlanScreen> createState() => _ReleasePlanScreenState();
}

class _ReleasePlanScreenState extends State<ReleasePlanScreen> {
  String selectedType = 'publikasi';
  int selectedMonth = DateTime.now().month;

  late Future<List<ReleasePlan>> _futureReleasePlans;

  @override
  void initState() {
    super.initState();
    _futureReleasePlans = ApiService().getReleasePlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          'Rencana Terbit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007AFF),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007AFF)),
        //   onPressed: () => HomeScreen(onNavigate: swi),
        // ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ReleaseTypeSegment(
            selected: selectedType,
            onChanged: (v) {
              setState(() {
                selectedType = v;
              });
            },
          ),
          const SizedBox(height: 20),
          MonthSelector(
            selectedMonth: selectedMonth,
            onChanged: (m) {
              setState(() {
                selectedMonth = m;
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<ReleasePlan>>(
              future: _futureReleasePlans,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF007AFF),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'Gagal memuat data',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                final data = snapshot.data!
                    .where(
                      (item) =>
                          item.type == selectedType &&
                          item.plannedDate.month == selectedMonth,
                    )
                    .toList();

                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada rencana terbit',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return ReleaseCard(item: data[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
