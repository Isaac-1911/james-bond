import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // static String get host => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';

  // static String get baseUrl => '$host/api';
  // static String get storageUrl => '$host/storage';

  static const String storageUrl = 'http://192.168.0.110:8000/storage';
  // static String storageUrl =
  //     "http://${dotenv.env['API_BASE_URL']}:8000/storage";

  static String get baseUrl {
    final url = dotenv.env['API_BASE_URL'];

    if (url == null || url.isEmpty) {
      throw Exception("API_BASE_URL belum di set di file .env");
    }

    return url;
  }
}
