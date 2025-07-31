import 'package:flutter/cupertino.dart';

/// 硬帮帮应用设计系统常量
/// 基于设计规范统一管理UI常量，避免魔法数字
class AppConstants {
  // 私有构造函数，防止实例化
  AppConstants._();

  /// 字体大小
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 32.0;
  static const double fontSizeDisplay = 36.0;

  /// 图标大小
  static const double iconSizeSmall = 12.0;
  static const double iconSizeMedium = 16.0;
  static const double iconSizeRegular = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 30.0;

  /// 间距系统 (基于8px网格)
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingRegular = 16.0;
  static const double spacingLarge = 20.0;
  static const double spacingXLarge = 24.0;
  static const double spacingXXLarge = 32.0;
  static const double spacingXXXLarge = 40.0;
  static const double spacingHuge = 48.0;

  /// 圆角半径
  static const double radiusXSmall = 4.0;
  static const double radiusSmall = 8.0;
  static const double radiusTiny = 6.0;
  static const double radiusXSmall2 = 10.0;
  static const double radiusMedium = 12.0;
  static const double radiusRegular = 16.0;
  static const double radiusLarge18 = 18.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 50.0; // 圆形

  /// 边框宽度
  static const double borderWidthThin = 0.5;
  static const double borderWidthRegular = 1.0;
  static const double borderWidthThick = 2.0;

  /// 阴影
  static const List<BoxShadow> shadowLight = [
    BoxShadow(
      color: Color(0x0F000000), // 6% opacity black
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x26000000), // 15% opacity black
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
  ];

  /// 组件尺寸
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 40.0;
  static const double buttonHeightRegular = 48.0;
  static const double buttonHeightLarge = 56.0;

  static const double inputHeightRegular = 48.0;
  static const double inputHeightLarge = 56.0;

  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 40.0;
  static const double avatarSizeRegular = 48.0;
  static const double avatarSizeLarge = 60.0;
  static const double avatarSizeXLarge = 80.0;
  static const double avatarSizeXXLarge = 120.0;

  /// 导航栏高度
  static const double navigationBarHeight = 44.0;
  static const double tabBarHeight = 83.0; // 含安全区域
  static const double statusBarHeight = 44.0;

  /// 列表项高度
  static const double listItemHeightSmall = 44.0;
  static const double listItemHeightMedium = 56.0;
  static const double listItemHeightLarge = 72.0;

  /// 动画时长
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 250);
  static const Duration animationDurationSlow = Duration(milliseconds: 350);

  /// 业务相关常量
  static const int maxSearchHistoryCount = 10;
  static const int maxChatHistoryCount = 20;
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  static const int defaultTimeoutSeconds = 10;
  static const int paymentTimeoutMinutes = 15;
  static const int defaultTimeLimitMinutes = 60;

  /// 时间选项 (分钟)
  static const List<int> timeLimitOptions = [30, 60, 120, 240, 480];

  /// 距离阈值 (米)
  static const double nearbyDistanceThreshold = 1000.0;
  static const double maxSearchRadius = 5000.0;
  static const double locationUpdateThreshold = 10.0;

  /// 验证码相关
  static const int smsCodeLength = 6;
  static const int smsCountdownSeconds = 60;
  static const int phoneNumberLength = 11;
  static const int idCardLength = 18;

  /// 文本限制
  static const int maxTitleLength = 30;
  static const int maxDescriptionLength = 200;
  static const int maxMessageLength = 500;

  /// 文件大小限制 (字节)
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxAudioSize = 10 * 1024 * 1024; // 10MB

  /// 常用EdgeInsets
  static const EdgeInsets paddingZero = EdgeInsets.zero;
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacingSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingRegular = EdgeInsets.all(spacingRegular);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacingLarge);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(spacingXLarge);

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: spacingSmall);
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: spacingMedium);
  static const EdgeInsets paddingHorizontalRegular = EdgeInsets.symmetric(horizontal: spacingRegular);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: spacingLarge);

  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: spacingSmall);
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: spacingMedium);
  static const EdgeInsets paddingVerticalRegular = EdgeInsets.symmetric(vertical: spacingRegular);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: spacingLarge);

  /// 常用BorderRadius
  static const BorderRadius borderRadiusXSmall = BorderRadius.all(Radius.circular(radiusXSmall));
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderRadiusTiny = BorderRadius.all(Radius.circular(radiusTiny));
  static const BorderRadius borderRadiusXSmall2 = BorderRadius.all(Radius.circular(radiusXSmall2));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusRegular = BorderRadius.all(Radius.circular(radiusRegular));
  static const BorderRadius borderRadiusLarge18 = BorderRadius.all(Radius.circular(radiusLarge18));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(Radius.circular(radiusXLarge));
  static const BorderRadius borderRadiusRound = BorderRadius.all(Radius.circular(radiusRound));

  /// 常用SizedBox
  static const SizedBox spacingBoxXSmall = SizedBox(height: spacingXSmall);
  static const SizedBox spacingBoxSmall = SizedBox(height: spacingSmall);
  static const SizedBox spacingBoxMedium = SizedBox(height: spacingMedium);
  static const SizedBox spacingBoxRegular = SizedBox(height: spacingRegular);
  static const SizedBox spacingBoxLarge = SizedBox(height: spacingLarge);
  static const SizedBox spacingBoxXLarge = SizedBox(height: spacingXLarge);
  static const SizedBox spacingBoxXXLarge = SizedBox(height: spacingXXLarge);

  static const SizedBox spacingBoxHorizontalXSmall = SizedBox(width: spacingXSmall);
  static const SizedBox spacingBoxHorizontalSmall = SizedBox(width: spacingSmall);
  static const SizedBox spacingBoxHorizontalMedium = SizedBox(width: spacingMedium);
  static const SizedBox spacingBoxHorizontalRegular = SizedBox(width: spacingRegular);
  static const SizedBox spacingBoxHorizontalLarge = SizedBox(width: spacingLarge);
  static const SizedBox spacingBoxHorizontalXLarge = SizedBox(width: spacingXLarge);
}