import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/request_model.dart';

/// API服务类
/// 处理所有与后端的HTTP通信
class ApiService {
  static const String baseUrl = 'https://api.yinbangbang.com';
  static const String apiVersion = '/v1';
  
  // 单例模式
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  String? _token;
  
  /// 获取认证token
  Future<String?> getToken() async {
    if (_token != null) return _token;
    
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }
  
  /// 设置认证token
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  /// 清除认证token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  /// 获取请求头
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    final token = await getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  /// 处理HTTP响应
  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = json.decode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? '请求失败',
        statusCode: response.statusCode,
        data: data,
      );
    }
  }
  
  // ==================== 用户相关API ====================
  
  /// 发送验证码
  Future<Map<String, dynamic>> sendVerificationCode(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/auth/send-code'),
      headers: await _getHeaders(),
      body: json.encode({'phone': phone}),
    );
    
    return _handleResponse(response);
  }
  
  /// 用户登录
  Future<Map<String, dynamic>> login(String phone, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/auth/login'),
      headers: await _getHeaders(),
      body: json.encode({
        'phone': phone,
        'code': code,
      }),
    );
    
    final data = _handleResponse(response);
    
    // 保存token
    if (data['token'] != null) {
      await setToken(data['token']);
    }
    
    return data;
  }
  
  /// 用户注册
  Future<Map<String, dynamic>> register({
    required String phone,
    required String code,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/auth/register'),
      headers: await _getHeaders(),
      body: json.encode({
        'phone': phone,
        'code': code,
        'name': name,
      }),
    );
    
    final data = _handleResponse(response);
    
    // 保存token
    if (data['token'] != null) {
      await setToken(data['token']);
    }
    
    return data;
  }
  
  /// 获取用户信息
  Future<UserModel> getUserInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl$apiVersion/user/profile'),
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    return UserModel.fromJson(data['user']);
  }
  
  /// 更新用户信息
  Future<UserModel> updateUserInfo(Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl$apiVersion/user/profile'),
      headers: await _getHeaders(),
      body: json.encode(userData),
    );
    
    final data = _handleResponse(response);
    return UserModel.fromJson(data['user']);
  }
  
  /// 实名认证
  Future<Map<String, dynamic>> verifyIdentity({
    required String realName,
    required String idCard,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/user/verify-identity'),
      headers: await _getHeaders(),
      body: json.encode({
        'real_name': realName,
        'id_card': idCard,
      }),
    );
    
    return _handleResponse(response);
  }
  
  /// 学生认证
  Future<Map<String, dynamic>> verifyStudent({
    required String studentId,
    required String school,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/user/verify-student'),
      headers: await _getHeaders(),
      body: json.encode({
        'student_id': studentId,
        'school': school,
      }),
    );
    
    return _handleResponse(response);
  }
  
  /// 用户登出
  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl$apiVersion/auth/logout'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      // 登出错误可以忽略，不影响用户体验
    } finally {
      await clearToken();
    }
  }
  
  // ==================== 需求相关API ====================
  
  /// 获取附近需求
  Future<List<RequestModel>> getNearbyRequests({
    double? latitude,
    double? longitude,
    double? radius,
    RequestCategory? category,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (latitude != null) queryParams['latitude'] = latitude.toString();
    if (longitude != null) queryParams['longitude'] = longitude.toString();
    if (radius != null) queryParams['radius'] = radius.toString();
    if (category != null) queryParams['category'] = category.name;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    
    final uri = Uri.parse('$baseUrl$apiVersion/requests').replace(
      queryParameters: queryParams,
    );
    
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    final requestsData = data['requests'] as List;
    
    return requestsData.map((json) => RequestModel.fromJson(json)).toList();
  }
  
  /// 搜索需求
  Future<List<RequestModel>> searchRequests({
    required String keyword,
    RequestCategory? category,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'keyword': keyword,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (category != null) queryParams['category'] = category.name;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    
    final uri = Uri.parse('$baseUrl$apiVersion/requests/search').replace(
      queryParameters: queryParams,
    );
    
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    final requestsData = data['requests'] as List;
    
    return requestsData.map((json) => RequestModel.fromJson(json)).toList();
  }
  
  /// 获取需求详情
  Future<RequestModel> getRequestDetail(String requestId) async {
    final response = await http.get(
      Uri.parse('$baseUrl$apiVersion/requests/$requestId'),
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    return RequestModel.fromJson(data['request']);
  }
  
  /// 发布需求
  Future<RequestModel> publishRequest({
    required RequestCategory category,
    required String title,
    required String description,
    required double reward,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime deadline,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/requests'),
      headers: await _getHeaders(),
      body: json.encode({
        'category': category.name,
        'title': title,
        'description': description,
        'reward': reward,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'deadline': deadline.toIso8601String(),
      }),
    );
    
    final data = _handleResponse(response);
    return RequestModel.fromJson(data['request']);
  }
  
  /// 接受需求
  Future<RequestModel> acceptRequest(String requestId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/requests/$requestId/accept'),
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    return RequestModel.fromJson(data['request']);
  }
  
  /// 完成需求
  Future<RequestModel> completeRequest(String requestId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/requests/$requestId/complete'),
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    return RequestModel.fromJson(data['request']);
  }
  
  /// 取消需求
  Future<RequestModel> cancelRequest(String requestId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/requests/$requestId/cancel'),
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    return RequestModel.fromJson(data['request']);
  }
  
  /// 获取我发布的需求
  Future<List<RequestModel>> getMyRequests({
    RequestStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (status != null) queryParams['status'] = status.name;
    
    final uri = Uri.parse('$baseUrl$apiVersion/user/requests').replace(
      queryParameters: queryParams,
    );
    
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    final requestsData = data['requests'] as List;
    
    return requestsData.map((json) => RequestModel.fromJson(json)).toList();
  }
  
  /// 获取我接受的需求
  Future<List<RequestModel>> getMyAcceptedRequests({
    RequestStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (status != null) queryParams['status'] = status.name;
    
    final uri = Uri.parse('$baseUrl$apiVersion/user/accepted-requests').replace(
      queryParameters: queryParams,
    );
    
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    final requestsData = data['requests'] as List;
    
    return requestsData.map((json) => RequestModel.fromJson(json)).toList();
  }
  
  // ==================== 通知相关API ====================
  
  /// 获取通知列表
  Future<List<Map<String, dynamic>>> getNotifications({
    String? type,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (type != null) queryParams['type'] = type;
    
    final uri = Uri.parse('$baseUrl$apiVersion/notifications').replace(
      queryParameters: queryParams,
    );
    
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['notifications']);
  }
  
  /// 标记通知为已读
  Future<void> markNotificationAsRead(String notificationId) async {
    await http.put(
      Uri.parse('$baseUrl$apiVersion/notifications/$notificationId/read'),
      headers: await _getHeaders(),
    );
  }
  
  /// 标记所有通知为已读
  Future<void> markAllNotificationsAsRead() async {
    await http.put(
      Uri.parse('$baseUrl$apiVersion/notifications/read-all'),
      headers: await _getHeaders(),
    );
  }
  
  // ==================== 聊天相关API ====================
  
  /// 获取聊天记录
  Future<List<Map<String, dynamic>>> getChatMessages({
    required String userId,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    final uri = Uri.parse('$baseUrl$apiVersion/chat/$userId/messages').replace(
      queryParameters: queryParams,
    );
    
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );
    
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['messages']);
  }
  
  /// 发送消息
  Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String content,
    String type = 'text',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiVersion/chat/$userId/messages'),
      headers: await _getHeaders(),
      body: json.encode({
        'content': content,
        'type': type,
      }),
    );
    
    return _handleResponse(response);
  }
}

/// API异常类
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;
  
  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });
  
  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}