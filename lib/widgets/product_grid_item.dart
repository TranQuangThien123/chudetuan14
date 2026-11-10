import 'package:flutter/material.dart';
import '../models/product.dart';

/// Đại diện cho phần tử hiển thị trong GridView.
/// MINH HỌA CÁCH XỬ LÝ DỮ LIỆU CÓ KÍCH THƯỚC KHÁC NHAU TRONG LƯỚI (2D GRID):
/// - Trong GridView, mỗi ô có không gian giới hạn bởi childAspectRatio.
/// - Sử dụng Flexible/Expanded, TextOverflow.ellipsis và maxLines
///   để đảm bảo không bị RenderFlex overflow kể cả khi tên sản phẩm dài 3-4 dòng.
class ProductGridItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductGridItem({
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Khung ảnh/icon có badge giảm giá ở góc
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: color.withValues(alpha: 0.12),
                  child: Center(
                    child: Icon(
                      _resolveIcon(product.iconName),
                      size: 48,
                      color: color,
                    ),
                  ),
                ),
                if (product.discountTag != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.discountTag!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // 2. Nội dung thông tin
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Tên sản phẩm: Giới hạn 2 dòng với ellipsis
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Tag đầu tiên (nếu có)
                        if (product.tags.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              product.tags.first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Đánh giá và Giá bán
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' (${product.reviewsCount})',
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatCurrency(product.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
