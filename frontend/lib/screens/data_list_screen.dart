import 'package:flutter/material.dart';
import 'package:frontend/models/publication.dart';

class DataListScreen extends StatefulWidget {
  final String title;
  final Future<List<Publication>> Function() fetchData;

  const DataListScreen({
    super.key,
    required this.title,
    required this.fetchData,
  });

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  List<Publication> items = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final data = await widget.fetchData();
      setState(() {
        items = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('Error: $error'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(title: Text(item.title ?? 'No title'));
              },
            ),
    );
  }
}
