import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class NewsTestScreen extends StatefulWidget {
  const NewsTestScreen({super.key});

  @override
  State<NewsTestScreen> createState() => _NewsTestScreenState();
}

class _NewsTestScreenState extends State<NewsTestScreen> {
  String status = 'Tekan tombol untuk GET /api/news';
  List news = [];

  Future<void> fetchNews() async {
    try {
      final api = ApiService();
      final res = await api.getNews();

      setState(() {
        news = res;
        status = 'Data berhasil dimuat';
      });
    } catch (e) {
      setState(() {
        status = 'ERROR: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GET News Test')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: ElevatedButton(
              onPressed: fetchNews,
              child: Text('GET News'),
            ),
          ),
          Expanded(
            child: news.isEmpty
                ? Center(child: Text(status))
                : ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final item = news[index];
                      return ListTile(title: Text(item['title']));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
