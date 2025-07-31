import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

/// 位置服务类
/// 处理地理位置获取、权限管理和地址解析
class LocationService {
  // 单例模式
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  
  Position? _currentPosition;
  String? _currentAddress;
  
  /// 获取当前位置
  Future<Position?> getCurrentPosition() async {
    try {
      // 检查位置权限
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        throw LocationException('位置权限被拒绝');
      }
      
      // 检查位置服务是否开启
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException('位置服务未开启');
      }
      
      // 获取当前位置
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      return _currentPosition;
    } catch (e) {
      throw LocationException('获取位置失败: ${e.toString()}');
    }
  }
  
  /// 获取当前地址
  Future<String?> getCurrentAddress() async {
    try {
      final position = _currentPosition ?? await getCurrentPosition();
      if (position == null) return null;
      
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'zh_CN',
      );
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        _currentAddress = _formatAddress(placemark);
        return _currentAddress;
      }
      
      return null;
    } catch (e) {
      throw LocationException('获取地址失败: ${e.toString()}');
    }
  }
  
  /// 根据地址获取坐标
  Future<Position?> getPositionFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      throw LocationException('地址解析失败: ${e.toString()}');
    }
  }
  
  /// 根据坐标获取地址
  Future<String?> getAddressFromPosition(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
        localeIdentifier: 'zh_CN',
      );
      
      if (placemarks.isNotEmpty) {
        return _formatAddress(placemarks.first);
      }
      
      return null;
    } catch (e) {
      throw LocationException('坐标解析失败: ${e.toString()}');
    }
  }
  
  /// 计算两点之间的距离（米）
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
  
  /// 格式化距离显示
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      final km = distanceInMeters / 1000;
      if (km < 10) {
        return '${km.toStringAsFixed(1)}km';
      } else {
        return '${km.round()}km';
      }
    }
  }
  
  /// 检查位置权限
  Future<bool> _checkLocationPermission() async {
    // 检查权限状态
    var permission = await Permission.location.status;
    
    if (permission.isDenied) {
      // 请求权限
      permission = await Permission.location.request();
    }
    
    if (permission.isPermanentlyDenied) {
      // 权限被永久拒绝，引导用户到设置页面
      await openAppSettings();
      return false;
    }
    
    return permission.isGranted;
  }
  
  /// 格式化地址
  String _formatAddress(Placemark placemark) {
    final components = <String>[];
    
    // 添加详细地址组件
    if (placemark.subLocality?.isNotEmpty == true) {
      components.add(placemark.subLocality!);
    }
    if (placemark.locality?.isNotEmpty == true) {
      components.add(placemark.locality!);
    }
    if (placemark.subAdministrativeArea?.isNotEmpty == true) {
      components.add(placemark.subAdministrativeArea!);
    }
    if (placemark.administrativeArea?.isNotEmpty == true) {
      components.add(placemark.administrativeArea!);
    }
    
    // 如果没有详细信息，使用街道信息
    if (components.isEmpty) {
      if (placemark.street?.isNotEmpty == true) {
        components.add(placemark.street!);
      }
      if (placemark.name?.isNotEmpty == true) {
        components.add(placemark.name!);
      }
    }
    
    return components.join(' ');
  }
  
  /// 获取缓存的位置信息
  Position? get cachedPosition => _currentPosition;
  
  /// 获取缓存的地址信息
  String? get cachedAddress => _currentAddress;
  
  /// 清除缓存
  void clearCache() {
    _currentPosition = null;
    _currentAddress = null;
  }
  
  /// 监听位置变化
  Stream<Position> getPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // 位置变化超过10米才触发
    );
    
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }
  
  /// 检查是否在指定范围内
  bool isWithinRange(
    double centerLatitude,
    double centerLongitude,
    double targetLatitude,
    double targetLongitude,
    double radiusInMeters,
  ) {
    final distance = calculateDistance(
      centerLatitude,
      centerLongitude,
      targetLatitude,
      targetLongitude,
    );
    
    return distance <= radiusInMeters;
  }
  
  /// 获取附近的兴趣点（模拟数据）
  Future<List<Map<String, dynamic>>> getNearbyPOIs({
    required double latitude,
    required double longitude,
    double radiusInMeters = 1000,
    String? type,
  }) async {
    // 这里应该调用地图API获取真实的POI数据
    // 目前返回模拟数据
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      {
        'name': '学校食堂',
        'address': '校园内',
        'latitude': latitude + 0.001,
        'longitude': longitude + 0.001,
        'type': 'restaurant',
        'distance': 120,
      },
      {
        'name': '图书馆',
        'address': '校园内',
        'latitude': latitude - 0.001,
        'longitude': longitude + 0.001,
        'type': 'library',
        'distance': 150,
      },
      {
        'name': '快递站',
        'address': '校园内',
        'latitude': latitude + 0.002,
        'longitude': longitude - 0.001,
        'type': 'post_office',
        'distance': 200,
      },
    ];
  }
}

/// 位置异常类
class LocationException implements Exception {
  final String message;
  
  LocationException(this.message);
  
  @override
  String toString() {
    return 'LocationException: $message';
  }
}

/// 位置信息模型
class LocationInfo {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime timestamp;
  
  LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}