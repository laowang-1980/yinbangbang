import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../models/request_model.dart';
import '../providers/request_provider.dart';
import '../widgets/request_card.dart';

/// 需求列表页面
/// 对应原型图中的requests.html
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  RequestCategory? _selectedCategory;
  String _sortBy = 'time'; // time, distance, reward
  bool _showOnlyAvailable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RequestProvider>(context, listen: false).fetchNearbyRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          // 导航栏
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.systemBackground,
            largeTitle: const Text('需求广场'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _showFilterSheet,
              child: const Icon(
                CupertinoIcons.slider_horizontal_3,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
          
          // 筛选条件栏
          SliverToBoxAdapter(
            child: _buildFilterBar(),
          ),
          
          // 需求列表
          Consumer<RequestProvider>(
            builder: (context, requestProvider, child) {
              if (requestProvider.isLoading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: AppConstants.paddingXLarge,
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                );
              }
              
              List<RequestModel> requests = requestProvider.nearbyRequests;
              
              // 应用筛选条件
              if (_selectedCategory != null) {
                requests = requests.where((r) => r.category == _selectedCategory).toList();
              }
              
              if (_showOnlyAvailable) {
                requests = requests.where((r) => r.status == RequestStatus.pending && !r.isExpired).toList();
              }
              
              // 排序
              requests = _sortRequests(requests);
              
              if (requests.isEmpty) {
                return SliverToBoxAdapter(
                  child: _buildEmptyState(),
                );
              }
              
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        index == 0 ? 8 : 4,
                        16,
                        index == requests.length - 1 ? 16 : 4,
                      ),
                      child: RequestCard(request: requests[index]),
                    );
                  },
                  childCount: requests.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: AppConstants.paddingRegular,
      child: Column(
        children: [
          // 分类筛选
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(null, '全部'),
                AppConstants.spacingBoxHorizontalSmall,
                ...RequestCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildCategoryChip(category, _getCategoryName(category)),
                  );
                }),
              ],
            ),
          ),
          AppConstants.spacingBoxMedium,
          
          // 排序和筛选选项
          Row(
            children: [
              _buildSortButton(),
              AppConstants.spacingBoxHorizontalMedium,
              _buildAvailableToggle(),
              const Spacer(),
              Consumer<RequestProvider>(
                builder: (context, requestProvider, child) {
                  final count = requestProvider.nearbyRequests
                      .where((r) => _showOnlyAvailable ? (r.status == RequestStatus.pending && !r.isExpired) : true)
                      .where((r) => _selectedCategory == null || r.category == _selectedCategory)
                      .length;
                  return Text(
                    '共 $count 个需求',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(RequestCategory? category, String name) {
    final isSelected = _selectedCategory == category;
    return CupertinoButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isSelected ? AppColors.primaryOrange : CupertinoColors.systemBackground,
      borderRadius: BorderRadius.circular(20),
      minimumSize: Size.zero,
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isSelected ? CupertinoColors.white : CupertinoColors.label,
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    String sortText;
    switch (_sortBy) {
      case 'time':
        sortText = '按时间';
        break;
      case 'distance':
        sortText = '按距离';
        break;
      case 'reward':
        sortText = '按报酬';
        break;
      default:
        sortText = '排序';
    }
    
    return CupertinoButton(
      onPressed: _showSortSheet,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: CupertinoColors.systemBackground,
      borderRadius: AppConstants.borderRadiusRegular,
      minimumSize: Size.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sortText,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            CupertinoIcons.chevron_down,
            size: 14,
            color: CupertinoColors.secondaryLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableToggle() {
    return CupertinoButton(
      onPressed: () {
        setState(() {
          _showOnlyAvailable = !_showOnlyAvailable;
        });
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: _showOnlyAvailable ? AppColors.primaryOrange : CupertinoColors.systemBackground,
      borderRadius: AppConstants.borderRadiusRegular,
      minimumSize: Size.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _showOnlyAvailable ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
            size: 14,
            color: _showOnlyAvailable ? CupertinoColors.white : CupertinoColors.secondaryLabel,
          ),
          const SizedBox(width: 4),
          Text(
            '仅可接单',
            style: TextStyle(
              fontSize: 14,
              color: _showOnlyAvailable ? CupertinoColors.white : CupertinoColors.label,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(
            CupertinoIcons.search_circle,
            size: 64,
            color: CupertinoColors.inactiveGray,
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无符合条件的需求',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '试试调整筛选条件或稍后再来看看',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.tertiaryLabel,
            ),
          ),
          const SizedBox(height: 24),
          CupertinoButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _showOnlyAvailable = true;
                _sortBy = 'time';
              });
              Provider.of<RequestProvider>(context, listen: false).fetchNearbyRequests();
            },
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(20),
            child: const Text(
              '重置筛选',
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('筛选选项'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _selectedCategory = null;
                _showOnlyAvailable = true;
                _sortBy = 'time';
              });
            },
            child: const Text('重置所有筛选'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<RequestProvider>(context, listen: false).fetchNearbyRequests();
            },
            child: const Text('刷新数据'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ),
    );
  }

  void _showSortSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('排序方式'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _sortBy = 'time';
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('按发布时间'),
                if (_sortBy == 'time') ...[
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.checkmark,
                    color: AppColors.primaryOrange,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _sortBy = 'distance';
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('按距离远近'),
                if (_sortBy == 'distance') ...[
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.checkmark,
                    color: AppColors.primaryOrange,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _sortBy = 'reward';
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('按报酬高低'),
                if (_sortBy == 'reward') ...[
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.checkmark,
                    color: AppColors.primaryOrange,
                    size: 16,
                  ),
                ],
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

  List<RequestModel> _sortRequests(List<RequestModel> requests) {
    switch (_sortBy) {
      case 'time':
        return requests..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case 'distance':
        return requests..sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
      case 'reward':
        return requests..sort((a, b) => b.reward.compareTo(a.reward));
      default:
        return requests;
    }
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
}