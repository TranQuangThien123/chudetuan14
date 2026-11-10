import 'package:flutter/material.dart';
import '../models/product.dart';

/// Đại diện cho phần tử hiển thị trong ListView.
/// MINH HỌA XỬ LÝ DỮ LIỆU CÓ KÍCH THƯỚC KHÁC NHAU:
/// - Tiêu đề có độ dài thay đổi linh hoạt (1 đến nhiều dòng).
/// - Danh sách thẻ tags sử dụng Wrap widget để tự động rớt dòng linh hoạt
///   tránh hoàn toàn lỗi Overflow (tràn pixel).
/// - Card có chiều cao tự động co giãn theo nội dung (Dynamic intrinsic sizing).
class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductListItem({
    super.key,
    required this.product,
    this.onTap,
  });

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'headphones':
        return Icons.headphones;
      case 'tv':
        return Icons.tv;
      case 'mouse':
        return Icons.mouse;
      case 'smartphone':
        return Icons.smartphone;
      case 'kitchen':
        return Icons.kitchen;
      case 'cable':
        return Icons.cable;
      case 'keyboard':
        return Icons.keyboard;
      case 'speaker':
        return Icons.speaker;
      case 'local_cafe':
        return Icons.local_cafe;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  Color _parseColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.blueGrey;
    }
  }

  String _formatCurrency(double amount) {
    final str = amount.toStringAsFixed(0);
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(product.colorHex);

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Ảnh đại diện/Icon sản phẩm với màu sắc nhận diện
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Icon(
                    _resolveIcon(product.iconName),
                    size: 42,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // 2. Nội dung chi tiết - Tự động thích ứng kích thước
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hàng danh mục + Badge giảm giá nếu có
                    Row(
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        if (product.discountTag != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Text(
                              product.discountTag!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Tên sản phẩm: Chiều cao động tùy thuộc độ dài text
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Mô tả ngắn gọn
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Xử lý các thẻ tags có số lượng và độ dài khác nhau
                    if (product.tags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: product.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 8),

                    // Đánh giá và Giá bán
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' (${product.reviewsCount})',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (product.originalPrice != null)
                              Text(
                                _formatCurrency(product.originalPrice!),
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            Text(
                              _formatCurrency(product.price),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
