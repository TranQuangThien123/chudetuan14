/// Model đại diện cho một sản phẩm trong ứng dụng Khám phá sản phẩm.
/// Thiết kế có các trường dữ liệu có độ dài/kích thước khác nhau để minh họa
/// việc xử lý layout co giãn tự nhiên trong ListView và GridView.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final String? discountTag;
  final List<String> tags; // Các nhãn đặc trưng (Free Ship, Chính hãng, Bán chạy...)
  final String description; // Mô tả có độ dài ngẫu nhiên để thử nghiệm kích thước khác nhau
  final String colorHex;
  final String iconName;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    this.discountTag,
    required this.tags,
    required this.description,
    required this.colorHex,
    required this.iconName,
  });

  /// Tính % giảm giá nếu có originalPrice
  int get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
