import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/activity_news.dart';
import 'package:frontend/models/category.dart' as model;
import '../config/api_config.dart';
import '../../models/news.dart';
import '../../models/publication.dart';
import '../../models/infographic.dart';
import '../../models/statistic_data.dart';
import '../../models/release_plan.dart';
import '../../models/global_search_item.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<List<News>> getNews({String? query}) async {
    try {
      final response = await _dio.get('/news');

      debugPrint('🟢 GET /news → ${response.statusCode}');

      final List data = response.data['data'];

      List<News> items = data.map((e) => News.fromJson(e)).toList();

      // 🔎 OPTIONAL: client-side search (AMAN)
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        items = items.where((n) => n.title.toLowerCase().contains(q)).toList();
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

  Future<List<ActivityNews>> getActivityNews() async {
    final res = await _dio.get('/activity-news');

    return (res.data['data'] as List)
        .map((json) => ActivityNews.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> getPublications({
    int page = 1,
    int limit = 10,
    String? sort,
    int? category,
    String? query,
    String? filter,
    int? year
  }) async {
    try {
      final response = await _dio.get('/publication');
    } catch (e) {}

    final queryParameters = {
      'page': page,
      'limit': limit,
      if (query != null && query.isNotEmpty) 'q': query,
      if (sort != null) 'sort': sort,
      if (filter != null) 'filter': filter,
      if (year != null) 'year' : year,
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

  static Future<List<ActivityNews>>? _activityNewsCache;

  Future<List<ActivityNews>> getActivityNewsCached() {
    _activityNewsCache ??= _fetchActivityNews();
    return _activityNewsCache!;
  }

  Future<List<Infographic>> _fetchInfographic() async {
    final res = await _dio.get('/infographic');

    return (res.data['data'] as List)
        .map((json) => Infographic.fromJson(json))
        .toList();
  }

  Future<List<ActivityNews>> _fetchActivityNews() async {
    final res = await _dio.get('/activity-news');

    return (res.data['data'] as List)
        .map((json) => ActivityNews.fromJson(json))
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

  Future<List<GlobalSearchItem>> globalSearch(String query) async {
    final res = await _dio.get('/search', queryParameters: {'q': query});

    final data = res.data['data'];

    final List<GlobalSearchItem> results = [];

    // 🟦 News
    for (final item in data['news']) {
      results.add(
        GlobalSearchItem(
          type: SearchItemType.news,
          id: item['news_id'],
          title: item['title'],
          subtitle: item['release_date'],
          tag: 'Berita Resmi Statistik',
        ),
      );
    }

    // 🟧 Publications
    for (final item in data['publications']) {
      results.add(
        GlobalSearchItem(
          type: SearchItemType.publication,
          id: item['publication_id'],
          title: item['title'],
          subtitle: item['release_date'],
          tag: 'Publikasi',
        ),
      );
    }

    // 🟩 Statistics
    for (final item in data['statistics'] ?? []) {
      results.add(
        GlobalSearchItem(
          type: SearchItemType.statistic,
          id: item['id'],
          title: item['title'],
          subtitle: item['subsubject_name'] ?? item['subject_name'],
          tag: 'Tabel Statistik',
        ),
      );
    }

    // 🟪 INFOGRAFIS
    for (final item in data['infographics'] ?? []) {
      results.add(
        GlobalSearchItem(
          type: SearchItemType.infographic,
          id: item['infographic_id'],
          title: item['title'],
          subtitle: item['description'],
          tag: 'Infografis',
        ),
      );
    }

    return results;
  }

  Future<void> submitFeedback({
    required int rating,
    String? job,
    List<String>? tags,
    String? message,
  }) async {
    await _dio.post(
      '/feedback',
      data: {'rating': rating, 'job': job, 'tags': tags, 'message': message},
    );
  }
}
