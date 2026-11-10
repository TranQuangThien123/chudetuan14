import 'package:flutter/material.dart';

/// Modal trình bày tóm tắt Cơ Sở Lý Thuyết & Vấn Đề Hiệu Năng
/// Giúp người xem dễ dàng đối chiếu lý thuyết với phần demo thực tế ngay trên ứng dụng.
class PerformanceInfoSheet extends StatelessWidget {
  const PerformanceInfoSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PerformanceInfoSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Thanh kéo drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Cơ sở lý thuyết & Phân tích hiệu năng',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionCard(
                      title: '1. So sánh 4 Widget Cuộn Căn Bản',
                      icon: Icons.compare_arrows,
                      content: [
                        '• SingleChildScrollView: Thích hợp cho layout tĩnh, ít phần tử (như Form, trang Cài đặt). Tạo toàn bộ con vào RAM ngay khi vẽ -> Không dùng cho danh sách dài.',
                        '• ListView(children: [...]): Chỉ nên dùng cho số ít widget cố định vì nó khởi tạo toàn bộ widget con cùng lúc.',
                        '• ListView.builder: Sử dụng cơ chế Virtualization (Lazy Loading). Chỉ khởi tạo các widget nằm trong Viewport hiển thị (+ cacheExtent). Tiết kiệm RAM và CPU tối đa.',
                        '• GridView / GridView.builder: Tương tự ListView nhưng xếp layout 2D. Dùng SliverGridDelegate để chia cột theo số lượng cố định hoặc độ rộng tối đa.',
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      title: '2. Cuộn lồng nhau (Nested Scrolling)',
                      icon: Icons.layers,
                      content: [
                        '• Thách thức: Tranh chấp cử chỉ cuộn (Scroll Gesture Collision) giữa widget cuộn con và cha.',
                        '• Khác chiều (Horizontal trong Vertical): Flutter tự nhận diện hướng vuốt mượt mà (như thanh Danh mục trong demo).',
                        '• Cùng chiều: Tránh dùng bừa bãi `shrinkWrap: true` trong danh sách dài vì làm mất tính năng Lazy Loading (buộc phải tính trước toàn bộ chiều cao).',
                        '• Giải pháp tối ưu: Dùng CustomScrollView kết hợp Slivers (SliverAppBar, SliverList, SliverGrid).',
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      title: '3. Lazy Loading & Tối ưu hiệu năng',
                      icon: Icons.speed,
                      content: [
                        '• Infinite Scroll: Dùng ScrollController lắng nghe vị trí chạm đáy để nạp thêm (Pagination).',
                        '• itemExtent / prototypeItem: Giúp Flutter biết trước chiều cao từng item với độ phức tạp O(1) mà không cần tính toán layout phức tạp.',
                        '• RepaintBoundary: Cách ly vùng vẽ của các phần tử phức tạp để tránh vẽ lại toàn bộ danh sách khi cuộn.',
                        '• Dùng const constructors để tránh cấp phát lại widget thừa.',
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      title: '4. Xử lý kích thước khác nhau & Trạng thái rỗng',
                      icon: Icons.widgets,
                      content: [
                        '• Kích thước khác nhau (Heterogeneous items): Dùng Wrap cho các thẻ nhãn, TextOverflow.ellipsis và maxLines cho tiêu đề để tránh lỗi tràn màn hình (Overflow error).',
                        '• Trạng thái rỗng (Empty State): Khi lọc danh mục hoặc tìm kiếm không thấy sản phẩm, thay thế bằng giao diện rỗng thân thiện kèm nút Đặt lại bộ lọc.',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<String> content,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...content.map(
              (line) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Text(
                  line,
                  style: const TextStyle(fontSize: 13, height: 1.35, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
