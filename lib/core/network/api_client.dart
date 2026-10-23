import 'package:dio/dio.dart';

import '../constants/app_config.dart';
import '../storage/token_store.dart';
import 'api_exception.dart';
import 'device_label.dart';

class ApiClient {
  ApiClient(this.tokens, {String? baseUrl, this.onSessionExpired}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['X-Device-Name'] = deviceLabel();
          if (options.extra['skipAuth'] != true) {
            final access = await tokens.readAccess();
            if (access != null) {
              options.headers['Authorization'] = 'Bearer $access';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          final skip = error.requestOptions.extra['skipAuth'] == true;
          final retried = error.requestOptions.extra['retried'] == true;
          if (status == 401 && !skip && !retried) {
            final refreshed = await _refresh();
            if (refreshed) {
              final request = error.requestOptions;
              request.extra['retried'] = true;
              request.headers['Authorization'] = 'Bearer ${await tokens.readAccess()}';
              try {
                final response = await dio.fetch<dynamic>(request);
                handler.resolve(response);
                return;
              } catch (_) {
                handler.next(error);
                return;
              }
            }
            await tokens.clear();
            await onSessionExpired?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final ActiveTokenStore tokens;
  late final Dio dio;
  Future<void> Function()? onSessionExpired;
  bool _refreshing = false;

  Future<bool> _refresh() async {
    if (_refreshing) return false;
    _refreshing = true;
    try {
      final refresh = await tokens.readRefresh();
      if (refresh == null || refresh.isEmpty) return false;
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refresh},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data;
      if (data == null) return false;
      await tokens.save(access: data['access_token'] as String, refresh: data['refresh_token'] as String);
      return true;
    } catch (_) {
      return false;
    } finally {
      _refreshing = false;
    }
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {bool auth = true}) {
    return _send(() => dio.post<Map<String, dynamic>>(path, data: body, options: Options(extra: {'skipAuth': !auth})));
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body) {
    return _send(() => dio.patch<Map<String, dynamic>>(path, data: body));
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) {
    return _send(() => dio.get<Map<String, dynamic>>(path, queryParameters: query));
  }

  Future<void> delete(String path) async {
    try {
      await dio.delete<void>(path);
    } on DioException catch (error) {
      throw parseDio(error);
    }
  }

  Future<Map<String, dynamic>> _send(Future<Response<Map<String, dynamic>>> Function() run) async {
    try {
      final response = await run();
      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw parseDio(error);
    }
  }
}

ApiException parseDio(DioException error) {
  final data = error.response?.data;
  if (data is Map && data['detail'] is Map) {
    final detail = Map<String, dynamic>.from(data['detail'] as Map);
    return ApiException(
      code: detail['code']?.toString() ?? 'UNKNOWN',
      message: detail['message']?.toString(),
      status: error.response?.statusCode,
      attemptsLeft: detail['attempts_left'] is int ? detail['attempts_left'] as int : null,
    );
  }
  if (data is Map && data['detail'] is List) {
    return ApiException(code: 'VALIDATION', status: error.response?.statusCode);
  }
  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return const ApiException(code: 'NETWORK');
  }
  final status = error.response?.statusCode;
  if (status == 401) return const ApiException(code: 'UNAUTHORIZED', status: 401);
  if (status == 403) return const ApiException(code: 'FORBIDDEN', status: 403);
  if (status != null && status >= 500) return ApiException(code: 'SERVER', status: status);
  return ApiException(code: 'UNKNOWN', status: status);
}
