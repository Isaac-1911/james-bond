import 'package:flutter/material.dart';
import 'package:frontend/core/services/api_service.dart';

class StatisticTestScreen extends StatefulWidget {
  const StatisticTestScreen({super.key});

  @override
  State<StatisticTestScreen> createState() => _StatisticTestScreenState();
}

class _StatisticTestScreenState extends State<StatisticTestScreen> {
  String status = 'Tekan tombol untuk GET /api/statistic';
  List statistic = [];

  Future<void> fetchStatistic() async {
    try {
      final api = ApiService();
      final res = await api.getStatistic();
      setState(() {
        statistic = res;
        status = 'Data Loaded!';
      });
    } catch (e) {
      setState(() {
        status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get Statistic Data'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(16.0),
            child: ElevatedButton(
              onPressed: fetchStatistic,
              child: Text('GET Statistic'),
            ),
          ),
          Expanded(
            child: statistic.isEmpty
                ? Center(child: Text(status))
                : ListView.builder(
                    itemCount: statistic.length,
                    itemBuilder: (context, index) {
                      final item = statistic[index];
                      return ListTile(title: Text(item['title']));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
