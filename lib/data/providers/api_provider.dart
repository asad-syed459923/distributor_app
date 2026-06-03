import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'hive_provider.dart';

class ApiProvider {
  final HiveProvider _hiveProvider;
  late final Dio _dio;

  ApiProvider(this._hiveProvider) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _hiveProvider.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Future<Response> login(String email, String password) {
    return _post(AppConstants.loginUrl, data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> getDistributors() => _get(AppConstants.getDistributorUrl);

  Future<Response> getRoutes(int distributorId) {
    return _get('${AppConstants.getRouteUrl}/$distributorId');
  }

  Future<Response> checkIn(Map<String, dynamic> data) {
    return _post(AppConstants.checkInUrl, data: data);
  }

  Future<Response> checkOut(Map<String, dynamic> data) {
    return _post(AppConstants.checkOutUrl, data: data);
  }

  Future<Response> _get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw _dioMessage(e);
    }
  }

  Future<Response> _post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _dioMessage(e);
    }
  }

  String _dioMessage(DioException e) {
    final body = e.response?.data;
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }
    return e.message ?? 'Something went wrong';
  }
}
