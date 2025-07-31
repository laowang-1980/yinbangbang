/// 需求分类枚举
enum RequestCategory {
  delivery('代取代买'),
  groupBuy('拼单'),
  borrow('借用'),
  other('其他');

  const RequestCategory(this.displayName);
  final String displayName;
}

/// 需求状态枚举
enum RequestStatus {
  pending('待接单'),
  accepted('已接单'),
  inProgress('进行中'),
  completed('已完成'),
  cancelled('已取消');

  const RequestStatus(this.displayName);
  final String displayName;
}

/// 需求数据模型
class RequestModel {
  final String id;
  final String publisherId;
  final String? accepterId;
  final RequestCategory category;
  final String title;
  final String description;
  final double reward;
  final String location;
  final double latitude;
  final double longitude;
  final int timeLimit; // 分钟
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final String? publisherName;
  final String? publisherAvatar;
  final double? publisherCreditScore;
  final double? distance; // 距离（米）

  const RequestModel({
    required this.id,
    required this.publisherId,
    this.accepterId,
    required this.category,
    required this.title,
    required this.description,
    required this.reward,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.timeLimit,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.publisherName,
    this.publisherAvatar,
    this.publisherCreditScore,
    this.distance,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      publisherId: json['publisherId'] as String,
      accepterId: json['accepterId'] as String?,
      category: RequestCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => RequestCategory.other,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      reward: (json['reward'] as num).toDouble(),
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timeLimit: json['timeLimit'] as int,
      status: RequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      publisherName: json['publisherName'] as String?,
      publisherAvatar: json['publisherAvatar'] as String?,
      publisherCreditScore: json['publisherCreditScore'] != null
          ? (json['publisherCreditScore'] as num).toDouble()
          : null,
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publisherId': publisherId,
      'accepterId': accepterId,
      'category': category.name,
      'title': title,
      'description': description,
      'reward': reward,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'timeLimit': timeLimit,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'publisherName': publisherName,
      'publisherAvatar': publisherAvatar,
      'publisherCreditScore': publisherCreditScore,
      'distance': distance,
    };
  }

  RequestModel copyWith({
    String? id,
    String? publisherId,
    String? accepterId,
    RequestCategory? category,
    String? title,
    String? description,
    double? reward,
    String? location,
    double? latitude,
    double? longitude,
    int? timeLimit,
    RequestStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
    String? publisherName,
    String? publisherAvatar,
    double? publisherCreditScore,
    double? distance,
  }) {
    return RequestModel(
      id: id ?? this.id,
      publisherId: publisherId ?? this.publisherId,
      accepterId: accepterId ?? this.accepterId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timeLimit: timeLimit ?? this.timeLimit,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
      publisherName: publisherName ?? this.publisherName,
      publisherAvatar: publisherAvatar ?? this.publisherAvatar,
      publisherCreditScore: publisherCreditScore ?? this.publisherCreditScore,
      distance: distance ?? this.distance,
    );
  }

  /// 获取剩余时间（分钟）
  int get remainingMinutes {
    if (status != RequestStatus.pending && status != RequestStatus.accepted) {
      return 0;
    }
    
    final now = DateTime.now();
    final deadline = createdAt.add(Duration(minutes: timeLimit));
    final remaining = deadline.difference(now).inMinutes;
    return remaining > 0 ? remaining : 0;
  }

  /// 是否已过期
  bool get isExpired => remainingMinutes <= 0;

  /// 格式化距离显示
  String get formattedDistance {
    if (distance == null) return '未知距离';
    
    if (distance! < 1000) {
      return '${distance!.round()}m';
    } else {
      return '${(distance! / 1000).toStringAsFixed(1)}km';
    }
  }

  /// 格式化报酬显示
  String get formattedReward => '¥${reward.toStringAsFixed(0)}';
  
  /// 格式化报酬方法（兼容性）
  String formatReward() => formattedReward;
  
  /// 格式化距离方法（兼容性）
  String formatDistance() => formattedDistance;
  
  /// 截止时间
  DateTime get deadline => createdAt.add(Duration(minutes: timeLimit));
  
  /// 获取剩余时间
  Duration get timeRemaining {
    if (isExpired) return Duration.zero;
    final deadline = createdAt.add(Duration(minutes: timeLimit));
    final now = DateTime.now();
    return deadline.isAfter(now) ? deadline.difference(now) : Duration.zero;
  }

  @override
  String toString() {
    return 'RequestModel(id: $id, title: $title, reward: $reward, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}