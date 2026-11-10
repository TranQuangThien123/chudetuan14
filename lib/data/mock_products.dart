import 'dart:math';
import '../models/product.dart';

class MockProductRepository {
  static const List<String> categories = [
    'Tất cả',
    'Điện thoại & Tablet',
    'Laptop & PC',
    'Âm thanh',
    'Thời trang',
    'Gia dụng',
    'Phụ kiện',
  ];

  static final List<Product> _masterDataset = [
    const Product(
      id: 'p1',
      name: 'Tai nghe chụp tai Sony WH-1000XM5 Hi-Res Audio chống ồn chủ động đỉnh cao',
      category: 'Âm thanh',
      price: 7990000,
      originalPrice: 8990000,
      rating: 4.9,
      reviewsCount: 1420,
      discountTag: '-11%',
      tags: ['Chính hãng 100%', 'Freeship Xtra', 'Bảo hành 12T'],
      description: 'Chống ồn thông minh thích ứng môi trường với 8 micro kép, pin lên tới 30 giờ nghe nhạc liên tục.',
      colorHex: '#3F51B5',
      iconName: 'headphones',
    ),
    const Product(
      id: 'p2',
      name: 'Áo phông Basic',
      category: 'Thời trang',
      price: 149000,
      originalPrice: 199000,
      rating: 4.6,
      reviewsCount: 320,
      discountTag: '-25%',
      tags: ['Bán chạy'],
      description: 'Chất liệu 100% cotton thoáng mát thấm hút mồ hôi.',
      colorHex: '#4CAF50',
      iconName: 'checkroom',
    ),
    const Product(
      id: 'p3',
      name: 'Màn hình cong Samsung Odyssey Neo G9 49 inch Dual QHD 240Hz 1ms Mini-LED HDR2000 Siêu Đồ Họa & Gaming',
      category: 'Laptop & PC',
      price: 36990000,
      originalPrice: 42990000,
      rating: 4.8,
      reviewsCount: 88,
      discountTag: '-14%',
      tags: ['Hàng VIP', 'Hỗ trợ trả góp 0%', 'Freeship', 'Bảo hành 24T'],
      description: 'Trải nghiệm thị giác bao trọn tầm nhìn với bán kính cong 1000R, công nghệ Quantum Mini-LED tái tạo màu đen sâu thẳm.',
      colorHex: '#E91E63',
      iconName: 'tv',
    ),
    const Product(
      id: 'p4',
      name: 'Chuột Logitech G Pro X Superlight 2',
      category: 'Phụ kiện',
      price: 3290000,
      originalPrice: 3890000,
      rating: 5.0,
      reviewsCount: 954,
      discountTag: '-15%',
      tags: ['Esports', 'Chính hãng'],
      description: 'Trọng lượng siêu nhẹ chỉ 60g, cảm biến HERO 2 độ chính xác sub-micron.',
      colorHex: '#00BCD4',
      iconName: 'mouse',
    ),
    const Product(
      id: 'p5',
      name: 'iPhone 15 Pro Max 256GB Titan Tự Nhiên',
      category: 'Điện thoại & Tablet',
      price: 29490000,
      originalPrice: 34990000,
      rating: 4.9,
      reviewsCount: 4210,
      discountTag: '-16%',
      tags: ['Apple VN', 'Freeship Xtra', 'Đổi mới 30 ngày', 'Titan Grade 5'],
      description: 'Khung titan chuẩn hàng không vũ trụ, chip Apple A17 Pro cực mạnh mẽ cùng nút Action tùy biến thông minh.',
      colorHex: '#607D8B',
      iconName: 'smartphone',
    ),
    const Product(
      id: 'p6',
      name: 'Nồi chiên không dầu Philips XXL 7.2L',
      category: 'Gia dụng',
      price: 3850000,
      originalPrice: 5200000,
      rating: 4.7,
      reviewsCount: 640,
      discountTag: '-26%',
      tags: ['Gia đình', 'Freeship'],
      description: 'Công nghệ Rapid Air độc quyền giúp món chiên vàng giòn rụm bên ngoài và mềm mọng bên trong mà không ngấy mỡ.',
      colorHex: '#FF9800',
      iconName: 'kitchen',
    ),
    const Product(
      id: 'p7',
      name: 'Cáp sạc Type-C 100W bọc dù',
      category: 'Phụ kiện',
      price: 89000,
      originalPrice: 120000,
      rating: 4.5,
      reviewsCount: 8120,
      discountTag: '-26%',
      tags: ['Rẻ vô địch'],
      description: 'Dây bọc sợi nylon chịu lực uốn gập 20.000 lần.',
      colorHex: '#795548',
      iconName: 'cable',
    ),
    const Product(
      id: 'p8',
      name: 'Bàn phím cơ không dây Custom Keychron Q1 Pro RGB Switch Banana Hot-swap Vỏ Nhôm CNC Nguyên Khối Đầm Tay',
      category: 'Laptop & PC',
      price: 4890000,
      originalPrice: 5390000,
      rating: 4.9,
      reviewsCount: 215,
      discountTag: '-9%',
      tags: ['Custom Mech', 'Bluetooth 5.1 & Type-C', 'Keycap PBT'],
      description: 'Thiết kế Double Gasket Mount mang lại âm gõ trầm ấm và cảm giác gõ êm ái thư giãn suốt ngày dài làm việc.',
      colorHex: '#9C27B0',
      iconName: 'keyboard',
    ),
    const Product(
      id: 'p9',
      name: 'Loa Bluetooth Marshall Emberton II',
      category: 'Âm thanh',
      price: 3990000,
      originalPrice: null,
      rating: 4.8,
      reviewsCount: 512,
      discountTag: null,
      tags: ['Vintage Style', 'Chống nước IP67', 'Pin 30h'],
      description: 'Âm thanh không gian True Stereophonic 360 độ đặc trưng của Marshall trong thân hình nhỏ gọn bền bỉ.',
      colorHex: '#212121',
      iconName: 'speaker',
    ),
    const Product(
      id: 'p10',
      name: 'Bình giữ nhiệt Lock&Lock 500ml',
      category: 'Gia dụng',
      price: 249000,
      originalPrice: 350000,
      rating: 4.8,
      reviewsCount: 3100,
      discountTag: '-29%',
      tags: ['Inox 316', 'Giữ nhiệt 24h'],
      description: 'Thiết kế nắp bật 1 chạm tiện lợi khi lái xe.',
      colorHex: '#009688',
      iconName: 'local_cafe',
    ),
  ];

