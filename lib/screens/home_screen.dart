import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../providers/user_provider.dart';
import '../providers/request_provider.dart';
import '../models/request_model.dart';
import '../widgets/request_card.dart';
import 'publish_screen.dart';
import 'requests_screen.dart';
import 'profile_screen.dart';
import 'orders_screen.dart';

/// 首页
/// 对应原型图中的home.html
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const _HomePage(),
    const RequestsScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        activeColor: AppColors.primaryOrange,
        inactiveColor: CupertinoColors.inactiveGray,
        backgroundColor: CupertinoColors.systemBackground,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            activeIcon: Icon(CupertinoIcons.list_bullet),
            label: '需求',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text),
            activeIcon: Icon(CupertinoIcons.doc_text_fill),
            label: '订单',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: '我的',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => _pages[index],
        );
      },
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RequestProvider>(context, listen: false).fetchNearbyRequests();
    });
  }

  void _navigateToPublish() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const PublishScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 顶部导航栏
              CupertinoSliverNavigationBar(
                backgroundColor: CupertinoColors.systemBackground,
                border: null,
                largeTitle: const Text('硬帮帮'),
                leading: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: CupertinoColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: SvgPicture.asset(
                              'assets/images/logo.svg',
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        AppConstants.spacingBoxHorizontalSmall,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '硬帮帮',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.label,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.location_solid,
                                  size: 12,
                                  color: CupertinoColors.secondaryLabel,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  userProvider.currentUser?.location ?? '定位中...',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: const Badge(
                        label: Text('3'),
                        child: Icon(
                          CupertinoIcons.bell,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: const Icon(
                        CupertinoIcons.search,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 用户状态卡片
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final user = userProvider.currentUser;
                      if (user == null) return const SizedBox.shrink();
                      
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: AppConstants.borderRadiusRegular,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                shape: BoxShape.circle,
                                border: user.isVerified
                                    ? Border.all(
                                        color: AppColors.successGreen,
                                        width: 2,
                                      )
                                    : null,
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
                                            color: CupertinoColors.secondaryLabel,
                                            size: 30,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      CupertinoIcons.person_fill,
                                      color: CupertinoColors.secondaryLabel,
                                      size: 30,
                                    ),
                            ),
                            AppConstants.spacingBoxHorizontalRegular,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (user.isVerified) ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          CupertinoIcons.checkmark_seal_fill,
                                          color: AppColors.successGreen,
                                          size: 16,
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.star_fill,
                                        color: CupertinoColors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '信用分 ${user.creditScore.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.forward,
                              color: CupertinoColors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // 快速功能入口
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          icon: CupertinoIcons.add_circled_solid,
                          title: '发布需求',
                          subtitle: '快速发布',
                          color: AppColors.primaryOrange,
                          onTap: _navigateToPublish,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          icon: CupertinoIcons.list_bullet_below_rectangle,
                          title: '接单赚钱',
                          subtitle: '帮助他人',
                          color: AppColors.successGreen,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 附近需求标题
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    children: [
                      Text(
                        '附近需求',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.label,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        CupertinoIcons.location_solid,
                        color: AppColors.primaryOrange,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '2km内',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 附近需求列表
              Consumer<RequestProvider>(
                builder: (context, requestProvider, child) {
                  if (requestProvider.isLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    );
                  }
                  
                  final requests = requestProvider.nearbyRequests
                      .where((r) => r.status == RequestStatus.pending && !r.isExpired)
                      .take(5)
                      .toList();
                  
                  if (requests.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(32),
                        decoration: const BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: AppConstants.borderRadiusRegular,
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              CupertinoIcons.location_circle,
                              size: 48,
                              color: CupertinoColors.inactiveGray,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '附近暂无需求',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '成为第一个发布需求的人吧！',
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.tertiaryLabel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            index == 0 ? 0 : 8,
                            16,
                            index == requests.length - 1 ? 16 : 8,
                          ),
                          child: RequestCard(request: requests[index]),
                        );
                      },
                      childCount: requests.length,
                    ),
                  );
                },
              ),
            ],
          ),
          
          // 浮动发布按钮
          Positioned(
            bottom: 100,
            right: 16,
            child: CupertinoButton(
              onPressed: _navigateToPublish,
              padding: EdgeInsets.zero,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: CupertinoColors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: AppConstants.borderRadiusRegular,
          border: Border.all(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.forward,
              color: CupertinoColors.tertiaryLabel,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}