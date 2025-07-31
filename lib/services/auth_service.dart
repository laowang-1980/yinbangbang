import 'dart:math';

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  // 微信登录（模拟）
  Future<Map<String, dynamic>> loginWithWeChat() async {
    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟微信登录成功
      final random = Random();
      final userId = 'wx_user_${DateTime.now().millisecondsSinceEpoch}';
      final userName = '微信用户${random.nextInt(1000)}';
      
      return {
        'success': true,
        'message': '微信登录成功',
        'token': 'mock_wechat_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': userId,
          'name': userName,
          'avatar': 'https://via.placeholder.com/100x100?text=WX',
          'loginType': 'wechat'
        },
      };
    } catch (e) {
      return {
        'success': false,
        'message': '微信登录失败：$e',
      };
    }
  }

  // 支付宝登录（模拟）
  Future<Map<String, dynamic>> loginWithAlipay() async {
    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟支付宝登录成功
      final random = Random();
      final userId = 'alipay_user_${DateTime.now().millisecondsSinceEpoch}';
      final userName = '支付宝用户${random.nextInt(1000)}';
      
      return {
        'success': true,
        'message': '支付宝登录成功',
        'token': 'mock_alipay_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': userId,
          'name': userName,
          'avatar': 'https://via.placeholder.com/100x100?text=ALI',
          'loginType': 'alipay'
        },
      };
    } catch (e) {
      return {
        'success': false,
        'message': '支付宝登录失败：$e',
      };
    }
  }

  // 退出登录
  Future<void> logout() async {
    // 清除本地存储的用户信息和token
    // 这里可以添加清除SharedPreferences或其他本地存储的逻辑
  }
}