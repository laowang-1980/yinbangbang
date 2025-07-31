import 'package:flutter/cupertino.dart';
import '../utils/app_constants.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../models/request_model.dart';
import '../providers/request_provider.dart';
import '../providers/user_provider.dart';
import 'chat_screen.dart';

/// 需求详情页面
/// 对应原型图中的task_detail.html
class RequestDetailScreen extends StatefulWidget {
  final RequestModel request;

  const RequestDetailScreen({
    super.key,
    required this.request,
  });

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: const Text('需求详情'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showMoreOptions,
          child: const Icon(
            CupertinoIcons.ellipsis_circle,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 需求基本信息
                    _buildRequestInfo(),
                    const SizedBox(height: 16),
                    
                    // 发布者信息
                    _buildPublisherInfo(),
                    const SizedBox(height: 16),
                    
                    // 位置信息
                    _buildLocationInfo(),
                    const SizedBox(height: 16),
                    
                    // 时间信息
                    _buildTimeInfo(),
                    const SizedBox(height: 16),
                    
                    // 接单者信息（如果已被接单）
                    if (widget.request.accepterId != null) ...[
                      _buildAccepterInfo(),
                      const SizedBox(height: 16),
                    ],
                    
                    // 需求状态
                    _buildStatusInfo(),
                  ],
                ),
              ),
            ),
            
            // 底部操作按钮
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分类和状态
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(),
                      color: _getCategoryColor(),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getCategoryName(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 16),
          
          // 标题
          Text(
            widget.request.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 12),
          
          // 描述
          Text(
            widget.request.description,
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          
          // 报酬
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.money_yen_circle_fill,
                  color: CupertinoColors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '任务报酬',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.white,
                      ),
                    ),
                    Text(
                      widget.request.formatReward(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublisherInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '发布者',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.person_fill,
                  color: CupertinoColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          '用户***',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          color: AppColors.successGreen,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          color: AppColors.warningYellow,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '信用分 4.8',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          CupertinoIcons.clock,
                          color: CupertinoColors.secondaryLabel,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatPublishTime(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _contactPublisher,
                child: const Icon(
                  CupertinoIcons.chat_bubble_fill,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '位置信息',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                CupertinoIcons.location_solid,
                color: AppColors.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.request.location,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '距离你 ${widget.request.formatDistance()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _showMap,
                child: const Text(
                  '查看地图',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '时间信息',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                CupertinoIcons.clock,
                color: AppColors.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '发布时间：${_formatDateTime(widget.request.createdAt)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '截止时间：${_formatDateTime(widget.request.deadline)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.request.isExpired ? '已过期' : '剩余 ${_formatTimeRemaining()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.request.isExpired
                            ? AppColors.errorRed
                            : AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccepterInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '接单者',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.person_fill,
                  color: CupertinoColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '用户***',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          color: AppColors.successGreen,
                          size: 16,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.star_fill,
                          color: AppColors.warningYellow,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '信用分 4.9',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _contactAccepter,
                child: const Icon(
                  CupertinoIcons.chat_bubble_fill,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusRegular,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '任务状态',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusTimeline(),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    final steps = [
      {'title': '需求发布', 'completed': true, 'time': widget.request.createdAt},
      {'title': '等待接单', 'completed': widget.request.status != RequestStatus.pending, 'time': null},
      {'title': '任务进行中', 'completed': widget.request.status == RequestStatus.completed, 'time': null},
      {'title': '任务完成', 'completed': widget.request.status == RequestStatus.completed, 'time': null},
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = step['completed'] as bool;
        final isLast = index == steps.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.successGreen : CupertinoColors.systemGrey4,
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? const Icon(
                          CupertinoIcons.checkmark,
                          color: CupertinoColors.white,
                          size: 12,
                        )
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 32,
                    color: isCompleted ? AppColors.successGreen : CupertinoColors.systemGrey4,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? CupertinoColors.label : CupertinoColors.secondaryLabel,
                      ),
                    ),
                    if (step['time'] != null)
                      Text(
                        _formatDateTime(step['time'] as DateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.tertiaryLabel,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color color;
    
    switch (widget.request.status) {
      case RequestStatus.pending:
        if (widget.request.isExpired) {
          text = '已过期';
          color = AppColors.errorRed;
        } else {
          text = '待接单';
          color = AppColors.primaryOrange;
        }
        break;
      case RequestStatus.accepted:
        text = '已接单';
        color = AppColors.primaryBlue;
        break;
      case RequestStatus.inProgress:
        text = '进行中';
        color = AppColors.warningYellow;
        break;
      case RequestStatus.completed:
        text = '已完成';
        color = AppColors.successGreen;
        break;
      case RequestStatus.cancelled:
        text = '已取消';
        color = CupertinoColors.inactiveGray;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    final user = Provider.of<UserProvider>(context).currentUser;
    final isPublisher = user?.id == widget.request.publisherId;
    final canAccept = widget.request.status == RequestStatus.pending && 
                     !widget.request.isExpired && 
                     !isPublisher;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (canAccept) ...[
              Expanded(
                child: CupertinoButton(
                  onPressed: _isLoading ? null : _acceptRequest,
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(12),
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : const Text(
                          '接受任务',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                          ),
                        ),
                ),
              ),
            ] else if (widget.request.status == RequestStatus.accepted) ...[
              Expanded(
                child: CupertinoButton(
                  onPressed: _contactOtherParty,
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(12),
                  child: const Text(
                    '联系对方',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoButton(
                  onPressed: _completeRequest,
                  color: AppColors.successGreen,
                  borderRadius: BorderRadius.circular(12),
                  child: const Text(
                    '完成任务',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: CupertinoButton(
                  onPressed: () => Navigator.of(context).pop(),
                  color: CupertinoColors.systemGrey4,
                  borderRadius: BorderRadius.circular(12),
                  child: const Text(
                    '返回',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _acceptRequest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<RequestProvider>(context, listen: false)
          .acceptRequest(widget.request.id);
      
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('接单成功'),
            content: const Text('你已成功接受这个任务，请及时联系发布者'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('接单失败'),
            content: Text(e.toString()),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _completeRequest() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('确认完成'),
        content: const Text('确认任务已完成？完成后将无法撤销'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final requestProvider = Provider.of<RequestProvider>(context, listen: false);
              
              navigator.pop();
              
              await requestProvider.completeRequest(widget.request.id);
              
              if (mounted) {
                navigator.pop();
              }
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void _contactPublisher() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChatScreen(
          otherUserId: widget.request.publisherId,
          otherUserName: '发布者',
        ),
      ),
    );
  }

  void _contactAccepter() {
    if (widget.request.accepterId != null) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => ChatScreen(
            otherUserId: widget.request.accepterId!,
            otherUserName: '接单者',
          ),
        ),
      );
    }
  }

  void _contactOtherParty() {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user?.id == widget.request.publisherId) {
      _contactAccepter();
    } else {
      _contactPublisher();
    }
  }

  void _showMap() {
    // 实现地图显示（功能待实现）
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('地图功能'),
        content: const Text('地图功能正在开发中'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // 实现举报功能（功能待实现）
            },
            child: const Text('举报'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // 实现分享功能（功能待实现）
            },
            child: const Text('分享'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ),
    );
  }

  String _getCategoryName() {
    switch (widget.request.category) {
      case RequestCategory.delivery:
        return '代取代买';
      case RequestCategory.groupBuy:
        return '拼单';
      case RequestCategory.borrow:
        return '临时借用';
      case RequestCategory.other:
        return '其他';
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.request.category) {
      case RequestCategory.delivery:
        return CupertinoIcons.bag;
      case RequestCategory.groupBuy:
        return CupertinoIcons.person_2;
      case RequestCategory.borrow:
        return CupertinoIcons.hand_raised;
      case RequestCategory.other:
        return CupertinoIcons.ellipsis_circle;
    }
  }

  Color _getCategoryColor() {
    switch (widget.request.category) {
      case RequestCategory.delivery:
        return AppColors.primaryOrange;
      case RequestCategory.groupBuy:
        return AppColors.warningYellow;
      case RequestCategory.borrow:
        return AppColors.successGreen;
      case RequestCategory.other:
        return CupertinoColors.systemBlue;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatPublishTime() {
    final now = DateTime.now();
    final diff = now.difference(widget.request.createdAt);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else {
      return '${diff.inDays}天前';
    }
  }

  String _formatTimeRemaining() {
    final remaining = widget.request.timeRemaining;
    if (remaining.inHours > 0) {
      return '${remaining.inHours}小时${remaining.inMinutes % 60}分钟';
    } else {
      return '${remaining.inMinutes}分钟';
    }
  }
}