import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

import 'package:frontend/models/activity_news.dart';
import 'package:frontend/models/category.dart' as model;
import 'package:frontend/models/news.dart';
import 'package:frontend/models/publication.dart';
import 'package:frontend/models/infographic.dart';
import 'package:frontend/models/statistic_data.dart';
import 'package:frontend/models/release_plan.dart';
import 'package:frontend/models/global_search_item.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint('➡️ [REQ] ${options.method} ${options.uri}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '✅ [RES] ${response.statusCode} ${response.requestOptions.uri}',
            );
          }
          handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            debugPrint('❌ [ERR] ${e.type} ${e.message}');
          }
          handler.next(e);
        },
      ),
    );
  }

  // =============================
  // 🔒 ERROR NORMALIZATION
  // =============================
  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Koneksi ke server timeout';
      case DioExceptionType.sendTimeout:
        return 'Gagal mengirim data ke server';
      case DioExceptionType.receiveTimeout:
        return 'Server terlalu lama merespon';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode})';
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi internet';
      default:
        return 'Terjadi kesalahan jaringan';
    }
  }

  // =============================
  // 📰 NEWS
  // =============================
  Future<List<News>> getNews({String? query}) async {
    try {
      final res = await _dio.get('/news');
      final List data = res.data['data'];

      List<News> items = data.map((e) => News.fromJson(e)).toList();

      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        items = items.where((n) => n.title.toLowerCase().contains(q)).toList();
      }

      return items;
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  Future<News> getNewsById(int id) async {
    try {
      final res = await _dio.get('/news/$id');
      return News.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  // =============================
  // 📊 INFOGRAFIK
  // =============================
  static Future<List<Infographic>>? _infographicCache;

  Future<List<Infographic>> getInfographic() async {
    return getInfographicCached();
  }

  Future<List<Infographic>> getInfographicCached() {
    _infographicCache ??= _fetchInfographic();
    return _infographicCache!;
  }

  Future<List<Infographic>> _fetchInfographic() async {
    try {
      final res = await _dio.get('/infographic');
      return (res.data['data'] as List)
          .map((e) => Infographic.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  // =============================
  // 🧾 ACTIVITY NEWS
  // =============================
  static Future<List<ActivityNews>>? _activityNewsCache;

  Future<List<ActivityNews>> getActivityNewsCached() {
    _activityNewsCache ??= _fetchActivityNews();
    return _activityNewsCache!;
  }

  Future<List<ActivityNews>> getActivityNews() async {
    final res = await _dio.get('/activity-news');
    return (res.data['data'] as List)
        .map((json) => ActivityNews.fromJson(json))
        .toList();
  }

  Future<List<ActivityNews>> _fetchActivityNews() async {
    try {
      final res = await _dio.get('/activity-news');
      return (res.data['data'] as List)
          .map((e) => ActivityNews.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  // =============================
  // 📚 PUBLICATION
  // =============================
  Future<Map<String, dynamic>> getPublications({
    int page = 1,
    int limit = 10,
    String? sort,
    int? category, // 🔥 BALIKIN
    String? filter,
    String? query,
    int? year,
  }) async {
    try {
      final res = await _dio.get(
        '/publication',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (query != null && query.isNotEmpty) 'q': query,
          if (sort != null) 'sort': sort,
          if (filter != null) 'filter': filter,
          if (category != null) 'category': category, // 🔥 PAKAI
          if (year != null) 'year': year,
        },
      );

      final pagination = res.data['data'];

      final items = (pagination['data'] as List)
          .map((e) => Publication.fromJson(e))
          .toList();

      return {
        'items': items,
        'currentPage': pagination['current_page'],
        'lastPage': pagination['last_page'],
      };
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  Future<Publication> getPublicationById(int id) async {
    try {
      final res = await _dio.get('/publication/$id');
      return Publication.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  // =============================
  // 📈 STATISTIC
  // =============================
  Future<List<StatisticData>> getStatistic() async {
    try {
      final res = await _dio.get('/statistics');
      return (res.data['data'] as List)
          .map((e) => StatisticData.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  // =============================
  // 🗂 CATEGORY
  // =============================
  Future<List<model.Category>> getCategories() async {
    try {
      final res = await _dio.get('/category');
      return (res.data['data'] as List)
          .map((e) => model.Category.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  // =============================
  // 📅 RELEASE PLAN
  // =============================
  Future<List<ReleasePlan>> getReleasePlans() async {
    try {
      final res = await _dio.get('/release-plans');
      return (res.data['data'] as List)
          .map((e) => ReleasePlan.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  // =============================
  // 🔍 GLOBAL SEARCH
  // =============================
  Future<List<GlobalSearchItem>> globalSearch(String query) async {
    try {
      final res = await _dio.get('/search', queryParameters: {'q': query});
      final data = res.data['data'];

      final List<GlobalSearchItem> results = [];

      for (final item in data['news'] ?? []) {
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

      for (final item in data['publications'] ?? []) {
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
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  Future<void> submitFeedback({
    required int rating,
    String? job,
    List<String>? tags,
    String? message,
  }) async {
    try {
      await _dio.post(
        '/feedback',
        data: {'rating': rating, 'job': job, 'tags': tags, 'message': message},
      );
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }
}
