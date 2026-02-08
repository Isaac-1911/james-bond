import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class InfographicTestScreen extends StatefulWidget {
  const InfographicTestScreen({super.key});

  @override
  State<InfographicTestScreen> createState() => _InfographicTestScreenState();
}

class _InfographicTestScreenState extends State<InfographicTestScreen> {
  String status = 'Tekan tombol untuk GET /api/infographic';
  List infographic = [];

  Future<void> fetchInfographic() async {
    try {
      final api = ApiService();
      final res = await api.getInfographic();

      setState(() {
        infographic = res;
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
      appBar: AppBar(title: Text('Infographic GET Test'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: ElevatedButton(
              onPressed: fetchInfographic,
              child: Text('GET Infographic'),
            ),
          ),
          Expanded(
            child: infographic.isEmpty
                ? Center(child: Text(status))
                : ListView.builder(
                    itemCount: infographic.length,
                    itemBuilder: (context, index) {
                      final item = infographic[index];
                      return ListTile(title: Text(item['title']));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
