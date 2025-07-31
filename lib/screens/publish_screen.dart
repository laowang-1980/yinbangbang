import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../utils/app_constants.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../models/request_model.dart';
import '../providers/request_provider.dart';
import '../providers/user_provider.dart';

/// 发布需求页面
/// 对应原型图中的publish.html
class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();
  final _locationController = TextEditingController();
  
  RequestCategory _selectedCategory = RequestCategory.delivery;
  int _selectedTimeLimit = 60; // 默认60分钟
  bool _isPublishing = false;

  final List<int> _timeLimitOptions = [30, 60, 120, 240, 480]; // 分钟

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rewardController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: const Text('发布需求'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isPublishing ? null : _publishRequest,
          child: _isPublishing
              ? const CupertinoActivityIndicator()
              : const Text(
                  '发布',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryOrange,
                  ),
                ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分类选择
              _buildSectionTitle('需求分类'),
              _buildCategorySelector(),
              const SizedBox(height: 24),
              
              // 标题输入
              _buildSectionTitle('需求标题'),
              _buildTextField(
                controller: _titleController,
                placeholder: '简要描述你的需求',
                maxLength: 30,
              ),
              const SizedBox(height: 24),
              
              // 详细描述
              _buildSectionTitle('详细描述'),
              _buildTextField(
                controller: _descriptionController,
                placeholder: '详细说明需求内容、要求等',
                maxLines: 4,
                maxLength: 200,
              ),
              const SizedBox(height: 24),
              
              // 报酬设置
              _buildSectionTitle('报酬金额'),
              _buildRewardInput(),
              const SizedBox(height: 24),
              
              // 位置信息
              _buildSectionTitle('位置信息'),
              _buildLocationInput(),
              const SizedBox(height: 24),
              
              // 时限设置
              _buildSectionTitle('完成时限'),
              _buildTimeLimitSelector(),
              const SizedBox(height: 32),
              
              // 发布须知
              _buildPublishNotice(),
              const SizedBox(height: 32),
              
              // 发布按钮
              _buildPublishButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.label,
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: RequestCategory.values.map((category) {
          final isSelected = _selectedCategory == category;
          return CupertinoButton(
            onPressed: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            padding: EdgeInsets.zero,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange.withValues(alpha: 0.1)
                    : CupertinoColors.systemGrey6,
                borderRadius: AppConstants.borderRadiusSmall,
                border: isSelected
                    ? Border.all(color: AppColors.primaryOrange, width: 1)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    color: isSelected
                        ? AppColors.primaryOrange
                        : CupertinoColors.secondaryLabel,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getCategoryName(category),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryOrange
                                : CupertinoColors.label,
                          ),
                        ),
                        Text(
                          _getCategoryDescription(category),
                          style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: AppColors.primaryOrange,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            maxLines: maxLines,
            maxLength: maxLength,
            decoration: const BoxDecoration(),
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.label,
            ),
            placeholderStyle: const TextStyle(
              color: CupertinoColors.placeholderText,
            ),
          ),
          if (maxLength != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${controller.text.length}/$maxLength',
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.money_yen_circle,
            color: AppColors.primaryOrange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CupertinoTextField(
              controller: _rewardController,
              placeholder: '输入报酬金额',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: const BoxDecoration(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryOrange,
              ),
              placeholderStyle: const TextStyle(
                color: CupertinoColors.placeholderText,
              ),
            ),
          ),
          const Text(
            '元',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.location_solid,
            color: AppColors.primaryOrange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CupertinoTextField(
              controller: _locationController,
              placeholder: '详细地址（如：xx楼xx室）',
              decoration: const BoxDecoration(),
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.label,
              ),
              placeholderStyle: const TextStyle(
                color: CupertinoColors.placeholderText,
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _getCurrentLocation,
            child: const Text(
              '定位',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLimitSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.clock,
                color: AppColors.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                '希望完成时间',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.label,
                ),
              ),
              const Spacer(),
              Text(
                _formatTimeLimit(_selectedTimeLimit),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeLimitOptions.map((minutes) {
              final isSelected = _selectedTimeLimit == minutes;
              return CupertinoButton(
                onPressed: () {
                  setState(() {
                    _selectedTimeLimit = minutes;
                  });
                },
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isSelected ? AppColors.primaryOrange : CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(20),
                minimumSize: Size.zero,
                child: Text(
                  _formatTimeLimit(minutes),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? CupertinoColors.white : CupertinoColors.label,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warningYellow.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.info_circle,
                color: AppColors.warningYellow,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                '发布须知',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warningYellow,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '• 请确保需求描述真实准确\n• 报酬将在任务完成后支付\n• 恶意发布虚假需求将被封号',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.secondaryLabel,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: _canPublish() ? _publishRequest : null,
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(12),
        child: _isPublishing
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : const Text(
                '发布需求',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                ),
              ),
      ),
    );
  }

  bool _canPublish() {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _rewardController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        !_isPublishing;
  }

  void _publishRequest() async {
    if (!_canPublish()) return;

    setState(() {
      _isPublishing = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final requestProvider = Provider.of<RequestProvider>(context, listen: false);
      
      final user = userProvider.currentUser;
      if (user == null) {
        throw Exception('用户未登录');
      }

      final reward = double.tryParse(_rewardController.text.trim());
      if (reward == null || reward <= 0) {
        throw Exception('请输入有效的报酬金额');
      }

      await requestProvider.publishRequest(
        category: _selectedCategory,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        reward: reward,
        location: _locationController.text.trim(),
        latitude: 39.9042, // 默认北京坐标
        longitude: 116.4074,
        timeLimit: _selectedTimeLimit,
      );

      if (mounted) {
        Navigator.of(context).pop();
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('发布成功'),
            content: const Text('你的需求已发布，等待其他用户接单'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
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
            title: const Text('发布失败'),
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
          _isPublishing = false;
        });
      }
    }
  }

  void _getCurrentLocation() {
    // 实现获取当前位置（功能待实现）
    _locationController.text = '当前位置';
  }

  String _getCategoryName(RequestCategory category) {
    switch (category) {
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

  String _getCategoryDescription(RequestCategory category) {
    switch (category) {
      case RequestCategory.delivery:
        return '帮忙取快递、买东西等';
      case RequestCategory.groupBuy:
        return '组织拼单、团购等';
      case RequestCategory.borrow:
        return '借用充电宝、雨伞等物品';
      case RequestCategory.other:
        return '其他类型的互助需求';
    }
  }

  IconData _getCategoryIcon(RequestCategory category) {
    switch (category) {
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

  String _formatTimeLimit(int minutes) {
    if (minutes < 60) {
      return '$minutes分钟';
    } else {
      final hours = minutes ~/ 60;
      return '$hours小时';
    }
  }
}