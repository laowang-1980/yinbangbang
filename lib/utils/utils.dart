import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// 通用工具类
/// 提供常用的辅助功能和工具方法
class Utils {
  // 私有构造函数，防止实例化
  Utils._();
  
  // ==================== 时间格式化 ====================
  
  /// 格式化时间显示
  static String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return DateFormat('MM-dd').format(dateTime);
    }
  }
  
  /// 格式化详细时间
  static String formatDetailTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (dateOnly == today) {
      return '今天 ${DateFormat('HH:mm').format(dateTime)}';
    } else if (dateOnly == yesterday) {
      return '昨天 ${DateFormat('HH:mm').format(dateTime)}';
    } else if (now.year == dateTime.year) {
      return DateFormat('MM-dd HH:mm').format(dateTime);
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }
  }
  
  /// 格式化剩余时间
  static String formatRemainingTime(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    
    if (difference.isNegative) {
      return '已过期';
    }
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天后';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时后';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟后';
    } else {
      return '即将到期';
    }
  }
  
  /// 格式化日期范围
  static String formatDateRange(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return DateFormat('yyyy-MM-dd').format(start);
    } else if (start.year == end.year) {
      return '${DateFormat('MM-dd').format(start)} - ${DateFormat('MM-dd').format(end)}';
    } else {
      return '${DateFormat('yyyy-MM-dd').format(start)} - ${DateFormat('yyyy-MM-dd').format(end)}';
    }
  }
  
  // ==================== 数字格式化 ====================
  
  /// 格式化金额
  static String formatMoney(double amount) {
    if (amount == amount.roundToDouble()) {
      return '¥${amount.round()}';
    } else {
      return '¥${amount.toStringAsFixed(2)}';
    }
  }
  
  /// 格式化数量
  static String formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 10000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(count / 10000).toStringAsFixed(1)}w';
    }
  }
  
  /// 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }
  
  // ==================== 字符串处理 ====================
  
  /// 验证手机号
  static bool isValidPhone(String phone) {
    final regex = RegExp(r'^1[3-9]\d{9}$');
    return regex.hasMatch(phone);
  }
  
  /// 验证邮箱
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
  
  /// 验证身份证号
  static bool isValidIdCard(String idCard) {
    final regex = RegExp(r'^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$');
    return regex.hasMatch(idCard);
  }
  
  /// 脱敏手机号
  static String maskPhone(String phone) {
    if (phone.length != 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }
  
  /// 脱敏身份证号
  static String maskIdCard(String idCard) {
    if (idCard.length != 18) return idCard;
    return '${idCard.substring(0, 6)}********${idCard.substring(14)}';
  }
  
  /// 截取字符串
  static String truncateString(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }
  
  /// 移除HTML标签
  static String removeHtmlTags(String html) {
    final regex = RegExp(r'<[^>]*>');
    return html.replaceAll(regex, '');
  }
  
  // ==================== 颜色处理 ====================
  
  /// 十六进制颜色转Color
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
  
  /// Color转十六进制
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
  
  /// 获取对比色
  static Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? CupertinoColors.black : CupertinoColors.white;
  }
  
  // ==================== 设备信息 ====================
  
  /// 获取屏幕宽度
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  /// 获取屏幕高度
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  /// 获取状态栏高度
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
  
  /// 获取底部安全区域高度
  static double getBottomSafeHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
  
  /// 判断是否为小屏设备
  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 375;
  }
  
  /// 判断是否为平板
  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) > 600;
  }
  
  // ==================== 交互功能 ====================
  
  /// 显示Toast消息
  static void showToast(BuildContext context, String message, {bool isError = false}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  /// 显示确认对话框
  static Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String content, {
    String confirmText = '确定',
    String cancelText = '取消',
  }) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
  
  /// 显示加载对话框
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CupertinoActivityIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }
  
  /// 隐藏对话框
  static void hideDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  /// 复制到剪贴板
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
  
  /// 从剪贴板获取文本
  static Future<String?> getClipboardText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
  
  /// 震动反馈
  static void vibrate() {
    HapticFeedback.lightImpact();
  }
  
  /// 强震动反馈
  static void vibrateHeavy() {
    HapticFeedback.heavyImpact();
  }
  
  // ==================== 外部应用调用 ====================
  
  /// 拨打电话
  static Future<void> makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  
  /// 发送短信
  static Future<void> sendSMS(String phoneNumber, {String? message}) async {
    final uri = Uri.parse('sms:$phoneNumber${message != null ? '?body=$message' : ''}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  
  /// 发送邮件
  static Future<void> sendEmail(String email, {String? subject, String? body}) async {
    final uri = Uri.parse('mailto:$email?subject=${subject ?? ''}&body=${body ?? ''}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  
  /// 打开网页
  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  
  /// 打开地图
  static Future<void> openMap(double latitude, double longitude, {String? label}) async {
    final uri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude(${label ?? ''})');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  
  // ==================== 数据处理 ====================
  
  /// 深拷贝Map
  static Map<String, dynamic> deepCopyMap(Map<String, dynamic> original) {
    final Map<String, dynamic> copy = {};
    for (final entry in original.entries) {
      if (entry.value is Map<String, dynamic>) {
        copy[entry.key] = deepCopyMap(entry.value);
      } else if (entry.value is List) {
        copy[entry.key] = List.from(entry.value);
      } else {
        copy[entry.key] = entry.value;
      }
    }
    return copy;
  }
  
  /// 合并Map
  static Map<String, dynamic> mergeMaps(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    final result = Map<String, dynamic>.from(map1);
    for (final entry in map2.entries) {
      if (result.containsKey(entry.key) && 
          result[entry.key] is Map<String, dynamic> && 
          entry.value is Map<String, dynamic>) {
        result[entry.key] = mergeMaps(result[entry.key], entry.value);
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
  
  /// 生成随机字符串
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(length, (index) => chars[(random + index) % chars.length]).join();
  }
  
  /// 生成UUID
  static String generateUUID() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp.hashCode;
    return '$timestamp-$random';
  }
  
  // ==================== 调试工具 ====================
  
  /// 打印调试信息
  static void debugPrint(String message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('$prefix$message');
  }
  
  /// 打印错误信息
  static void debugError(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('${prefix}ERROR: $message');
    if (error != null) {
      debugPrint('Error details: $error');
    }
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}