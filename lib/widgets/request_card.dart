import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../models/request_model.dart';
import '../providers/request_provider.dart';
import '../screens/request_detail_screen.dart';

/// 需求卡片组件
/// 用于展示需求信息的卡片
class RequestCard extends StatelessWidget {
  final RequestModel request;
  final bool showDistance;
  final VoidCallback? onTap;

  const RequestCard({
    super.key,
    required this.request,
    this.showDistance = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap ?? () => _navigateToDetail(context),
      padding: EdgeInsets.zero,
      child: Container(
        padding: AppConstants.paddingRegular,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: AppConstants.borderRadiusRegular,
          border: Border.all(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部信息
            Row(
              children: [
                // 分类图标
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getCategoryColor().withValues(alpha: 0.1),
                    borderRadius: AppConstants.borderRadiusSmall,
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    color: _getCategoryColor(),
                    size: 16,
                  ),
                ),
                AppConstants.spacingBoxHorizontalMedium,
                // 分类和时间
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getCategoryName(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      Text(
                        _formatTimeRemaining(),
                        style: TextStyle(
                          fontSize: 11,
                          color: request.isExpired
                              ? AppColors.errorRed
                              : CupertinoColors.tertiaryLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                // 状态标签
                _buildStatusBadge(),
              ],
            ),
            AppConstants.spacingBoxMedium,
            
            // 标题
            Text(
              request.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            AppConstants.spacingBoxSmall,
            
            // 描述
            if (request.description.isNotEmpty) ...[
              Text(
                request.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],
            
            // 底部信息
            Row(
              children: [
                // 位置信息
                if (showDistance) ...[
                  const Icon(
                    CupertinoIcons.location_solid,
                    size: 14,
                    color: CupertinoColors.secondaryLabel,
                  ),
                  AppConstants.spacingBoxHorizontalXSmall,
                  Text(
                    request.formatDistance(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  AppConstants.spacingBoxHorizontalRegular,
                ],
                
                // 报酬
                const Icon(
                  CupertinoIcons.money_yen_circle,
                  size: 14,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  request.formatReward(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryOrange,
                  ),
                ),
                
                const Spacer(),
                
                // 操作按钮
                if (request.status == RequestStatus.pending && !request.isExpired)
                  _buildActionButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color color;
    
    switch (request.status) {
      case RequestStatus.pending:
        if (request.isExpired) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () => _acceptRequest(context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primaryOrange,
      borderRadius: BorderRadius.circular(20),
      minimumSize: Size.zero,
      child: const Text(
        '接单',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.white,
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => RequestDetailScreen(request: request),
      ),
    );
  }

  void _acceptRequest(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('确认接单'),
        content: Text('确定要接受「${request.title}」这个需求吗？'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<RequestProvider>(context, listen: false)
                  .acceptRequest(request.id);
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  String _getCategoryName() {
    switch (request.category) {
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
    switch (request.category) {
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
    switch (request.category) {
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

  String _formatTimeRemaining() {
    if (request.isExpired) {
      return '已过期';
    }
    
    final remaining = request.timeRemaining;
    if (remaining.inHours > 0) {
      return '${remaining.inHours}小时后过期';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}分钟后过期';
    } else {
      return '即将过期';
    }
  }
}