import 'package:flutter/foundation.dart';
import '../models/request_model.dart';

/// 需求状态管理Provider
class RequestProvider extends ChangeNotifier {
  List<RequestModel> _nearbyRequests = [];
  List<RequestModel> _myRequests = [];
  List<RequestModel> _myAcceptedRequests = [];
  bool _isLoading = false;
  String? _errorMessage;
  RequestCategory? _selectedCategory;
  double _maxDistance = 2000; // 最大距离（米）
  double _minReward = 0;
  double _maxReward = 100;

  // Getters
  List<RequestModel> get nearbyRequests => _nearbyRequests;
  List<RequestModel> get myRequests => _myRequests;
  List<RequestModel> get myAcceptedRequests => _myAcceptedRequests;
  List<RequestModel> get requests => _nearbyRequests; // 返回所有请求
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RequestCategory? get selectedCategory => _selectedCategory;
  double get maxDistance => _maxDistance;
  double get minReward => _minReward;
  double get maxReward => _maxReward;

  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 设置错误信息
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// 获取附近需求
  Future<void> fetchNearbyRequests() async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据
      _nearbyRequests = _generateMockRequests();
      
      _setLoading(false);
    } catch (e) {
      _setError('获取附近需求失败：${e.toString()}');
      _setLoading(false);
    }
  }

  /// 发布需求
  Future<bool> publishRequest({
    required RequestCategory category,
    required String title,
    required String description,
    required double reward,
    required String location,
    required double latitude,
    required double longitude,
    required int timeLimit,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 2));
      
      final newRequest = RequestModel(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        publisherId: 'current_user_id',
        category: category,
        title: title,
        description: description,
        reward: reward,
        location: location,
        latitude: latitude,
        longitude: longitude,
        timeLimit: timeLimit,
        status: RequestStatus.pending,
        createdAt: DateTime.now(),
        publisherName: '我',
        publisherCreditScore: 4.8,
      );
      
      _myRequests.insert(0, newRequest);
      _nearbyRequests.insert(0, newRequest);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('发布需求失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 接受需求
  Future<bool> acceptRequest(String requestId) async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 更新需求状态
      final requestIndex = _nearbyRequests.indexWhere((r) => r.id == requestId);
      if (requestIndex != -1) {
        final updatedRequest = _nearbyRequests[requestIndex].copyWith(
          status: RequestStatus.accepted,
          accepterId: 'current_user_id',
          acceptedAt: DateTime.now(),
        );
        
        _nearbyRequests[requestIndex] = updatedRequest;
        _myAcceptedRequests.insert(0, updatedRequest);
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('接受需求失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 完成需求
  Future<bool> completeRequest(String requestId) async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 更新需求状态
      _updateRequestStatus(requestId, RequestStatus.completed);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('完成需求失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 取消需求
  Future<bool> cancelRequest(String requestId) async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 更新需求状态
      _updateRequestStatus(requestId, RequestStatus.cancelled);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('取消需求失败：${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// 设置筛选条件
  void setFilter({
    RequestCategory? category,
    double? maxDistance,
    double? minReward,
    double? maxReward,
  }) {
    _selectedCategory = category;
    _maxDistance = maxDistance ?? _maxDistance;
    _minReward = minReward ?? _minReward;
    _maxReward = maxReward ?? _maxReward;
    notifyListeners();
  }

  /// 清除筛选条件
  void clearFilter() {
    _selectedCategory = null;
    _maxDistance = 2000;
    _minReward = 0;
    _maxReward = 100;
    notifyListeners();
  }

  /// 获取筛选后的需求列表
  List<RequestModel> get filteredRequests {
    return _nearbyRequests.where((request) {
      // 分类筛选
      if (_selectedCategory != null && request.category != _selectedCategory) {
        return false;
      }
      
      // 距离筛选
      if (request.distance != null && request.distance! > _maxDistance) {
        return false;
      }
      
      // 报酬筛选
      if (request.reward < _minReward || request.reward > _maxReward) {
        return false;
      }
      
      // 只显示待接单的需求
      return request.status == RequestStatus.pending && !request.isExpired;
    }).toList();
  }

  /// 更新需求状态
  void _updateRequestStatus(String requestId, RequestStatus status) {
    // 更新附近需求列表
    final nearbyIndex = _nearbyRequests.indexWhere((r) => r.id == requestId);
    if (nearbyIndex != -1) {
      _nearbyRequests[nearbyIndex] = _nearbyRequests[nearbyIndex].copyWith(
        status: status,
        completedAt: status == RequestStatus.completed ? DateTime.now() : null,
      );
    }
    
    // 更新我的需求列表
    final myIndex = _myRequests.indexWhere((r) => r.id == requestId);
    if (myIndex != -1) {
      _myRequests[myIndex] = _myRequests[myIndex].copyWith(
        status: status,
        completedAt: status == RequestStatus.completed ? DateTime.now() : null,
      );
    }
    
    // 更新我接受的需求列表
    final acceptedIndex = _myAcceptedRequests.indexWhere((r) => r.id == requestId);
    if (acceptedIndex != -1) {
      _myAcceptedRequests[acceptedIndex] = _myAcceptedRequests[acceptedIndex].copyWith(
        status: status,
        completedAt: status == RequestStatus.completed ? DateTime.now() : null,
      );
    }
  }

  /// 获取我发布的需求
  Future<void> fetchMyRequests() async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据
      _myRequests = _generateMyMockRequests();
      
      _setLoading(false);
    } catch (e) {
      _setError('获取我的需求失败：${e.toString()}');
      _setLoading(false);
    }
  }

  /// 获取我接受的需求
  Future<void> fetchMyAcceptedRequests() async {
    _setLoading(true);
    _setError(null);

    try {
      // 模拟API调用
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据
      _myAcceptedRequests = _generateMyAcceptedMockRequests();
      
      _setLoading(false);
    } catch (e) {
      _setError('获取我接受的需求失败：${e.toString()}');
      _setLoading(false);
    }
  }

  /// 生成我发布的模拟数据
  List<RequestModel> _generateMyMockRequests() {
    final now = DateTime.now();
    return [
      RequestModel(
        id: 'my_req_001',
        publisherId: 'current_user_id',
        category: RequestCategory.delivery,
        title: '帮忙取快递',
        description: '有个快递在菜鸟驿站，帮忙取一下，谢谢！',
        reward: 5.0,
        location: '东区宿舍楼下',
        latitude: 40.0583,
        longitude: 116.3014,
        timeLimit: 120,
        status: RequestStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 30)),
        publisherName: '我',
        publisherCreditScore: 4.8,
      ),
      RequestModel(
        id: 'my_req_002',
        publisherId: 'current_user_id',
        category: RequestCategory.groupBuy,
        title: '拼单奶茶',
        description: '喜茶满30免配送费，还差15元，有人一起吗？',
        reward: 3.0,
        location: '中关村软件园B座',
        latitude: 40.0585,
        longitude: 116.3016,
        timeLimit: 60,
        status: RequestStatus.accepted,
        createdAt: now.subtract(const Duration(hours: 1)),
        publisherName: '我',
        publisherCreditScore: 4.8,
        accepterId: 'user_002',
        acceptedAt: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  /// 生成我接受的模拟数据
  List<RequestModel> _generateMyAcceptedMockRequests() {
    final now = DateTime.now();
    return [
      RequestModel(
        id: 'accepted_req_001',
        publisherId: 'user_001',
        accepterId: 'current_user_id',
        category: RequestCategory.delivery,
        title: '帮忙带饭',
        description: '食堂的红烧肉饭，微信转账',
        reward: 8.0,
        location: '食堂二楼',
        latitude: 40.0580,
        longitude: 116.3018,
        timeLimit: 45,
        status: RequestStatus.accepted,
        createdAt: now.subtract(const Duration(hours: 2)),
        acceptedAt: now.subtract(const Duration(hours: 1)),
        publisherName: '小李',
        publisherAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        publisherCreditScore: 4.7,
      ),
      RequestModel(
        id: 'accepted_req_002',
        publisherId: 'user_003',
        accepterId: 'current_user_id',
        category: RequestCategory.borrow,
        title: '帮忙搬东西',
        description: '从宿舍搬一些书到图书馆',
        reward: 15.0,
        location: '图书馆',
        latitude: 40.0582,
        longitude: 116.3020,
        timeLimit: 180,
        status: RequestStatus.completed,
        createdAt: now.subtract(const Duration(days: 1)),
        acceptedAt: now.subtract(const Duration(hours: 20)),
        completedAt: now.subtract(const Duration(hours: 18)),
        publisherName: '张同学',
        publisherAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        publisherCreditScore: 4.8,
      ),
    ];
  }

  /// 生成模拟数据
  List<RequestModel> _generateMockRequests() {
    final now = DateTime.now();
    return [
      RequestModel(
        id: 'req_001',
        publisherId: 'user_001',
        category: RequestCategory.delivery,
        title: '帮忙取个外卖',
        description: '在楼下星巴克，帮忙取一杯拿铁，谢谢！',
        reward: 5.0,
        location: '中关村软件园A座',
        latitude: 40.0583,
        longitude: 116.3014,
        timeLimit: 30,
        status: RequestStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 5)),
        publisherName: '小王',
        publisherAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        publisherCreditScore: 4.9,
        distance: 150,
      ),
      RequestModel(
        id: 'req_002',
        publisherId: 'user_002',
        category: RequestCategory.groupBuy,
        title: '拼单奶茶',
        description: '喜茶满30免配送费，还差15元，有人一起吗？',
        reward: 3.0,
        location: '中关村软件园B座',
        latitude: 40.0585,
        longitude: 116.3016,
        timeLimit: 45,
        status: RequestStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 10)),
        publisherName: '李小姐',
        publisherAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        publisherCreditScore: 4.7,
        distance: 280,
      ),
      RequestModel(
        id: 'req_003',
        publisherId: 'user_003',
        category: RequestCategory.borrow,
        title: '借个充电线',
        description: '手机没电了，借个Type-C充电线用一下，马上还',
        reward: 2.0,
        location: '中关村软件园C座',
        latitude: 40.0580,
        longitude: 116.3018,
        timeLimit: 15,
        status: RequestStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 3)),
        publisherName: '张同学',
        publisherAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        publisherCreditScore: 4.8,
        distance: 420,
      ),
    ];
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}