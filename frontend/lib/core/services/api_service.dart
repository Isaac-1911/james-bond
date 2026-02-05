import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/category.dart' as model;
import '../config/api_config.dart';
import '../../models/news.dart';
import '../../models/publication.dart';
import '../../models/infographic.dart';
import '../../models/statistic_data.dart';
import '../../models/release_plan.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  // Future<List<News>> getNews() async {
  //   final response = await _dio.get('/news');

  //   final List data = response.data['data'];
  //   return data.map((e) => News.fromJson(e)).toList();
  // }

  Future<List<News>> getNews({
  String? query,
}) async {
  try {
    final response = await _dio.get('/news');

    debugPrint('🟢 GET /news → ${response.statusCode}');

    final List data = response.data['data'];

    List<News> items =
        data.map((e) => News.fromJson(e)).toList();

    // 🔎 OPTIONAL: client-side search (AMAN)
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      items = items
          .where((n) => n.title.toLowerCase().contains(q))
          .toList();
    }

    return items;
  } catch (e, stackTrace) {
    debugPrint('❌ GET /news ERROR: $e');
    debugPrint('$stackTrace');
    rethrow;
  }
}

  Future<List<Infographic>> getInfographic() async {
    final res = await _dio.get('/infographic');

    return (res.data['data'] as List)
        .map((json) => Infographic.fromJson(json))
        .toList();
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

  // Future<List<Infographic>> getInfographic() async {
  //   final res = await _dio.get('/infographic');

  //   return (res.data['data'] as List)
  //       .map((json) => Infographic.fromJson(json))
  //       .toList();
  // }

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

  static Future<List<Infographic>>? _infographicCache;

  Future<List<Infographic>> getInfographicCached() {
    _infographicCache ??= _fetchInfographic();
    return _infographicCache!;
  }

  Future<List<Infographic>> _fetchInfographic() async {
    final res = await _dio.get('/infographic');

    return (res.data['data'] as List)
        .map((json) => Infographic.fromJson(json))
        .toList();
  }

  Future<List<ReleasePlan>> getReleasePlans() async {
    final res = await _dio.get('/release-plans');

    final List list = res.data['data'];

    return list.map((e) => ReleasePlan.fromJson(e)).toList();
  }

  Future<Publication> getPublicationById(int id) async {
    final res = await _dio.get('/publication/$id');
    return Publication.fromJson(res.data['data']);
  }

  Future<News> getNewsById(int id) async {
    final res = await _dio.get('/news/$id');
    return News.fromJson(res.data['data']);
  }
}
