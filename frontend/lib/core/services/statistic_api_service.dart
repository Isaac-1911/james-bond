import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../../models/statistic_subject.dart';
import '../../models/statistic_subsubject.dart';
import '../../models/statistic_table.dart';

class StatisticApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  // 🔹 GET /statistic/subjects
  static Future<List<StatisticSubject>> getSubjects() async {
    final res = await _dio.get('/statistic/subjects');

    final List data = res.data['data'];
    return data.map((e) => StatisticSubject.fromJson(e)).toList();
  }

  // 🔹 GET /statistic/subsubjects/{subject_id}
  static Future<List<StatisticSubsubject>> getSubsubjects(int subjectId) async {
    final res = await _dio.get('/statistic/subsubjects/$subjectId');

    final List data = res.data['data'];
    return data.map((e) => StatisticSubsubject.fromJson(e)).toList();
  }

  // 🔹 GET /statistic/tables/{subsubject_id}
  static Future<List<StatisticTable>> getTables(int subsubjectId) async {
    final res = await _dio.get('/statistic/tables/$subsubjectId');

    final List data = res.data['data'];
    return data.map((e) => StatisticTable.fromJson(e)).toList();
  }

  // 🔹 GET /statistic/table/{table_id}
  static Future<StatisticTable> getTableDetail(int tableId) async {
    final res = await _dio.get('/statistic/table/$tableId');

    return StatisticTable.fromJson(res.data['data']);
  }

  static Future<List<StatisticTable>> getAllTables() async {


    final res = await _dio.get('/statistic/tables');


    final List data = res.data['data'];

    return data.map((e) => StatisticTable.fromJson(e)).toList();
  }
}
