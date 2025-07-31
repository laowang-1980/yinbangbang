import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// 用户状态管理Provider
class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 设置错误信息
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// 用户登录
  Future<bool> login(String phone, String verificationCode) async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟登录成功，创建用户数据
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: '张三',
        phone: phone,
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        location: '中关村软件园',
        creditScore: 4.8,
        rating: 4.8,
        isVerified: true,
        isStudentVerified: false,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      
      _isLoggedIn = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('登录失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 用户注册
  Future<bool> register({
    required String phone,
    required String verificationCode,
    required String name,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟注册成功，创建用户数据
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        phone: phone,
        avatar: null,
        location: null,
        creditScore: 5.0,
        rating: 5.0,
        isVerified: false,
        isStudentVerified: false,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      
      _isLoggedIn = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('注册失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟发送成功
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('发送验证码失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 更新用户信息
  Future<bool> updateProfile({
    String? name,
    String? avatar,
    String? location,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = _currentUser!.copyWith(
        name: name,
        avatar: avatar,
        location: location,
      );
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('更新失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 实名认证
  Future<bool> verifyIdentity({
    required String realName,
    required String idCard,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = _currentUser!.copyWith(
        isVerified: true,
      );
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('认证失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 学生认证
  Future<bool> verifyStudent({
    required String studentId,
    required String school,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = _currentUser!.copyWith(
        isStudentVerified: true,
      );
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('学生认证失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 用户登出
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}