import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../models/user_model.dart';
import 'register_screen.dart';

/// 个人中心页面
/// 对应原型图中的profile.html
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: Text(
          '我的',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          CupertinoIcons.settings,
          color: CupertinoColors.secondaryLabel,
        ),
      ),
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        final user = userProvider.currentUser;
        
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppConstants.spacingBoxLarge,
                
                // 用户信息卡片
                _buildUserInfoCard(user),
                const SizedBox(height: 20),
                
                // 统计信息
                _buildStatsSection(),
                const SizedBox(height: 20),
                
                // 功能菜单
                _buildMenuSection(),
                const SizedBox(height: 20),
                
                // 其他功能
                _buildOtherSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUserInfoCard(UserModel? user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: AppConstants.paddingLarge,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: user != null ? _buildLoggedInUserInfo(user) : _buildLoginPrompt(),
    );
  }

  Widget _buildLoggedInUserInfo(UserModel user) {
    return Row(
      children: [
        // 头像
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: user.avatar != null
              ? ClipOval(
                  child: Image.network(
                    user.avatar!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        CupertinoIcons.person_fill,
                        color: CupertinoColors.white,
                        size: 30,
                      );
                    },
                  ),
                )
              : const Icon(
                  CupertinoIcons.person_fill,
                  color: CupertinoColors.white,
                  size: 30,
                ),
        ),
        AppConstants.spacingBoxHorizontalRegular,
        
        // 用户信息
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                  AppConstants.spacingBoxHorizontalSmall,
                  if (user.isVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '已认证',
                        style: TextStyle(
                          fontSize: 10,
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (user.isStudent)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '学生',
                        style: TextStyle(
                          fontSize: 10,
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                user.phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.star_fill,
                    size: 16,
                    color: AppColors.warningYellow,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '信用分: ${user.creditScore}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.warningYellow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // 编辑按钮
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _editProfile,
          child: const Icon(
            CupertinoIcons.pencil_circle,
            color: CupertinoColors.secondaryLabel,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemGrey4,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            CupertinoIcons.person,
            color: CupertinoColors.secondaryLabel,
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '登录后享受更多服务',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.label,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '发布需求、接单赚钱、查看订单',
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
        const SizedBox(height: 16),
        CupertinoButton(
          onPressed: _goToLogin,
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: const Text(
            '立即登录',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: CupertinoIcons.doc_text,
              title: '发布的',
              count: '12',
              color: AppColors.primaryOrange,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: CupertinoColors.separator,
          ),
          Expanded(
            child: _buildStatItem(
              icon: CupertinoIcons.hand_raised,
              title: '接受的',
              count: '8',
              color: AppColors.successGreen,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: CupertinoColors.separator,
          ),
          Expanded(
            child: _buildStatItem(
              icon: CupertinoIcons.checkmark_circle,
              title: '完成的',
              count: '15',
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: CupertinoIcons.person_badge_plus,
            title: '实名认证',
            subtitle: '提升信用，获得更多机会',
            onTap: _goToVerification,
            showBadge: true,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: CupertinoIcons.person_2_square_stack,
            title: '学生认证',
            subtitle: '享受学生专属优惠',
            onTap: _goToStudentVerification,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: CupertinoIcons.location,
            title: '地址管理',
            subtitle: '管理常用地址',
            onTap: _goToAddressManagement,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: CupertinoIcons.money_dollar_circle,
            title: '我的钱包',
            subtitle: '查看收益和提现',
            onTap: _goToWallet,
          ),
        ],
      ),
    );
  }

  Widget _buildOtherSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: CupertinoIcons.moon,
            title: '主题设置',
            subtitle: '切换白天/夜晚模式',
            onTap: _showThemeSettings,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: CupertinoIcons.question_circle,
            title: '帮助中心',
            subtitle: '常见问题解答',
            onTap: _goToHelp,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: CupertinoIcons.phone,
            title: '联系客服',
            subtitle: '遇到问题随时联系我们',
            onTap: _contactSupport,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: CupertinoIcons.doc_text,
            title: '用户协议',
            subtitle: '查看服务条款',
            onTap: _showUserAgreement,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: CupertinoIcons.info_circle,
            title: '关于我们',
            subtitle: '了解硬帮帮',
            onTap: _showAbout,
          ),
          if (context.read<UserProvider>().currentUser != null) ...[
            _buildDivider(),
            _buildMenuItem(
              icon: CupertinoIcons.square_arrow_right,
              title: '退出登录',
              subtitle: '',
              onTap: _logout,
              textColor: AppColors.errorRed,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showBadge = false,
    Color? textColor,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (textColor ?? AppColors.primaryOrange).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: textColor ?? AppColors.primaryOrange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor ?? CupertinoColors.label,
                      ),
                    ),
                    if (showBadge) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.errorRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            color: CupertinoColors.secondaryLabel,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 76),
      height: 0.5,
      color: CupertinoColors.separator,
    );
  }

  void _editProfile() {
    // 导航到编辑资料页面（功能待实现）
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('编辑资料'),
        content: const Text('编辑资料功能开发中...'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  void _goToVerification() {
    // 导航到实名认证页面（功能待实现）
    _showComingSoon('实名认证');
  }

  void _goToStudentVerification() {
    // 导航到学生认证页面（功能待实现）
    _showComingSoon('学生认证');
  }

  void _goToAddressManagement() {
    // 导航到地址管理页面（功能待实现）
    _showComingSoon('地址管理');
  }

  void _goToWallet() {
    // 导航到钱包页面（功能待实现）
    _showComingSoon('我的钱包');
  }

  void _showThemeSettings() {
    final themeProvider = context.read<ThemeProvider>();
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          '主题设置',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        message: const Text('选择您喜欢的主题模式'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              themeProvider.setThemeMode(ThemeMode.light);
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.sun_max,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  '白天模式',
                  style: TextStyle(
                    color: themeProvider.themeMode == ThemeMode.light
                        ? AppColors.primaryOrange
                        : CupertinoColors.label,
                    fontWeight: themeProvider.themeMode == ThemeMode.light
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (themeProvider.themeMode == ThemeMode.light)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      CupertinoIcons.checkmark,
                      color: AppColors.primaryOrange,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              themeProvider.setThemeMode(ThemeMode.dark);
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.moon,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  '夜晚模式',
                  style: TextStyle(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? AppColors.primaryOrange
                        : CupertinoColors.label,
                    fontWeight: themeProvider.themeMode == ThemeMode.dark
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (themeProvider.themeMode == ThemeMode.dark)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      CupertinoIcons.checkmark,
                      color: AppColors.primaryOrange,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              themeProvider.setThemeMode(ThemeMode.system);
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.device_phone_portrait,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  '跟随系统',
                  style: TextStyle(
                    color: themeProvider.themeMode == ThemeMode.system
                        ? AppColors.primaryOrange
                        : CupertinoColors.label,
                    fontWeight: themeProvider.themeMode == ThemeMode.system
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (themeProvider.themeMode == ThemeMode.system)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      CupertinoIcons.checkmark,
                      color: AppColors.primaryOrange,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ),
    );
  }

  void _goToHelp() {
    // 导航到帮助中心页面（功能待实现）
    _showComingSoon('帮助中心');
  }

  void _contactSupport() {
    // 联系客服功能（功能待实现）
    _showComingSoon('联系客服');
  }

  void _showUserAgreement() {
    // 显示用户协议（功能待实现）
    _showComingSoon('用户协议');
  }

  void _showAbout() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('关于硬帮帮'),
        content: const Text(
          '硬帮帮是一个校园互助平台，致力于为大学生提供便捷的互助服务。\n\n版本：1.0.0\n开发者：硬帮帮团队',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserProvider>().logout();
            },
            isDestructiveAction: true,
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(feature),
        content: const Text('功能开发中，敬请期待...'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}