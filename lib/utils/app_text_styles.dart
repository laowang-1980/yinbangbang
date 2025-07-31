import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'app_constants.dart';

/// 硬帮帮应用文本样式系统
/// 基于iOS Human Interface Guidelines设计
class AppTextStyles {
  // 私有构造函数，防止实例化
  AppTextStyles._();

  /// 基础文本样式
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: '.SF Pro Text', // iOS系统字体
    fontWeight: FontWeight.normal,
    color: AppColors.label,
    height: 1.4, // 行高
  );

  /// 标题样式
  static final TextStyle displayLarge = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeDisplay,
    fontWeight: FontWeight.bold,
    color: AppColors.label,
  );

  static final TextStyle displayMedium = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeTitle,
    fontWeight: FontWeight.bold,
    color: AppColors.label,
  );

  static final TextStyle displaySmall = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXXLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  /// 标题样式
  static final TextStyle headlineLarge = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  static final TextStyle headlineMedium = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  static final TextStyle headlineSmall = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  /// 正文样式
  static final TextStyle bodyLarge = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.normal,
    color: AppColors.label,
  );

  static final TextStyle bodyMedium = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.label,
  );

  static final TextStyle bodySmall = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryLabel,
  );

  /// 标签样式
  static final TextStyle labelLarge = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: AppColors.label,
  );

  static final TextStyle labelMedium = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeSmall,
    fontWeight: FontWeight.w500,
    color: AppColors.label,
  );

  static final TextStyle labelSmall = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXSmall,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryLabel,
  );

  /// 按钮样式
  static final TextStyle buttonLarge = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle buttonMedium = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle buttonSmall = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  /// 特殊用途样式
  static final TextStyle caption = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryLabel,
  );

  static final TextStyle overline = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXSmall,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryLabel,
    letterSpacing: 0.5,
  );

  /// 价格样式
  static final TextStyle priceSmall = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryOrange,
  );

  static final TextStyle priceMedium = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryOrange,
  );

  static final TextStyle priceLarge = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryOrange,
  );

  /// 状态样式
  static final TextStyle success = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: AppColors.successGreen,
  );

  static final TextStyle warning = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: AppColors.warningYellow,
  );

  static final TextStyle error = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: AppColors.errorRed,
  );

  /// 链接样式
  static final TextStyle link = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryBlue,
    decoration: TextDecoration.underline,
  );

  /// 输入框样式
  static final TextStyle input = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.normal,
    color: AppColors.label,
  );

  static final TextStyle inputHint = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryLabel,
  );

  /// 导航栏样式
  static final TextStyle navigationTitle = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  static final TextStyle navigationButton = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryBlue,
  );

  /// Tab Bar样式
  static final TextStyle tabLabel = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXSmall,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryLabel,
  );

  static final TextStyle tabLabelSelected = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeXSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryOrange,
  );

  /// 列表样式
  static final TextStyle listTitle = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.w500,
    color: AppColors.label,
  );

  static final TextStyle listSubtitle = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryLabel,
  );

  static final TextStyle listCaption = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryLabel,
  );

  /// 卡片样式
  static final TextStyle cardTitle = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeRegular,
    fontWeight: FontWeight.w600,
    color: AppColors.label,
  );

  static final TextStyle cardSubtitle = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryLabel,
  );

  static final TextStyle cardBody = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.label,
  );

  /// 徽章样式
  static final TextStyle badge = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// 时间样式
  static final TextStyle timestamp = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryLabel,
  );

  /// 距离样式
  static final TextStyle distance = _baseStyle.copyWith(
    fontSize: AppConstants.fontSizeSmall,
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGray,
  );
}