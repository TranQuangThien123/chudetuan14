import 'package:flutter/material.dart';
import '../data/mock_products.dart';
import '../models/product.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/horizontal_category_bar.dart';
import '../widgets/loading_indicator_item.dart';
import '../widgets/performance_info_sheet.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_list_item.dart';

enum ViewMode { list, grid }

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  ViewMode _viewMode = ViewMode.list;
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';

  List<Product> _products = [];
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 6;

  @override
  void initState() {
    super.initState();
    _loadInitialProducts();

    // Lắng nghe sự kiện cuộn để kích hoạt LAZY LOADING khi người dùng cuộn gần tới đáy
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Khi vị trí cuộn cách đáy dưới 200 pixel và không đang bận tải
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !_isLoadingInitial &&
        _hasMore) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadInitialProducts() async {
    setState(() {
      _isLoadingInitial = true;
      _currentPage = 1;
      _hasMore = true;
    });

    final items = await MockProductRepository.fetchProducts(
      page: 1,
      pageSize: _pageSize,
      query: _searchQuery,
      selectedCategory: _selectedCategory,
    );

    if (mounted) {
      setState(() {
        _products = items;
        _isLoadingInitial = false;
        _hasMore = items.length >= _pageSize;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;
    final items = await MockProductRepository.fetchProducts(
      page: nextPage,
      pageSize: _pageSize,
      query: _searchQuery,
      selectedCategory: _selectedCategory,
    );

    if (mounted) {
      setState(() {
        _currentPage = nextPage;
        _isLoadingMore = false;
        if (items.isEmpty) {
          _hasMore = false;
        } else {
          _products.addAll(items);
          if (items.length < _pageSize) {
            _hasMore = false;
          }
        }
      });
    }
  }

  void _onCategorySelected(String category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
    });
    _loadInitialProducts();
  }

  void _onSearchChanged(String val) {
    setState(() {
      _searchQuery = val;
    });
    _loadInitialProducts();
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'Tất cả';
      _searchController.clear();
    });
    _loadInitialProducts();
  }

  void _triggerEmptyStateDemo() {
    setState(() {
      _searchQuery = '@@@_khong_co_du_lieu_@@@';
      _searchController.text = _searchQuery;
    });
    _loadInitialProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded, size: 26),
            SizedBox(width: 8),
            Text(
              'Khám Phá Sản Phẩm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
        actions: [
          // Nút xem thông tin lý thuyết & phân tích hiệu năng
          IconButton(
            tooltip: 'Lý thuyết & Hiệu năng',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => PerformanceInfoSheet.show(context),
          ),
          // Nút chuyển đổi giao diện Danh Sách ↔ Lưới
          IconButton(
            tooltip: _viewMode == ViewMode.list
                ? 'Chuyển sang dạng Lưới'
                : 'Chuyển sang dạng Danh sách',
            icon: Icon(
              _viewMode == ViewMode.list
                  ? Icons.grid_view_rounded
                  : Icons.view_list_rounded,
            ),
            onPressed: () {
              setState(() {
                _viewMode =
                    _viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitialProducts,
        child: Column(
          children: [
            // 1. Ô tìm kiếm sản phẩm (Search Box)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm tai nghe, iphone, áo phông, tag...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : IconButton(
                          tooltip: 'Thử nghiệm Empty State',
                          icon: const Icon(Icons.filter_alt_off_outlined),
                          onPressed: _triggerEmptyStateDemo,
                        ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),

            // 2. CUỘN LỒNG NHAU: Thanh danh mục cuộn ngang (Horizontal scroll)
            HorizontalCategoryBar(
              categories: MockProductRepository.categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: _onCategorySelected,
            ),

            // 3. Thanh trạng thái số lượng sản phẩm & Chế độ xem hiện tại
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Đang hiển thị ${_products.length} sản phẩm',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.blue.shade50,
                    label: Text(
                      _viewMode == ViewMode.list
                          ? 'Chế độ: ListView.builder'
                          : 'Chế độ: GridView.builder',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // 4. VÙNG CUỘN CHÍNH: Xử lý tập dữ liệu dài, Trạng thái rỗng, List vs Grid
            Expanded(
              child: _buildScrollBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollBody() {
    // 1. Trạng thái tải ban đầu
    if (_isLoadingInitial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Đang nạp dữ liệu ban đầu...'),
          ],
        ),
      );
    }

    // 2. Trạng thái danh sách rỗng (Empty State)
    if (_products.isEmpty) {
      return EmptyStateView(
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory,
        onReset: _resetFilters,
      );
    }

    // 3. Chế độ DANH SÁCH (ListView.builder)
    if (_viewMode == ViewMode.list) {
      return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        // Thêm 1 item ở cuối danh sách để chứa LoadingIndicatorItem
        itemCount: _products.length + 1,
        itemBuilder: (context, index) {
          // Phần tử cuối cùng là Loading Indicator / End of List message
          if (index == _products.length) {
            return LoadingIndicatorItem(hasMore: _hasMore);
          }

          final product = _products[index];
          return ProductListItem(
            product: product,
            onTap: () => _showProductDetails(product),
          );
        },
      );
    }

    // 4. Chế độ LƯỚI (GridView.builder)
    return GridView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68, // Tỉ lệ chiều rộng / chiều cao của mỗi thẻ
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      // Thêm 1 ô hoặc hiển thị loader
      itemCount: _products.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _products.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final product = _products[index];
        return ProductGridItem(
          product: product,
          onTap: () => _showProductDetails(product),
        );
      },
    );
  }

  void _showProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Danh mục: ${product.category}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      },
    );
  }
}
