import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题模式枚举
enum ThemeMode {
  light,    // 白天模式
  dark,     // 夜晚模式
  system,   // 跟随系统
}

/// 主题管理Provider
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light; // 默认白天主题
  
  ThemeMode get themeMode => _themeMode;
  
  /// 获取当前是否为暗黑模式
  bool get isDarkMode {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        // 获取系统主题设置
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }
  
  /// 获取当前Brightness
  Brightness get brightness => isDarkMode ? Brightness.dark : Brightness.light;
  
  /// 初始化主题设置
  Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0; // 默认为0（白天模式）
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }
  
  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    
    // 保存到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    
    notifyListeners();
  }
  
  /// 获取主题模式的显示名称
  String getThemeModeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '白天模式';
      case ThemeMode.dark:
        return '夜晚模式';
      case ThemeMode.system:
        return '跟随系统';
    }
  }
  
  /// 获取当前主题模式的显示名称
  String get currentThemeDisplayName => getThemeModeDisplayName(_themeMode);
}