import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../config/api_config.dart';

class DownloadHelper {
  static final Dio _dio = Dio();

  static Future<void> downloadPublicationPdf({
    required BuildContext context,
    required int publicationId,
    required String fileName,
  }) async {
    try {
      // ================== TENTUKAN FOLDER ==================
      Directory downloadDir;

      if (Platform.isAndroid) {
        final dir = await getExternalStorageDirectory();
        if (dir == null) {
          throw Exception('Tidak bisa akses storage Android');
        }
        downloadDir = Directory('${dir.path}/Download');
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        final dir = await getDownloadsDirectory();
        if (dir == null) {
          throw Exception('Tidak bisa akses folder Downloads');
        }
        downloadDir = dir;
      } else {
        throw Exception('Platform tidak didukung');
      }

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final savePath = '${downloadDir.path}/$fileName';

      // ================== URL ==================
      final url = '${ApiConfig.baseUrl}/publication/$publicationId/download';

      // ================== DOWNLOAD ==================
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
              'Downloading ${(received / total * 100).toStringAsFixed(0)}%',
            );
          }
        },
      );

      // ================== SUCCESS ==================
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF tersimpan di: ${downloadDir.path}')),
      );
    } catch (e) {
      debugPrint('DOWNLOAD ERROR: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal download PDF')));
    }
  }

  static Future<File> downloadImage({
    required String imageUrl,
    required String fileName,
  }) async {
    try {
      Directory downloadDir;

      if (Platform.isAndroid) {
        final dir = await getExternalStorageDirectory();
        if (dir == null) {
          throw Exception('Tidak bisa akses storage Android');
        }
        downloadDir = Directory('${dir.path}/Download');
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        final dir = await getDownloadsDirectory();
        if (dir == null) {
          throw Exception('Tidak bisa akses folder Downloads');
        }
        downloadDir = dir;
      } else {
        throw Exception('Platform tidak didukung');
      }

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final savePath = '${downloadDir.path}/$fileName';

      await _dio.download(
        imageUrl,
        savePath,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
              'Downloading ${(received / total * 100).toStringAsFixed(0)}%',
            );
          }
        },
      );

      return File(savePath);
    } catch (e) {
      debugPrint('DOWNLOAD IMAGE ERROR: $e');
      rethrow;
    }
  }
}
