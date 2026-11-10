import 'package:flutter/material.dart';

/// Minh họa XỬ LÝ TRẠNG THÁI DANH SÁCH RỖNG (Empty State):
/// Khi người dùng tìm kiếm từ khóa không có kết quả hoặc lọc danh mục
/// mà không có sản phẩm nào, ta hiển thị giao diện thân thiện thay vì để
/// màn hình trắng trơn, đồng thời cung cấp nút hành động (Call To Action).
class EmptyStateView extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final VoidCallback onReset;

  const EmptyStateView({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 72,
                color: Colors.blue.shade400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Không tìm thấy sản phẩm!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'Không có kết quả nào khớp với từ khóa "$searchQuery"'
                  : 'Không có sản phẩm nào trong danh mục "$selectedCategory"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Xóa bộ lọc & Tải lại'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
