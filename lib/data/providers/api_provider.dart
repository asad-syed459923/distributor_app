import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class ApiProvider {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.loginUrl,
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      throw e.message ?? 'An error occurred during login';
    }
  }

  Future<Response> getDistributors() async {
    try {
      final response = await _dio.get(AppConstants.getDistributorUrl);
      return response;
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch distributors';
    }
  }

  Future<Response> getRoutes(int distributorId) async {
    try {
      final response = await _dio.get('${AppConstants.getRouteUrl}/$distributorId');
      return response;
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch routes';
    }
  }

  Future<Response> checkIn(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(AppConstants.checkInUrl, data: data);
      return response;
    } on DioException catch (e) {
      throw e.message ?? 'Check-in failed';
    }
  }

  Future<Response> checkOut(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(AppConstants.checkOutUrl, data: data);
      return response;
    } on DioException catch (e) {
      throw e.message ?? 'Check-out failed';
    }
  }
}
