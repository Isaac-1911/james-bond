import 'dart:io';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/activity_news.dart';
import 'package:frontend/models/category.dart' as model;
import 'package:frontend/models/news.dart';
import 'package:frontend/models/publication.dart';
import 'package:frontend/models/infographic.dart';
import 'package:frontend/models/statistic_data.dart';
import 'package:frontend/models/release_plan.dart';
import 'package:frontend/models/global_search_item.dart';
import 'package:frontend/models/onboarding_banner.dart';
import '../config/api_config.dart';

class ApiService {
  late final Dio _dio;
  Map<String, dynamic> _safeMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    return <String, dynamic>{};
  }

  List _safeList(dynamic v) {
    if (v is List) return v;
    return <dynamic>[];
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      // ❗ jangan return true → tetap aman buat Play Store
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
      return client;
    };

    return dio;
  }

  ApiService() {
    _dio = _createDio();

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

    final root = _safeMap(res.data);
    final list = _safeList(root['data']);

    List<News> items =
        list.map((e) => News.fromJson(_safeMap(e))).toList();

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

    final data = _safeMap(_safeMap(res.data)['data']);
    return News.fromJson(data);
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

    final root = _safeMap(res.data);
    final list = _safeList(root['data']);

    return list
        .map((e) => Infographic.fromJson(_safeMap(e)))
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
  try {
    final res = await _dio.get('/activity-news');

    final root = _safeMap(res.data);
    final list = _safeList(root['data']);

    return list
        .map((e) => ActivityNews.fromJson(_safeMap(e)))
        .toList();
  } on DioException catch (e) {
    throw Exception(_mapDioError(e));
  }
}

Future<List<ActivityNews>> _fetchActivityNews() async {
  try {
    final res = await _dio.get('/activity-news');

    final root = _safeMap(res.data);
    final list = _safeList(root['data']);

    return list
        .map((e) => ActivityNews.fromJson(_safeMap(e)))
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
    int? category,
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
          if (query?.isNotEmpty == true) 'q': query,
          if (sort != null) 'sort': sort,
          if (filter != null) 'filter': filter,
          if (category != null) 'category': category,
          if (year != null) 'year': year,
        },
      );

      

      final data = _safeMap(res.data)['data'];
      final pagination = _safeMap(data);

      final list = _safeList(
        pagination['data'],
      ).map((e) => Publication.fromJson(e)).toList();

      return {
        'items': list,
        'currentPage':
            int.tryParse(pagination['current_page']?.toString() ?? '') ?? 1,
        'lastPage':
            int.tryParse(pagination['last_page']?.toString() ?? '') ?? 1,
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

    final root = _safeMap(res.data);
    final list = _safeList(root['data']);

    return list
        .map((e) => StatisticData.fromJson(_safeMap(e)))
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

    final root = _safeMap(res.data);
    final list = _safeList(root['data']);

    return list
        .map((e) => model.Category.fromJson(_safeMap(e)))
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

    final root = _safeMap(res.data);
    final list = _safeList(root['data']);

    return list
        .map((e) => ReleasePlan.fromJson(_safeMap(e)))
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
    final root = _safeMap(res.data);
    final data = _safeMap(root['data']);

    final List<GlobalSearchItem> results = [];

    for (final item in _safeList(data['news'])) {
      final m = _safeMap(item);
      results.add(
        GlobalSearchItem(
          type: SearchItemType.news,
          id: int.tryParse(m['news_id']?.toString() ?? '') ?? 0,
          title: m['title']?.toString() ?? '',
          subtitle: m['release_date']?.toString(),
          tag: 'Berita Resmi Statistik',
        ),
      );
    }

    for (final item in _safeList(data['publications'])) {
      final m = _safeMap(item);
      results.add(
        GlobalSearchItem(
          type: SearchItemType.publication,
          id: int.tryParse(m['publication_id']?.toString() ?? '') ?? 0,
          title: m['title']?.toString() ?? '',
          subtitle: m['release_date']?.toString(),
          tag: 'Publikasi',
        ),
      );
    }

    for (final item in _safeList(data['statistics'])) {
      final m = _safeMap(item);
      results.add(
        GlobalSearchItem(
          type: SearchItemType.statistic,
          id: int.tryParse(m['id']?.toString() ?? '') ?? 0,
          title: m['title']?.toString() ?? '',
          subtitle: m['subsubject_name']?.toString() ??
              m['subject_name']?.toString(),
          tag: 'Tabel Statistik',
        ),
      );
    }

    for (final item in _safeList(data['infographics'])) {
      final m = _safeMap(item);
      results.add(
        GlobalSearchItem(
          type: SearchItemType.infographic,
          id: int.tryParse(m['infographic_id']?.toString() ?? '') ?? 0,
          title: m['title']?.toString() ?? '',
          subtitle: m['description']?.toString(),
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
      data: {
        'rating': rating,
        'job': job,
        'tags': tags,
        'message': message,
      },
    );
  } on DioException catch (e) {
    throw Exception(_mapDioError(e));
  }
}


  Future<List<OnboardingBanner>> getOnboardingBanners() async {
  final res = await _dio.get('/onboarding-banners');

  final root = _safeMap(res.data);
  final list = _safeList(root['data']);

  return list
      .map((e) => OnboardingBanner.fromJson(_safeMap(e)))
      .toList();
}

}
