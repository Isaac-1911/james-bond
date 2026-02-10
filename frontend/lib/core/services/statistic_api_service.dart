import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../../models/statistic_subject.dart';
import '../../models/statistic_subsubject.dart';
import '../../models/statistic_table.dart';

class StatisticApiService {
  final Dio _dio;

  StatisticApiService() : _dio = _createDio() {
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
  // 🔐 DIO FACTORY (TLS SAFE)
  // =============================
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
      // ❗ jangan true — aman buat Play Store
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
      return client;
    };

    return dio;
  }

  // =============================
  // 📚 SUBJECT
  // =============================
  Future<List<StatisticSubject>> getSubjects() async {
    try {
      final res = await _dio.get('/statistic/subjects');
      final List list = res.data['data'] as List? ?? [];
      return list.map((e) => StatisticSubject.fromJson(e)).toList();
    } on DioException {
      throw Exception('Gagal memuat subject statistik');
    }
  }

  // =============================
  // 📂 SUBSUBJECT
  // =============================
  Future<List<StatisticSubsubject>> getSubsubjects(int subjectId) async {
    try {
      final res = await _dio.get('/statistic/subsubjects/$subjectId');
      final List list = res.data['data'] as List? ?? [];
      return list.map((e) => StatisticSubsubject.fromJson(e)).toList();
    } on DioException {
      throw Exception('Gagal memuat subsubject statistik');
    }
  }

  // =============================
  // 📊 TABLES BY SUBSUBJECT
  // =============================
  Future<List<StatisticTable>> getTables(int subsubjectId) async {
    try {
      final res = await _dio.get('/statistic/tables/$subsubjectId');
      final List list = res.data['data'] as List? ?? [];
      return list.map((e) => StatisticTable.fromJson(e)).toList();
    } on DioException {
      throw Exception('Gagal memuat tabel statistik');
    }
  }

  // =============================
  // 📄 TABLE DETAIL
  // =============================
  Future<StatisticTable> getTableDetail(int tableId) async {
    try {
      final res = await _dio.get('/statistic/table/$tableId');
      return StatisticTable.fromJson(res.data['data']);
    } on DioException {
      throw Exception('Gagal memuat detail tabel statistik');
    }
  }

  // =============================
  // 🔍 ALL TABLES (GLOBAL SEARCH)
  // =============================
  Future<List<StatisticTable>> getAllTables() async {
    try {
      final res = await _dio.get('/statistic/tables');
      final List list = res.data['data'] as List? ?? [];
      return list.map((e) => StatisticTable.fromJson(e)).toList();
    } on DioException {
      throw Exception('Gagal memuat seluruh tabel statistik');
    }
  }
}
