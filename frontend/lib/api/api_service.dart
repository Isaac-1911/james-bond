import 'package:dio/dio.dart';
import 'api_config.dart';
import '../models/news.dart';
import 'package:frontend/models/publication.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<List<News>> getNews() async {
    final res = await _dio.get('/news');

    return (res.data['data'] as List)
        .map((json) => News.fromJson(json))
        .toList();
  }

  Future<List<Publication>> getPublication() async {
    final res = await _dio.get('/publication');

    return (res.data['data'] as List)
        .map((json) => Publication.fromJson(json))
        .toList();
  }

  Future<List<dynamic>> getInfographic() async {
    final response = await _dio.get('/infographic');
    return response.data['data'];
  }

  Future<List<dynamic>> getStatistic() async {
    final response = await _dio.get('/statistics');
    return response.data['data'];
  }
}
