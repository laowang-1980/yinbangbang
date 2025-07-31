import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

/// 注册登录页面
/// 对应原型图中的register.html
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLogin = true; // true: 登录模式, false: 注册模式
  int _countdown = 0;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _countdown--;
        });
        return _countdown > 0;
      }
      return false;
    });
  }

  Future<void> _sendVerificationCode() async {
    if (_phoneController.text.length != 11) {
      _showAlert('请输入正确的手机号码');
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.sendVerificationCode(_phoneController.text);
    
    if (success) {
      _startCountdown();
      _showAlert('验证码已发送');
    } else {
      _showAlert(userProvider.errorMessage ?? '发送失败');
    }
  }

  Future<void> _submitForm() async {
    if (_phoneController.text.length != 11) {
      _showAlert('请输入正确的手机号码');
      return;
    }
    
    if (_codeController.text.length != 6) {
      _showAlert('请输入6位验证码');
      return;
    }
    
    if (!_isLogin && _nameController.text.trim().isEmpty) {
      _showAlert('请输入姓名');
      return;
    }
    
    if (!_agreedToTerms) {
      _showAlert('请同意用户协议和隐私政策');
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool success;
    
    if (_isLogin) {
      success = await userProvider.login(_phoneController.text, _codeController.text);
    } else {
      success = await userProvider.register(
        phone: _phoneController.text,
        verificationCode: _codeController.text,
        name: _nameController.text.trim(),
      );
    }
    
    if (success) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } else {
      _showAlert(userProvider.errorMessage ?? '操作失败');
    }
  }

  void _showAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('提示'),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: AppConstants.paddingXLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.spacingBoxXXLarge,
              
              // 返回按钮
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.back,
                      color: AppColors.primaryOrange,
                    ),
                    AppConstants.spacingBoxHorizontalSmall,
                    Text(
                      '返回',
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 标题
              Text(
                _isLogin ? '登录硬帮帮' : '注册硬帮帮',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
              
              AppConstants.spacingBoxSmall,
              
              Text(
                _isLogin ? '欢迎回来，开始你的互助之旅' : '加入我们，开始你的互助之旅',
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // 手机号输入
              _buildInputSection(
                label: '手机号',
                child: CupertinoTextField(
                  controller: _phoneController,
                  placeholder: '请输入手机号',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  padding: AppConstants.paddingRegular,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CupertinoColors.separator,
                      width: 1,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 验证码输入
              _buildInputSection(
                label: '验证码',
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _codeController,
                        placeholder: '请输入验证码',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CupertinoColors.separator,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CupertinoButton(
                      onPressed: _countdown > 0 ? null : _sendVerificationCode,
                      color: _countdown > 0 ? CupertinoColors.inactiveGray : AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        _countdown > 0 ? '${_countdown}s' : '获取验证码',
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 注册模式下的姓名输入
              if (!_isLogin) ...[
                const SizedBox(height: 24),
                _buildInputSection(
                  label: '姓名',
                  child: CupertinoTextField(
                    controller: _nameController,
                    placeholder: '请输入真实姓名',
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.separator,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // 用户协议
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _agreedToTerms = !_agreedToTerms;
                      });
                    },
                    child: Icon(
                      _agreedToTerms 
                          ? CupertinoIcons.check_mark_circled_solid
                          : CupertinoIcons.circle,
                      color: _agreedToTerms 
                          ? AppColors.primaryOrange 
                          : CupertinoColors.inactiveGray,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '我已阅读并同意《用户协议》和《隐私政策》',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // 提交按钮
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: userProvider.isLoading ? null : _submitForm,
                      color: AppColors.primaryOrange,
                      borderRadius: AppConstants.borderRadiusRegular,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: userProvider.isLoading
                          ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                          : Text(
                              _isLogin ? '登录' : '注册',
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // 切换登录/注册模式
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _codeController.clear();
                      _nameController.clear();
                      _countdown = 0;
                    });
                  },
                  child: Text(
                    _isLogin ? '还没有账号？立即注册' : '已有账号？立即登录',
                    style: const TextStyle(
                      color: AppColors.primaryOrange,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 其他登录方式分割线
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: CupertinoColors.separator,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '其他登录方式',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: CupertinoColors.separator,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 微信和支付宝登录按钮
              Row(
                children: [
                  Expanded(
                    child: _buildWeChatLoginButton(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAlipayLoginButton(),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 演示模式按钮
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    // 直接跳转到主页面，用于演示
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '演示模式（跳过登录）',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildWeChatLoginButton() {
    const wechatColor = Color(0xFF07C160);
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: wechatColor.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _loginWithWeChat,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
               'assets/images/wechat_icon.svg',
               width: 20,
               height: 20,
             ),
            const SizedBox(width: 8),
            const Text(
              '微信登录',
              style: TextStyle(
                color: wechatColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlipayLoginButton() {
    const alipayColor = Color(0xFF1677FF);
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: alipayColor.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _loginWithAlipay,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
               'assets/images/alipay_icon.svg',
               width: 20,
               height: 20,
             ),
            const SizedBox(width: 8),
            const Text(
              '支付宝登录',
              style: TextStyle(
                color: alipayColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginWithWeChat() async {
    try {
      // 显示加载状态
      showCupertinoDialog(
        context: context,
        builder: (context) => const CupertinoAlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(),
              SizedBox(width: 16),
              Text('正在启动微信登录...'),
            ],
          ),
        ),
      );

      // 调用微信登录API
      final result = await _authService.loginWithWeChat();
      
      if (!mounted) return;
      Navigator.of(context).pop(); // 关闭加载对话框
      
      if (result['success']) {
        // 登录成功，跳转到主页
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        // 显示错误信息
        _showErrorDialog(result['message'] ?? '微信登录失败');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // 关闭加载对话框
      _showErrorDialog('微信登录失败：$e');
    }
  }

  void _loginWithAlipay() async {
    try {
      // 显示加载状态
      showCupertinoDialog(
        context: context,
        builder: (context) => const CupertinoAlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(),
              SizedBox(width: 16),
              Text('正在启动支付宝登录...'),
            ],
          ),
        ),
      );

      // 调用支付宝登录API
      final result = await _authService.loginWithAlipay();
      
      if (!mounted) return;
      Navigator.of(context).pop(); // 关闭加载对话框
      
      if (result['success']) {
        // 登录成功，跳转到主页
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        // 显示错误信息
        _showErrorDialog(result['message'] ?? '支付宝登录失败');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // 关闭加载对话框
      _showErrorDialog('支付宝登录失败：$e');
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('错误'),
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
}