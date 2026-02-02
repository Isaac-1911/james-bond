import 'package:flutter/material.dart';

class InfographicListScreen extends StatelessWidget {
  const InfographicListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publikasi')),
      body: const Center(child: Text('Publication List')),
    );
  }
}
