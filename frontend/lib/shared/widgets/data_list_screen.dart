import 'package:flutter/material.dart';

class DataListScreen<T> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function() fetchData;
  final String Function(T item) itemTitle;
  final void Function(BuildContext context, T item)? onItemTap;

  const DataListScreen({
    super.key,
    required this.title,
    required this.fetchData,
    required this.itemTitle,
    this.onItemTap
  });

  @override
  State<DataListScreen<T>> createState() => _DataListScreenState<T>();
}

class _DataListScreenState<T> extends State<DataListScreen<T>> {
  List<T> items = [];
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

                return ListTile(
  title: Text(widget.itemTitle(item)),
  onTap: widget.onItemTap == null
      ? null
      : () => widget.onItemTap!(context, item),
);
              },
            ),
    );
  }
}
