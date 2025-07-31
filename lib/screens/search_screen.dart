import 'package:flutter/cupertino.dart';
import '../utils/app_constants.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/request_provider.dart';
import '../models/request_model.dart';
import '../widgets/request_card.dart';
import 'request_detail_screen.dart';

/// 搜索页面
/// 对应原型图中的search.html
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<RequestModel> _searchResults = [];
  List<String> _searchHistory = [];
  List<String> _hotSearches = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadSearchData();
    // 自动聚焦搜索框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadSearchData() {
    // 模拟加载搜索历史和热门搜索
    _searchHistory = [
      '帮忙取快递',
      '代课签到',
      '带饭',
      '拼单奶茶',
    ];
    
    _hotSearches = [
      '取快递',
      '带饭',
      '代课',
      '拼单',
      '搬东西',
      '借书',
      '打印',
      '充电宝',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.label,
          ),
        ),
        middle: Container(
          height: 36,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: AppConstants.borderRadiusLarge18,
          ),
          child: CupertinoTextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            placeholder: '搜索需求...',
            prefix: const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                CupertinoIcons.search,
                color: CupertinoColors.placeholderText,
                size: 18,
              ),
            ),
            suffix: _searchController.text.isNotEmpty
                ? CupertinoButton(
                    padding: const EdgeInsets.only(right: 8),
                    minimumSize: Size.zero,
                    onPressed: _clearSearch,
                    child: const Icon(
                      CupertinoIcons.clear_circled_solid,
                      color: CupertinoColors.placeholderText,
                      size: 18,
                    ),
                  )
                : null,
            decoration: const BoxDecoration(),
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.label,
            ),
            placeholderStyle: const TextStyle(
              color: CupertinoColors.placeholderText,
            ),
            onChanged: _onSearchChanged,
            onSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _performSearch,
          child: const Text(
            '搜索',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryOrange,
            ),
          ),
        ),
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isSearching) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (_hasSearched) {
      return _buildSearchResults();
    }

    return _buildSearchSuggestions();
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索历史
          if (_searchHistory.isNotEmpty) ...[
            _buildSectionHeader(
              title: '搜索历史',
              action: '清空',
              onActionTap: _clearSearchHistory,
            ),
            const SizedBox(height: 12),
            _buildHistoryList(),
            const SizedBox(height: 24),
          ],
          
          // 热门搜索
          _buildSectionHeader(
            title: '热门搜索',
          ),
          const SizedBox(height: 12),
          _buildHotSearchGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? action,
    VoidCallback? onActionTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
        ),
        const Spacer(),
        if (action != null && onActionTap != null)
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: onActionTap,
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusMedium,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: _searchHistory.asMap().entries.map((entry) {
          final index = entry.key;
          final keyword = entry.value;
          return Column(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onPressed: () => _searchKeyword(keyword),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.clock,
                      color: CupertinoColors.secondaryLabel,
                      size: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        keyword,
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.label,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => _removeFromHistory(keyword),
                      child: const Icon(
                        CupertinoIcons.clear,
                        color: CupertinoColors.secondaryLabel,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < _searchHistory.length - 1)
                Container(
                  margin: const EdgeInsets.only(left: 44),
                  height: 0.5,
                  color: CupertinoColors.separator,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHotSearchGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: AppConstants.borderRadiusMedium,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _hotSearches.map((keyword) {
          return GestureDetector(
            onTap: () => _searchKeyword(keyword),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: AppConstants.borderRadiusRegular,
              ),
              child: Text(
                keyword,
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.label,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.search,
              size: 64,
              color: CupertinoColors.systemGrey3,
            ),
            const SizedBox(height: 16),
            const Text(
              '没有找到相关需求',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '试试其他关键词',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.tertiaryLabel,
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              onPressed: () {
                setState(() {
                  _hasSearched = false;
                  _searchController.clear();
                });
              },
              color: AppColors.primaryOrange,
              borderRadius: AppConstants.borderRadiusLarge,
              child: const Text(
                '重新搜索',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 搜索结果头部
        Container(
          padding: const EdgeInsets.all(16),
          color: CupertinoColors.systemBackground,
          child: Row(
            children: [
              Text(
                '找到 ${_searchResults.length} 个相关需求',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.label,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: _showSortOptions,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '排序',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.sort_down,
                      color: AppColors.primaryOrange,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 搜索结果列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final request = _searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RequestCard(
                  request: request,
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => RequestDetailScreen(
                          request: request,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSearchChanged(String value) {
    setState(() {});
  }

  void _performSearch([String? keyword]) {
    final searchText = keyword ?? _searchController.text.trim();
    if (searchText.isEmpty) return;

    if (keyword != null) {
      _searchController.text = keyword;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = false;
    });

    // 添加到搜索历史
    _addToSearchHistory(searchText);

    // 模拟搜索
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final allRequests = context.read<RequestProvider>().requests;
      final results = allRequests.where((request) {
        return request.title.toLowerCase().contains(searchText.toLowerCase()) ||
               request.description.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _hasSearched = true;
      });
    });

    // 收起键盘
    _searchFocusNode.unfocus();
  }

  void _searchKeyword(String keyword) {
    _performSearch(keyword);
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchResults.clear();
      _hasSearched = false;
    });
  }

  void _addToSearchHistory(String keyword) {
    setState(() {
      _searchHistory.remove(keyword);
      _searchHistory.insert(0, keyword);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.take(10).toList();
      }
    });
  }

  void _removeFromHistory(String keyword) {
    setState(() {
      _searchHistory.remove(keyword);
    });
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  void _showSortOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('排序方式'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _sortResults('time');
            },
            child: const Text('按时间排序'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _sortResults('reward');
            },
            child: const Text('按报酬排序'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              _sortResults('distance');
            },
            child: const Text('按距离排序'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ),
    );
  }

  void _sortResults(String sortType) {
    setState(() {
      switch (sortType) {
        case 'time':
          _searchResults.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'reward':
          _searchResults.sort((a, b) => b.reward.compareTo(a.reward));
          break;
        case 'distance':
          // 实现按距离排序（功能待实现）
          break;
      }
    });
  }
}