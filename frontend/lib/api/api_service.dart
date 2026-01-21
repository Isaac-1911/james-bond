import 'package:dio/dio.dart';
import 'api_config.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  // GET /api/news
  Future<Map<String, dynamic>> getNews() async {
    final response = await _dio.get('/news');
    return response.data;
  }
}
