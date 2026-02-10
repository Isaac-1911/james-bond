class ApiConfig {
  // static String get baseUrl {
  //   final url = dotenv.env['API_BASE_URL'];

  //   if (url == null || url.isEmpty) {
  //     throw Exception(
  //       'API_BASE_URL belum diset di file .env',
  //     );
  //   }

  //   return url;
  // }
  // static String get storageUrl {
  //   final url = dotenv.env['STORAGE_URL'];

  //   if (url == null || url.isEmpty) {
  //     throw Exception(
  //       'STORAGE_URL belum diset di file .env',
  //     );
  //   }

  //   return url;
  // }

  static const String baseUrl = 'https://api.bpsbondowoso.com/api';
  static const String storageUrl = 'https://api.bpsbondowoso.com/storage';
}
