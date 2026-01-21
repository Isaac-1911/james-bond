import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/news_test_screen.dart';
import 'api/api_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // cek base url
  debugPrint("API BASE URL: ${ApiConfig.baseUrl}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NewsTestScreen(),
    );
  }
}

class HomeTestScreen extends StatelessWidget {
  const HomeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('James Bond Flutter'),
      ),
      body: const Center(
        child: Text(
          'Flutter hidup & backend siap',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
