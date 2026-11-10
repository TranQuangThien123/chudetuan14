import 'package:flutter/material.dart';

/// Minh họa LAZY LOADING Ở MỨC GIAO DIỆN:
/// Widget hiển thị ở cuối danh sách khi người dùng cuộn tới đáy.
/// - Nếu còn dữ liệu: Hiện Spinner quay "Đang tải thêm..."
/// - Nếu đã hết dữ liệu: Báo "Đã hiển thị toàn bộ sản phẩm"
class LoadingIndicatorItem extends StatelessWidget {
  final bool hasMore;

  const LoadingIndicatorItem({
    super.key,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: hasMore
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                const SizedBox(height: 10),
                Text(
                  'Đang nạp thêm dữ liệu (Lazy Loading)...',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(
                  'Đã xem hết toàn bộ sản phẩm',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
    );
  }
}
