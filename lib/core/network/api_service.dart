import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../errors/failures.dart';
import '../constants/api_constants.dart';

class ApiService {
  // Environment Configuration
  static const String _baseUrl = 'https://opentdb.com';

  // Private Dio instance
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )..interceptors.addAll([
        _loggingInterceptor(),
      ]);
  }

  /// Check internet connectivity
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  /// Generic GET request with error handling
  Future<Either<Failure, T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      // For web platform, use mock data due to CORS restrictions
      // if (kIsWeb) {
      //   return await _getMockDataForWeb<T>(endpoint, fromJson);
      // }

      // Check internet connectivity for mobile
      if (!await hasInternetConnection()) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.statusCode == 200) {
        final data = fromJson(response.data);
        return Right(data);
      } else {
        return Left(ServerFailure('Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  /// Generic POST request with error handling
  Future<Either<Failure, T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      // Check internet connectivity
      if (!await hasInternetConnection()) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = fromJson(response.data);
        return Right(responseData);
      } else {
        return Left(ServerFailure('Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  /// Logging Interceptor for development
  Interceptor _loggingInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
      logPrint: (object) {
        // Only log in debug mode
        print('[API_LOG] $object');
      },
    );
  }

  /// Handle Dio Exceptions
  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
            'Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? 'Server error';

        if (statusCode == 401) {
          return const ServerFailure('Unauthorized access');
        } else if (statusCode == 403) {
          return const ServerFailure('Access forbidden');
        } else if (statusCode == 404) {
          return const ServerFailure('Resource not found');
        } else if (statusCode == 500) {
          return const ServerFailure('Internal server error');
        } else {
          return ServerFailure(message);
        }

      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');

      case DioExceptionType.connectionError:
        // Handle specific web CORS and network errors
        final errorMessage = e.message?.toLowerCase() ?? '';
        if (errorMessage.contains('xmlhttprequest') ||
            errorMessage.contains('cors') ||
            errorMessage.contains('network error')) {
          return const NetworkFailure(
            'Network access blocked. This may be due to CORS restrictions or network policies.',
          );
        }
        return const NetworkFailure(
            'Connection error. Please check your internet connection.');

      case DioExceptionType.unknown:
      default:
        final errorMessage = e.message?.toLowerCase() ?? '';
        if (errorMessage.contains('xmlhttprequest') ||
            errorMessage.contains('cors')) {
          return const NetworkFailure(
            'Network request blocked. Please try again or contact support.',
          );
        }
        return NetworkFailure('Network error: ${e.message}');
    }
  }

  /// Utility method to add custom headers
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Utility method to remove custom headers
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Clear all headers except default ones
  void clearCustomHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
  }

  /// Quiz-specific endpoint helpers
  static String buildQuizUrl({
    required int amount,
    required int categoryId,
    String difficulty = 'easy',
    String type = 'multiple',
  }) {
    return '/api.php?amount=$amount&category=$categoryId&difficulty=$difficulty&type=$type';
  }
}
