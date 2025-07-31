/// 用户数据模型
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? avatar;
  final String? location;
  final double creditScore;
  final double rating;
  final bool isVerified;
  final bool isStudentVerified;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatar,
    this.location,
    required this.creditScore,
    required this.rating,
    required this.isVerified,
    required this.isStudentVerified,
    required this.createdAt,
    this.lastActiveAt,
  });

  /// 是否为学生用户
  bool get isStudent => isStudentVerified;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String?,
      location: json['location'] as String?,
      creditScore: (json['creditScore'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      isVerified: json['isVerified'] as bool,
      isStudentVerified: json['isStudentVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'location': location,
      'creditScore': creditScore,
      'rating': rating,
      'isVerified': isVerified,
      'isStudentVerified': isStudentVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? avatar,
    String? location,
    double? creditScore,
    double? rating,
    bool? isVerified,
    bool? isStudentVerified,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      creditScore: creditScore ?? this.creditScore,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      isStudentVerified: isStudentVerified ?? this.isStudentVerified,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, creditScore: $creditScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}