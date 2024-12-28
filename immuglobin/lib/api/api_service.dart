// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:immuglobin/core/constants/app_config.dart';

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrl, // Tüm istekler için temel URL
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 3000),
        ));

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      return await dio.post(endpoint, data: data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> get(String endpoint) async {
    try {
      return await dio.get(endpoint);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    print('Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
    print('Data: ${e.response?.data}');
  }
}
