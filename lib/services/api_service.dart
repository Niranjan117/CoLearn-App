import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

/// HTTP client wrapper for all API calls.
/// ============================================================
/// INTEGRATION POINT (Phase 2)
/// All API calls will go through this service.
/// Set AppConfig.enableLiveMaps = true to enable live endpoints.
/// ============================================================
class ApiService {
  ApiService._();

  static final ApiService _instance = ApiService._();
  static ApiService get instance => _instance;

  final _client = http.Client();

  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // INTEGRATION POINT (Phase 2): Add Authorization header
    // 'Authorization': 'Bearer ${AuthService.instance.token}',
  };

  Map<String, String> get _supabaseHeaders => {
    ..._defaultHeaders,
    'apikey': AppConfig.supabaseAnonKey,
    'Authorization': 'Bearer ${AppConfig.supabaseAnonKey}',
  };

  /// Generic GET request
  Future<dynamic> get(String url, {bool useSupabase = false}) async {
    final uri = Uri.parse(url);
    final headers = useSupabase ? _supabaseHeaders : _defaultHeaders;

    try {
      final response = await _client
          .get(uri, headers: headers)
          .timeout(AppConfig.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e', url: url);
    }
  }

  /// Generic POST request
  Future<dynamic> post(
    String url,
    Map<String, dynamic> body, {
    bool useSupabase = false,
  }) async {
    final uri = Uri.parse(url);
    final headers = useSupabase ? _supabaseHeaders : _defaultHeaders;

    try {
      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(AppConfig.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('POST request failed: $e', url: url, body: body);
    }
  }

  Future<dynamic> patch(
    String url,
    Map<String, dynamic> body, {
    bool useSupabase = false,
  }) async {
    final uri = Uri.parse(url);
    final headers = useSupabase ? _supabaseHeaders : _defaultHeaders;

    try {
      final response = await _client
          .patch(uri, headers: headers, body: jsonEncode(body))
          .timeout(AppConfig.apiTimeout);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('PATCH request failed: $e', url: url, body: body);
    }
  }

  Future<dynamic> postMultipart(
    String url,
    http.MultipartRequest request,
  ) async {
    try {
      final response = await http.Response.fromStream(
        await request.send().timeout(AppConfig.apiTimeout),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Multipart request failed: $e', url: url);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        'HTTP $statusCode: ${response.reasonPhrase}',
        statusCode: statusCode,
        url: response.request?.url.toString(),
      );
    }
  }

  void dispose() => _client.close();
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? url;
  final Map<String, dynamic>? body;

  const ApiException(this.message, {this.statusCode, this.url, this.body});

  @override
  String toString() =>
      'ApiException: $message (status: $statusCode, url: $url)';

  bool get isNetworkError => statusCode == null;
  bool get isServerError => (statusCode ?? 0) >= 500;
  bool get isAuthError => statusCode == 401 || statusCode == 403;
  bool get isNotFound => statusCode == 404;
}
