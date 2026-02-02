import 'package:flutter/material.dart';
import '../../../core/services/statistic_api_service.dart';
import '../../../models/statistic_subsubject.dart';
import 'statistic_table_list_screen.dart';

class StatisticSubsubjectScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const StatisticSubsubjectScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<StatisticSubsubjectScreen> createState() => _StatisticSubsubjectScreenState();
}

class _StatisticSubsubjectScreenState extends State<StatisticSubsubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subjectName)),
      body: FutureBuilder<List<StatisticSubsubject>>(
        future: StatisticApiService.getSubsubjects(widget.subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat subjek turunan'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('Data kosong'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                title: Text(item.name ?? '-'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StatisticTableListScreen(
                        subsubjectId: item.id!,
                        title: item.name ?? '',
                      
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
