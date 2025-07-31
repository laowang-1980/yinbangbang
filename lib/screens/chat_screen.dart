import 'package:flutter/cupertino.dart';
import '../utils/app_constants.dart';
import '../utils/app_colors.dart';

/// 聊天页面
/// 对应原型图中的chat.html
class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // 模拟加载聊天记录
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          senderId: widget.otherUserId,
          content: '你好，关于这个需求我想了解一下具体情况',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          type: MessageType.text,
        ),
        ChatMessage(
          id: '2',
          senderId: 'current_user',
          content: '好的，有什么问题可以问我',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          type: MessageType.text,
        ),
        ChatMessage(
          id: '3',
          senderId: widget.otherUserId,
          content: '大概需要多长时间完成？',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          type: MessageType.text,
        ),
      ]);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.person_fill,
                color: CupertinoColors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.otherUserName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  '在线',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showMoreOptions,
          child: const Icon(
            CupertinoIcons.ellipsis_circle,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ),
      child: Column(
        children: [
          // 聊天记录
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == 'current_user';
                final showTime = index == 0 || 
                    _messages[index - 1].timestamp.difference(message.timestamp).inMinutes.abs() > 5;
                
                return Column(
                  children: [
                    if (showTime) _buildTimeStamp(message.timestamp),
                    _buildMessageBubble(message, isMe),
                  ],
                );
              },
            ),
          ),
          
          // 正在输入提示
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      color: CupertinoColors.white,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '对方正在输入...',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          
          // 输入框
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTimeStamp(DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        _formatTime(timestamp),
        style: const TextStyle(
          fontSize: 12,
          color: CupertinoColors.secondaryLabel,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.person_fill,
                color: CupertinoColors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primaryOrange : CupertinoColors.systemBackground,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildMessageContent(message, isMe),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.person_fill,
                color: CupertinoColors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message, bool isMe) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 16,
            color: isMe ? CupertinoColors.white : CupertinoColors.label,
            height: 1.3,
          ),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppConstants.borderRadiusSmall,
              child: Container(
                width: 200,
                height: 150,
                color: CupertinoColors.systemGrey5,
                child: const Icon(
                  CupertinoIcons.photo,
                  size: 48,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 14,
                  color: isMe ? CupertinoColors.white : CupertinoColors.label,
                ),
              ),
            ],
          ],
        );
      case MessageType.location:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 120,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: AppConstants.borderRadiusSmall,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    size: 32,
                    color: AppColors.primaryOrange,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '位置信息',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 14,
                color: isMe ? CupertinoColors.white : CupertinoColors.label,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildInputArea() {
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
            // 更多功能按钮
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _showMoreActions,
              child: const Icon(
                CupertinoIcons.add_circled,
                color: CupertinoColors.secondaryLabel,
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
            
            // 输入框
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CupertinoTextField(
                  controller: _messageController,
                  placeholder: '输入消息...',
                  maxLines: 4,
                  minLines: 1,
                  decoration: const BoxDecoration(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.label,
                  ),
                  placeholderStyle: const TextStyle(
                    color: CupertinoColors.placeholderText,
                  ),
                  onChanged: (text) {
                    // 发送正在输入状态（功能待实现）
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // 发送按钮
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _messageController.text.trim().isEmpty ? null : _sendMessage,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _messageController.text.trim().isEmpty
                      ? CupertinoColors.systemGrey4
                      : AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.arrow_up,
                  color: CupertinoColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    _scrollToBottom();

    // 模拟对方回复
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
        
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
              _messages.add(ChatMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                senderId: widget.otherUserId,
                content: '好的，我知道了',
                timestamp: DateTime.now(),
                type: MessageType.text,
              ));
            });
            _scrollToBottom();
          }
        });
      }
    });
  }

  void _showMoreActions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _sendImage();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.photo, color: AppColors.primaryOrange),
                SizedBox(width: 8),
                Text('发送图片'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _sendLocation();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.location, color: AppColors.primaryOrange),
                SizedBox(width: 8),
                Text('发送位置'),
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

  void _sendImage() {
    // 实现图片发送（功能待实现）
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      content: '图片',
      timestamp: DateTime.now(),
      type: MessageType.image,
    );

    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _sendLocation() {
    // 实现位置发送（功能待实现）
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      content: '我的位置',
      timestamp: DateTime.now(),
      type: MessageType.location,
    );

    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _showMoreOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // 查看用户资料（功能待实现）
            },
            child: const Text('查看资料'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              // 举报用户（功能待实现）
            },
            child: const Text('举报用户'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (messageDate == today) {
      return '今天 ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return '昨天 ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.month}月${timestamp.day}日 ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 聊天消息模型
class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
  });
}

/// 消息类型
enum MessageType {
  text,
  image,
  location,
}