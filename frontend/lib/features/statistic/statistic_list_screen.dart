import 'package:flutter/material.dart';

class StatisticListScreen extends StatelessWidget {
  const StatisticListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistic Data')),
      body: const Center(child: Text('Statistic List')),
    );
  }
}
