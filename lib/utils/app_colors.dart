import 'package:flutter/cupertino.dart';

/// 硬帮帮应用颜色配置
/// 基于设计规范中的iOS风格颜色系统
class AppColors {
  // 主色调
  static const Color primaryOrange = Color(0xFFF97316); // orange-500
  static const Color secondaryOrange = Color(0xFFEA580C); // orange-600 (别名)
  static const Color darkOrange = Color(0xFFEA580C);    // orange-600
  static const Color primaryBlue = Color(0xFF3B82F6);   // blue-500
  
  // 辅助色
  static const Color successGreen = Color(0xFF10B981);  // emerald-500
  static const Color warningYellow = Color(0xFFF59E0B); // amber-500
  static const Color errorRed = Color(0xFFEF4444);      // red-500
  
  // 中性色
  static const Color darkGray = Color(0xFF1F2937);      // gray-800
  static const Color mediumGray = Color(0xFF6B7280);    // gray-500
  static const Color lightGray = Color(0xFFF3F4F6);     // gray-100
  static const Color white = Color(0xFFFFFFFF);
  
  // iOS系统颜色适配
  static const Color systemBackground = CupertinoColors.systemBackground;
  static const Color systemGroupedBackground = CupertinoColors.systemGroupedBackground;
  static const Color label = CupertinoColors.label;
  static const Color secondaryLabel = CupertinoColors.secondaryLabel;
  static const Color separator = CupertinoColors.separator;
  
  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, darkOrange],
  );
  
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFF7931E),
      Color(0xFFFFAB00),
    ],
  );
}