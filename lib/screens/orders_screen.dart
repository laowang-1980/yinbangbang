import 'package:flutter/cupertino.dart';
import '../utils/app_constants.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/request_provider.dart';
import '../models/request_model.dart';
import 'request_detail_screen.dart';

/// 订单页面
/// 对应原型图中的orders.html
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // 加载订单数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestProvider>().fetchMyRequests();
      context.read<RequestProvider>().fetchMyAcceptedRequests();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: Text(
          '我的订单',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
                          onTap: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _currentIndex == 0
                                  ? CupertinoColors.white
                                  : CupertinoColors.systemBackground.withValues(alpha: 0.0),
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
                            child: Text(
                              '我发布的',
                              textAlign: TextAlign.center,
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
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _currentIndex == 1
                                  ? CupertinoColors.white
                                  : CupertinoColors.systemBackground.withValues(alpha: 0.0),
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
                            child: Text(
                              '我接受的',
                              textAlign: TextAlign.center,
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
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildMyPublishedTab(),
                _buildMyAcceptedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPublishedTab() {
    return Consumer<RequestProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }

      final myRequests = provider.myRequests;
      
      if (myRequests.isEmpty) {
        return _buildEmptyState(
          icon: CupertinoIcons.doc_text,
          title: '暂无发布的需求',
          subtitle: '快去发布你的第一个需求吧',
        );
      }

      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await provider.fetchMyRequests();
            },
          ),
          SliverPadding(
             padding: const EdgeInsets.all(16),
             sliver: SliverList(
               delegate: SliverChildBuilderDelegate(
                 (context, index) {
                   final request = myRequests[index];
                   return Padding(
                     padding: const EdgeInsets.only(bottom: 12),
                     child: _buildOrderCard(request, true),
                   );
                 },
                 childCount: myRequests.length,
               ),
             ),
           ),
         ],
       );
    });
  }

  Widget _buildMyAcceptedTab() {
    return Consumer<RequestProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }

      final acceptedRequests = provider.myAcceptedRequests;
      
      if (acceptedRequests.isEmpty) {
        return _buildEmptyState(
          icon: CupertinoIcons.hand_raised,
          title: '暂无接受的需求',
          subtitle: '快去接单赚钱吧',
        );
      }

      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await provider.fetchMyAcceptedRequests();
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final request = acceptedRequests[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildOrderCard(request, false),
                  );
                },
                childCount: acceptedRequests.length,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOrderCard(RequestModel request, bool isPublisher) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => RequestDetailScreen(request: request),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题和状态
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusTag(request.status),
              ],
            ),
            const SizedBox(height: 8),
            
            // 描述
            Text(
              request.description,
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // 报酬和位置
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '¥${request.reward}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  CupertinoIcons.location,
                  size: 14,
                  color: CupertinoColors.secondaryLabel,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 时间和操作
            Row(
              children: [
                Text(
                  _formatTime(request.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.tertiaryLabel,
                  ),
                ),
                const Spacer(),
                if (request.status == RequestStatus.pending && isPublisher)
                  _buildActionButton(
                    '编辑',
                    CupertinoIcons.pencil,
                    () => _editRequest(request),
                  ),
                if (request.status == RequestStatus.inProgress)
                  _buildActionButton(
                    isPublisher ? '联系接单者' : '联系发布者',
                    CupertinoIcons.chat_bubble,
                    () => _contactUser(request, isPublisher),
                  ),
                if (request.status == RequestStatus.inProgress && !isPublisher)
                  _buildActionButton(
                    '完成任务',
                    CupertinoIcons.checkmark_circle,
                    () => _completeRequest(request),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(RequestStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;
    
    switch (status) {
      case RequestStatus.pending:
        backgroundColor = AppColors.warningYellow.withValues(alpha: 0.1);
        textColor = AppColors.warningYellow;
        text = '待接单';
        break;
      case RequestStatus.accepted:
        backgroundColor = AppColors.primaryBlue.withValues(alpha: 0.1);
        textColor = AppColors.primaryBlue;
        text = '已接单';
        break;
      case RequestStatus.inProgress:
        backgroundColor = AppColors.primaryOrange.withValues(alpha: 0.1);
        textColor = AppColors.primaryOrange;
        text = '进行中';
        break;
      case RequestStatus.completed:
        backgroundColor = AppColors.successGreen.withValues(alpha: 0.1);
        textColor = AppColors.successGreen;
        text = '已完成';
        break;
      case RequestStatus.cancelled:
        backgroundColor = AppColors.errorRed.withValues(alpha: 0.1);
        textColor = AppColors.errorRed;
        text = '已取消';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primaryOrange,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: CupertinoColors.systemGrey3,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.tertiaryLabel,
            ),
          ),
        ],
      ),
    );
  }

  void _editRequest(RequestModel request) {
    // 导航到编辑需求页面（功能待实现）
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('编辑需求'),
        content: const Text('编辑功能开发中...'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _contactUser(RequestModel request, bool isPublisher) {
    // 导航到聊天页面（功能待实现）
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('联系用户'),
        content: const Text('聊天功能开发中...'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _completeRequest(RequestModel request) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('完成任务'),
        content: const Text('确认已完成此任务？'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<RequestProvider>().completeRequest(request.id);
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
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