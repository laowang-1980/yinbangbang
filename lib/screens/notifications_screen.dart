import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/app_colors.dart';

/// 通知页面
/// 对应原型图中的notifications.html
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<NotificationModel> _systemNotifications = [];
  final List<NotificationModel> _messageNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    // 模拟加载通知数据
    final now = DateTime.now();
    
    _systemNotifications.addAll([
      NotificationModel(
        id: '1',
        type: NotificationType.system,
        title: '欢迎使用硬帮帮',
        content: '感谢您注册硬帮帮，开始您的互助之旅吧！',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.system,
        title: '实名认证提醒',
        content: '完成实名认证可以提升您的信用分，获得更多接单机会。',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.system,
        title: '系统维护通知',
        content: '系统将于今晚23:00-01:00进行维护，期间可能影响部分功能使用。',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ]);
    
    _messageNotifications.addAll([
      NotificationModel(
        id: '4',
        type: NotificationType.order,
        title: '有人接受了您的需求',
        content: '您发布的"帮忙取快递"已被小李接受，请及时联系。',
        timestamp: now.subtract(const Duration(minutes: 10)),
        isRead: false,
        avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.message,
        title: '收到新消息',
        content: '张同学：任务已经完成了，请确认一下。',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: false,
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.payment,
        title: '收益到账',
        content: '您完成的"帮忙搬东西"任务，收益15元已到账。',
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: true,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: const Text(
          '通知',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _markAllAsRead,
          child: const Text(
            '全部已读',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryOrange,
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          // 标签栏
          Container(
            color: CupertinoColors.systemBackground,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: AppConstants.borderRadiusSmall,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _tabController.animateTo(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _currentIndex == 0
                                  ? CupertinoColors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: _currentIndex == 0
                                  ? [
                                      BoxShadow(
                                        color: CupertinoColors.systemGrey
                                            .withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '系统通知',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _currentIndex == 0
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _currentIndex == 0
                                        ? AppColors.primaryOrange
                                        : CupertinoColors.secondaryLabel,
                                  ),
                                ),
                                if (_getUnreadCount(_systemNotifications) > 0) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: const BoxDecoration(
                                      color: AppColors.errorRed,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Text(
                                      '${_getUnreadCount(_systemNotifications)}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: CupertinoColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _tabController.animateTo(1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _currentIndex == 1
                                  ? CupertinoColors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: _currentIndex == 1
                                  ? [
                                      BoxShadow(
                                        color: CupertinoColors.systemGrey
                                            .withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '消息通知',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _currentIndex == 1
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: _currentIndex == 1
                                        ? AppColors.primaryOrange
                                        : CupertinoColors.secondaryLabel,
                                  ),
                                ),
                                if (_getUnreadCount(_messageNotifications) > 0) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: const BoxDecoration(
                                      color: AppColors.errorRed,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Text(
                                      '${_getUnreadCount(_messageNotifications)}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: CupertinoColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  color: CupertinoColors.separator,
                ),
              ],
            ),
          ),
          
          // 内容区域
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(_systemNotifications),
                _buildNotificationList(_messageNotifications),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.bell,
              size: 64,
              color: CupertinoColors.systemGrey3,
            ),
            SizedBox(height: 16),
            Text(
              '暂无通知',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '有新通知时会在这里显示',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.tertiaryLabel,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildNotificationCard(notification),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return GestureDetector(
      onTap: () => _markAsRead(notification),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? CupertinoColors.systemBackground
              : AppColors.primaryOrange.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: notification.isRead
              ? null
              : Border.all(
                  color: AppColors.primaryOrange.withValues(alpha: 0.2),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图标或头像
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: notification.avatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        notification.avatar!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getNotificationIcon(notification.type),
                            color: _getNotificationColor(notification.type),
                            size: 20,
                          );
                        },
                      ),
                    )
                  : Icon(
                      _getNotificationIcon(notification.type),
                      color: _getNotificationColor(notification.type),
                      size: 20,
                    ),
            ),
            const SizedBox(width: 12),
            
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(notification.timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.tertiaryLabel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return CupertinoIcons.bell;
      case NotificationType.order:
        return CupertinoIcons.doc_text;
      case NotificationType.message:
        return CupertinoIcons.chat_bubble;
      case NotificationType.payment:
        return CupertinoIcons.money_dollar_circle;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return AppColors.primaryBlue;
      case NotificationType.order:
        return AppColors.primaryOrange;
      case NotificationType.message:
        return AppColors.successGreen;
      case NotificationType.payment:
        return AppColors.warningYellow;
    }
  }

  int _getUnreadCount(List<NotificationModel> notifications) {
    return notifications.where((n) => !n.isRead).length;
  }

  void _markAsRead(NotificationModel notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _systemNotifications) {
        notification.isRead = true;
      }
      for (var notification in _messageNotifications) {
        notification.isRead = true;
      }
    });
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}

/// 通知模型
class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String content;
  final DateTime timestamp;
  bool isRead;
  final String? avatar;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.avatar,
  });
}

/// 通知类型
enum NotificationType {
  system,   // 系统通知
  order,    // 订单通知
  message,  // 消息通知
  payment,  // 支付通知
}