  /// Giả lập tạo thêm sản phẩm động (Lazy Loading vô tận) dựa trên trang yêu cầu
  static Future<List<Product>> fetchProducts({
    required int page,
    int pageSize = 6,
    String? query,
    String? selectedCategory,
    Duration latency = const Duration(milliseconds: 650),
  }) async {
    // Mô phỏng độ trễ mạng Internet
    await Future.delayed(latency);

    // Lọc theo từ khóa tìm kiếm và danh mục
    var filtered = _masterDataset.where((item) {
      final matchesQuery = query == null ||
          query.trim().isEmpty ||
          item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.tags.any((t) => t.toLowerCase().contains(query.toLowerCase()));

      final matchesCategory = selectedCategory == null ||
          selectedCategory == 'Tất cả' ||
          item.category == selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();

    // Nếu dữ liệu gốc ít, ta nhân bản theo page để demo danh sách dài / lazy load
    if (filtered.isNotEmpty) {
      final expandedList = <Product>[];
      // Nhân bản thêm nhiều trang (đến trang 5) để minh họa Lazy Loading
      for (int i = 0; i < 5; i++) {
        for (var item in filtered) {
          final suffix = (i == 0) ? '' : ' [Lô ${i + 1}]';
          expandedList.add(
            Product(
              id: '${item.id}_batch_$i',
              name: '${item.name}$suffix',
              category: item.category,
              price: item.price + (i * 10000),
              originalPrice: item.originalPrice != null
                  ? item.originalPrice! + (i * 10000)
                  : null,
              rating: item.rating,
              reviewsCount: item.reviewsCount + i * 50,
              discountTag: item.discountTag,
              tags: item.tags,
              description: item.description,
              colorHex: item.colorHex,
              iconName: item.iconName,
            ),
          );
        }
      }

      final startIndex = (page - 1) * pageSize;
      if (startIndex >= expandedList.length) {
        return []; // Hết dữ liệu (End of list)
      }
      final endIndex = min(startIndex + pageSize, expandedList.length);
      return expandedList.sublist(startIndex, endIndex);
    }

    return [];
  }
}
