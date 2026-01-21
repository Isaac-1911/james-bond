import 'package:flutter/material.dart';
import '../api/api_service.dart';

class NewsTestScreen extends StatefulWidget {
  const NewsTestScreen({super.key});

  @override
  State<NewsTestScreen> createState() => _NewsTestScreenState();
}

class _NewsTestScreenState extends State<NewsTestScreen> {
  String result = 'Tekan tombol untuk GET /api/news';

  Future<void> fetchNews() async {
    try {
      final api = ApiService();
      final res = await api.getNews();

      setState(() {
        result = res.toString();
      });
    } catch (e) {
      setState(() {
        result = 'ERROR: $e';
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GET News Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchNews,
              child: const Text('GET NEWS'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

