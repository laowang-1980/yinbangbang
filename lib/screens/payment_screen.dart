import 'package:flutter/cupertino.dart';
import '../utils/app_constants.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';

class PaymentScreen extends StatefulWidget {
  final RequestModel request;
  final UserModel helper;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.request,
    required this.helper,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'wechat';
  bool isProcessingPayment = false;
  int countdownSeconds = 900; // 15分钟倒计时

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && countdownSeconds > 0) {
        setState(() {
          countdownSeconds--;
        });
        _startCountdown();
      }
    });
  }

  String _formatCountdown() {
    int minutes = countdownSeconds ~/ 60;
    int seconds = countdownSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _processPayment() async {
    setState(() {
      isProcessingPayment = true;
    });

    // 模拟支付处理
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        isProcessingPayment = false;
      });

      // 显示支付成功
      _showPaymentSuccess();
    }
  }

  void _showPaymentSuccess() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.check_mark_circled_solid, 
                 color: CupertinoColors.systemGreen, size: 24),
            SizedBox(width: 8),
            Text('支付成功'),
          ],
        ),
        content: const Text('订单已确认，帮手将尽快为您服务'),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // 返回上一页
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem({
    required String method,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = selectedPaymentMethod == method;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.systemOrange.withValues(alpha: 0.1) : CupertinoColors.white,
          border: Border.all(
            color: isSelected ? CupertinoColors.systemOrange : CupertinoColors.systemGrey4,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: AppConstants.borderRadiusMedium,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: AppConstants.borderRadiusSmall,
              ),
              child: Icon(icon, color: CupertinoColors.white, size: 20),
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
                      color: CupertinoColors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? CupertinoColors.systemOrange : CupertinoColors.systemGrey4,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CupertinoColors.systemOrange,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('确认支付'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
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
                    // 订单信息
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: AppConstants.borderRadiusMedium,
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: AppConstants.borderRadiusLarge,
                                child: widget.helper.avatar != null
                                    ? Image.network(
                                        widget.helper.avatar!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: CupertinoColors.systemGrey5,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              CupertinoIcons.person_fill,
                                              color: CupertinoColors.systemGrey,
                                              size: 20,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: CupertinoColors.systemGrey5,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.person_fill,
                                          color: CupertinoColors.systemGrey,
                                          size: 20,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.request.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.star_fill,
                                              color: CupertinoColors.systemYellow,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              widget.helper.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: CupertinoColors.systemGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '帮手: ${widget.helper.name} · 距离您 ${widget.request.distance?.toStringAsFixed(0) ?? '0'}m',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.clock,
                                          size: 14,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '预计${widget.request.timeLimit}分钟',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          CupertinoIcons.location,
                                          size: 14,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            widget.request.location,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemOrange.withValues(alpha: 0.1),
                              borderRadius: AppConstants.borderRadiusSmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.info_circle,
                                      color: CupertinoColors.systemOrange,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '订单详情',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.request.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 费用明细
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '费用明细',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '服务费用',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              Text(
                                '¥${widget.request.reward.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '平台服务费',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              Text(
                                '¥1.00',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            color: CupertinoColors.separator,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '需支付',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '¥${widget.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.systemOrange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 支付方式
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '选择支付方式',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentMethodItem(
                            method: 'wechat',
                            icon: CupertinoIcons.chat_bubble_2_fill,
                            iconColor: CupertinoColors.systemGreen,
                            title: '微信支付',
                            subtitle: '推荐使用',
                          ),
                          _buildPaymentMethodItem(
                            method: 'alipay',
                            icon: CupertinoIcons.money_dollar_circle_fill,
                            iconColor: CupertinoColors.systemBlue,
                            title: '支付宝',
                            subtitle: '余额充足',
                          ),
                          _buildPaymentMethodItem(
                            method: 'balance',
                            icon: CupertinoIcons.creditcard_fill,
                            iconColor: CupertinoColors.systemOrange,
                            title: '余额支付',
                            subtitle: '可用余额: ¥156.50',
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 安全保障
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                CupertinoIcons.shield_fill,
                                color: CupertinoColors.systemGreen,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '安全保障',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                                      borderRadius: AppConstants.borderRadiusSmall,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.lock_fill,
                                      color: CupertinoColors.systemBlue,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '资金托管',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemGreen.withValues(alpha: 0.1),
                                      borderRadius: AppConstants.borderRadiusSmall,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.person_badge_plus_fill,
                                      color: CupertinoColors.systemGreen,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '实名认证',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemPurple.withValues(alpha: 0.1),
                                      borderRadius: AppConstants.borderRadiusSmall,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.headphones,
                                      color: CupertinoColors.systemPurple,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '客服保障',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 支付倒计时
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemYellow.withValues(alpha: 0.1),
                        border: Border.all(
                          color: CupertinoColors.systemYellow.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: CupertinoColors.systemYellow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.clock_fill,
                              color: CupertinoColors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '请在 ${_formatCountdown()} 内完成支付',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  '超时订单将自动取消',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100), // 为底部按钮留出空间
                  ],
                ),
              ),
            ),
            
            // 底部支付按钮
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: CupertinoColors.white,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.systemGrey5,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '需支付',
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      Text(
                        '¥${widget.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.systemOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CupertinoButton(
                      color: CupertinoColors.systemOrange,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: isProcessingPayment ? null : _processPayment,
                      child: isProcessingPayment
                          ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                          : const Text(
                              '立即支付',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.white,
                              ),
                            ),
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
}