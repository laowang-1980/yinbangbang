import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/request_model.dart';

/// 本地存储服务类
/// 处理应用的本地数据存储和缓存
class StorageService {
  // 单例模式
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  SharedPreferences? _prefs;
  
  /// 初始化存储服务
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  /// 确保SharedPreferences已初始化
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }
  
  // ==================== 用户相关存储 ====================
  
  /// 保存用户信息
  Future<void> saveUser(UserModel user) async {
    final p = await prefs;
    await p.setString('user_info', json.encode(user.toJson()));
  }
  
  /// 获取用户信息
  Future<UserModel?> getUser() async {
    final p = await prefs;
    final userJson = p.getString('user_info');
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }
  
  /// 清除用户信息
  Future<void> clearUser() async {
    final p = await prefs;
    await p.remove('user_info');
  }
  
  /// 保存认证token
  Future<void> saveToken(String token) async {
    final p = await prefs;
    await p.setString('auth_token', token);
  }
  
  /// 获取认证token
  Future<String?> getToken() async {
    final p = await prefs;
    return p.getString('auth_token');
  }
  
  /// 清除认证token
  Future<void> clearToken() async {
    final p = await prefs;
    await p.remove('auth_token');
  }
  
  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await getUser();
    return token != null && user != null;
  }
  
  // ==================== 应用设置 ====================
  
  /// 保存是否首次启动
  Future<void> setFirstLaunch(bool isFirst) async {
    final p = await prefs;
    await p.setBool('is_first_launch', isFirst);
  }
  
  /// 获取是否首次启动
  Future<bool> isFirstLaunch() async {
    final p = await prefs;
    return p.getBool('is_first_launch') ?? true;
  }
  
  /// 保存语言设置
  Future<void> saveLanguage(String languageCode) async {
    final p = await prefs;
    await p.setString('language', languageCode);
  }
  
  /// 获取语言设置
  Future<String?> getLanguage() async {
    final p = await prefs;
    return p.getString('language');
  }
  
  /// 保存主题设置
  Future<void> saveTheme(String theme) async {
    final p = await prefs;
    await p.setString('theme', theme);
  }
  
  /// 获取主题设置
  Future<String?> getTheme() async {
    final p = await prefs;
    return p.getString('theme');
  }
  
  /// 保存通知设置
  Future<void> saveNotificationSettings(Map<String, bool> settings) async {
    final p = await prefs;
    await p.setString('notification_settings', json.encode(settings));
  }
  
  /// 获取通知设置
  Future<Map<String, bool>> getNotificationSettings() async {
    final p = await prefs;
    final settingsJson = p.getString('notification_settings');
    if (settingsJson != null) {
      final decoded = json.decode(settingsJson) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as bool));
    }
    return {
      'system_notifications': true,
      'message_notifications': true,
      'order_notifications': true,
      'marketing_notifications': false,
    };
  }
  
  // ==================== 位置相关存储 ====================
  
  /// 保存最后位置
  Future<void> saveLastLocation(double latitude, double longitude, String address) async {
    final p = await prefs;
    final locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await p.setString('last_location', json.encode(locationData));
  }
  
  /// 获取最后位置
  Future<Map<String, dynamic>?> getLastLocation() async {
    final p = await prefs;
    final locationJson = p.getString('last_location');
    if (locationJson != null) {
      return json.decode(locationJson);
    }
    return null;
  }
  
  /// 保存常用地址
  Future<void> saveCommonAddresses(List<Map<String, dynamic>> addresses) async {
    final p = await prefs;
    await p.setString('common_addresses', json.encode(addresses));
  }
  
  /// 获取常用地址
  Future<List<Map<String, dynamic>>> getCommonAddresses() async {
    final p = await prefs;
    final addressesJson = p.getString('common_addresses');
    if (addressesJson != null) {
      final decoded = json.decode(addressesJson) as List;
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }
  
  // ==================== 搜索历史 ====================
  
  /// 保存搜索历史
  Future<void> saveSearchHistory(List<String> history) async {
    final p = await prefs;
    await p.setStringList('search_history', history);
  }
  
  /// 获取搜索历史
  Future<List<String>> getSearchHistory() async {
    final p = await prefs;
    return p.getStringList('search_history') ?? [];
  }
  
  /// 添加搜索记录
  Future<void> addSearchRecord(String keyword) async {
    final history = await getSearchHistory();
    history.remove(keyword); // 移除重复项
    history.insert(0, keyword); // 添加到开头
    
    // 限制历史记录数量
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    await saveSearchHistory(history);
  }
  
  /// 清除搜索历史
  Future<void> clearSearchHistory() async {
    final p = await prefs;
    await p.remove('search_history');
  }
  
  // ==================== 缓存管理 ====================
  
  /// 保存需求列表缓存
  Future<void> cacheRequests(String key, List<RequestModel> requests) async {
    final p = await prefs;
    final requestsJson = requests.map((r) => r.toJson()).toList();
    final cacheData = {
      'data': requestsJson,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await p.setString('cache_requests_$key', json.encode(cacheData));
  }
  
  /// 获取需求列表缓存
  Future<List<RequestModel>?> getCachedRequests(String key, {Duration? maxAge}) async {
    final p = await prefs;
    final cacheJson = p.getString('cache_requests_$key');
    if (cacheJson != null) {
      final cacheData = json.decode(cacheJson);
      final timestamp = DateTime.parse(cacheData['timestamp']);
      
      // 检查缓存是否过期
      if (maxAge != null && DateTime.now().difference(timestamp) > maxAge) {
        return null;
      }
      
      final requestsData = cacheData['data'] as List;
      return requestsData.map((json) => RequestModel.fromJson(json)).toList();
    }
    return null;
  }
  
  /// 清除指定缓存
  Future<void> clearCache(String key) async {
    final p = await prefs;
    await p.remove('cache_requests_$key');
  }
  
  /// 清除所有缓存
  Future<void> clearAllCache() async {
    final p = await prefs;
    final keys = p.getKeys().where((key) => key.startsWith('cache_')).toList();
    for (final key in keys) {
      await p.remove(key);
    }
  }
  
  // ==================== 应用数据统计 ====================
  
  /// 保存应用使用统计
  Future<void> saveAppStats(Map<String, dynamic> stats) async {
    final p = await prefs;
    await p.setString('app_stats', json.encode(stats));
  }
  
  /// 获取应用使用统计
  Future<Map<String, dynamic>> getAppStats() async {
    final p = await prefs;
    final statsJson = p.getString('app_stats');
    if (statsJson != null) {
      return json.decode(statsJson);
    }
    return {
      'launch_count': 0,
      'last_launch': null,
      'total_usage_time': 0,
      'published_requests': 0,
      'accepted_requests': 0,
      'completed_requests': 0,
    };
  }
  
  /// 增加启动次数
  Future<void> incrementLaunchCount() async {
    final stats = await getAppStats();
    stats['launch_count'] = (stats['launch_count'] ?? 0) + 1;
    stats['last_launch'] = DateTime.now().toIso8601String();
    await saveAppStats(stats);
  }
  
  /// 更新使用时长
  Future<void> updateUsageTime(int seconds) async {
    final stats = await getAppStats();
    stats['total_usage_time'] = (stats['total_usage_time'] ?? 0) + seconds;
    await saveAppStats(stats);
  }
  
  // ==================== 草稿保存 ====================
  
  /// 保存发布需求草稿
  Future<void> savePublishDraft(Map<String, dynamic> draft) async {
    final p = await prefs;
    await p.setString('publish_draft', json.encode(draft));
  }
  
  /// 获取发布需求草稿
  Future<Map<String, dynamic>?> getPublishDraft() async {
    final p = await prefs;
    final draftJson = p.getString('publish_draft');
    if (draftJson != null) {
      return json.decode(draftJson);
    }
    return null;
  }
  
  /// 清除发布需求草稿
  Future<void> clearPublishDraft() async {
    final p = await prefs;
    await p.remove('publish_draft');
  }
  
  // ==================== 数据清理 ====================
  
  /// 清除所有用户数据
  Future<void> clearAllUserData() async {
    await clearUser();
    await clearToken();
    await clearSearchHistory();
    await clearAllCache();
    await clearPublishDraft();
  }
  
  /// 获取存储大小（估算）
  Future<int> getStorageSize() async {
    final p = await prefs;
    int totalSize = 0;
    
    for (final key in p.getKeys()) {
      final value = p.get(key);
      if (value is String) {
        totalSize += value.length;
      } else if (value is List<String>) {
        totalSize += value.join('').length;
      }
    }
    
    return totalSize;
  }
  
  /// 获取存储信息
  Future<Map<String, dynamic>> getStorageInfo() async {
    final p = await prefs;
    final keys = p.getKeys();
    
    int userDataSize = 0;
    int cacheSize = 0;
    int settingsSize = 0;
    
    for (final key in keys) {
      final value = p.get(key);
      int size = 0;
      
      if (value is String) {
        size = value.length;
      } else if (value is List<String>) {
        size = value.join('').length;
      }
      
      if (key.startsWith('cache_')) {
        cacheSize += size;
      } else if (key.contains('user') || key.contains('token')) {
        userDataSize += size;
      } else {
        settingsSize += size;
      }
    }
    
    return {
      'total_keys': keys.length,
      'user_data_size': userDataSize,
      'cache_size': cacheSize,
      'settings_size': settingsSize,
      'total_size': userDataSize + cacheSize + settingsSize,
    };
  }
}