import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/category.dart' as model;
import '../config/api_config.dart';
import '../../models/news.dart';
import '../../models/publication.dart';
import '../../models/infographic.dart';
import '../../models/statistic_data.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<List<News>> getNews() async {
    final response = await _dio.get('/news');

    final List data = response.data['data'];
    return data.map((e) => News.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getPublications({
    int page = 1,
    int limit = 10,
    String? sort,
    int? category,
    String? query,
  }) async {
    try {
      final response = await _dio.get('/publication');
      debugPrint('API OK: ${response.statusCode}');
    } catch (e) {
      debugPrint('API ERROR: $e');
    }

    final queryParameters = {
      'page': page,
      'limit': limit,
      if (query != null && query.isNotEmpty) 'q': query,
      if (sort != null) 'sort': sort,
      if (category != null) 'category': category,
    };

    final response = await _dio.get(
      '/publication',
      queryParameters: queryParameters,
    );

    final pagination = response.data['data'];

    final List<Publication> items = (pagination['data'] as List)
        .map((e) => Publication.fromJson(e))
        .toList();

    return {
      'items': items,
      'currentPage': pagination['current_page'],
      'lastPage': pagination['last_page'],
    };
  }

  Future<List<Infographic>> getInfographic() async {
    final res = await _dio.get('/infographic');

    return (res.data['data'] as List)
        .map((json) => Infographic.fromJson(json))
        .toList();
  }

  Future<List<StatisticData>> getStatistic() async {
    final res = await _dio.get('/statistics');

    return (res.data['data'] as List)
        .map((json) => StatisticData.fromJson(json))
        .toList();
  }

  Future<List<model.Category>> getCategories() async {
    final res = await _dio.get('/category');

    final List list = res.data['data'];

    return list.map((e) => model.Category.fromJson(e)).toList();
  }
}
