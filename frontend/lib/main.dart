import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/api/api_service.dart';
import 'api/api_config.dart';
import 'package:frontend/screens/data_list_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  debugPrint("API BASE URL: ${ApiConfig.baseUrl}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final api = ApiService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataListScreen(title: 'Publication', fetchData: api.getPublication),
    );
  }
}


