# Chủ đề 5: Danh sách, lưới dữ liệu và cuộn trong Flutter (Ứng dụng Khám Phá Sản Phẩm)

Ứng dụng **Khám Phá Sản Phẩm (Product Catalog Explorer)** được xây dựng bằng **Flutter (Material 3)** nhằm minh họa trực quan các nguyên lý kỹ thuật về **Danh sách (`ListView`)**, **Lưới dữ liệu (`GridView`)**, **Cơ chế cuộn (`Viewport`, `Sliver`, `ScrollController`, `ScrollPhysics`)** và **Tải dữ liệu phân trang theo nhu cầu (`Lazy Loading` / `Infinite Scroll`)**.

---

## 👥 Thành viên thực hiện

| STT | Họ và tên | Vai trò & Phân công nhiệm vụ |
| :-: | :--- | :--- |
| 1 | **Trần Quang Thiên** (`@TranQuangThien123`) | - Khởi tạo cấu trúc dự án, thiết kế mô hình dữ liệu `Product` và kho dữ liệu bất đồng bộ `MockProductRepository` hỗ trợ tìm kiếm, lọc danh mục và phân trang (`fetchProducts`).<br>- Xây dựng danh sách `ListView.builder`, thẻ `ProductListItem` co giãn chiều cao tự nhiên với `Wrap`, thanh danh mục cuộn ngang `HorizontalCategoryBar` (`ListView.separated` theo `Axis.horizontal`) và giao diện `EmptyStateView`. |
| 2 | **Nguyễn Đình Hoàn** (`@ndhoan31`) | - Xây dựng giao diện lưới 2 chiều `GridView.builder` (`SliverGridDelegateWithFixedCrossAxisCount`) và thẻ `ProductGridItem`.<br>- Lập trình cơ chế lắng nghe vùng cuộn qua `ScrollController` để tải thêm dữ liệu khi cách đáy `200px` (`_onScroll`, `LoadingIndicatorItem`), màn hình chi tiết sản phẩm với `SingleChildScrollView`, bảng thông tin kỹ thuật `PerformanceInfoSheet`, kiểm thử tự động (`widget_test.dart`) và tài liệu `README.md`. |

---

## 🎯 Tính năng chính của ứng dụng Demo

1. **Chuyển đổi linh hoạt giữa Danh sách (`ListView.builder`) và Lưới (`GridView.builder`)**:
   - **Chế độ Danh sách (`ListView.builder`)**: Dựng phần tử theo nhu cầu 1 chiều dọc; mỗi thẻ `ProductListItem` có chiều cao co giãn tự nhiên theo độ dài tên, mô tả và số lượng nhãn (`Wrap(spacing: 6, runSpacing: 4)`), chống tràn pixel (`RenderFlex overflowed`).
   - **Chế độ Lưới (`GridView.builder`)**: Dựng phần tử 2 chiều thông qua `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68, crossAxisSpacing: 10, mainAxisSpacing: 10)`.
2. **Cuộn lồng nhau khác hướng (`Nested Scroll`)**:
   - Thanh danh mục `HorizontalCategoryBar` sử dụng `ListView.separated` với `scrollDirection: Axis.horizontal` và `BouncingScrollPhysics`, được bọc trong `SizedBox(height: 52)` cố định để tách biệt hoàn toàn với luồng cuộn dọc chính qua cơ chế `Gesture Arena`.
3. **Tải phân trang đón đầu (`Lazy Loading` / `Infinite Scroll`) & Kéo làm mới (`RefreshIndicator`)**:
   - Sử dụng `ScrollController` theo dõi tọa độ cuộn thực tế (`position.pixels >= position.maxScrollExtent - 200`), kết hợp khóa chống gọi trùng (`!_isLoadingMore && !_isLoadingInitial && _hasMore`) và kiểm tra `if (!mounted) return;` sau tác vụ bất đồng bộ.
   - Hỗ trợ kéo từ đỉnh danh sách (`RefreshIndicator` + `AlwaysScrollableScrollPhysics`) để tải lại từ trang đầu (`page = 1`) và nút nổi (`FloatingActionButton`) cuộn mượt về đầu trang (`animateTo(0)`).
4. **Xử lý 3 trạng thái danh sách & Khung chi tiết `SingleChildScrollView`**:
   - Phân định rõ: (1) Đang tải lần đầu / Đang tải thêm (`LoadingIndicatorItem`), (2) Danh sách rỗng khi lọc/tìm kiếm không khớp (`EmptyStateView` kèm nút khôi phục bộ lọc), (3) Đã tải hết dữ liệu (`_hasMore = false`).
   - Khi chạm vào sản phẩm, ứng dụng mở `ModalBottomSheet` sử dụng `SingleChildScrollView` bọc `Column` để cuộn mượt nội dung chi tiết sản phẩm.

---

## 📂 Cấu trúc thư mục dự án

```text
lib/
├── main.dart                                   # Điểm khởi chạy ứng dụng & cấu hình Material 3 Theme
├── models/
│   └── product.dart                            # Mô hình dữ liệu sản phẩm (Product) & tính % giảm giá
├── data/
│   └── mock_products.dart                      # Kho dữ liệu giả lập (MockProductRepository) hỗ trợ phân trang & lọc
├── screens/
│   └── product_catalog_screen.dart             # Màn hình chính điều phối ListView/GridView, ScrollController & tìm kiếm
└── widgets/
    ├── empty_state_view.dart                   # Giao diện trạng thái danh sách rỗng & nút xóa bộ lọc
    ├── horizontal_category_bar.dart            # Thanh danh mục cuộn ngang (ListView.separated - Axis.horizontal)
    ├── loading_indicator_item.dart             # Mục hiển thị vòng xoay tải thêm hoặc thông báo hết dữ liệu ở cuối danh sách
    ├── performance_info_sheet.dart             # Bảng tóm tắt kiến trúc Sliver, Viewport & tối ưu hiệu năng cuộn
    ├── product_grid_item.dart                  # Thẻ hiển thị sản phẩm trong chế độ lưới 2 cột (GridView)
    └── product_list_item.dart                  # Thẻ hiển thị sản phẩm co giãn chiều cao trong chế độ danh sách (ListView)
```

---

## ⚙️ Yêu cầu hệ thống & Hướng dẫn cài đặt

### 1. Yêu cầu môi trường
- **Flutter SDK**: `>= 3.11.0`
- **Dart SDK**: `>= 3.11.0`
- Trình duyệt **Chrome / Edge**, **Windows Desktop**, hoặc **Android Studio / VS Code** kèm máy ảo Android/iOS.

### 2. Các bước cài đặt

**Bước 1: Clone dự án từ GitHub**
```bash
git clone https://github.com/TranQuangThien123/chudetuan14.git
cd chudetuan14
```

**Bước 2: Cài đặt các thư viện phụ thuộc (Dependencies)**
```bash
flutter pub get
```

**Bước 3: Cấu hình biến môi trường (`.env`) / Dịch vụ bên thứ ba**
> **Lưu ý**: Dự án sử dụng Flutter SDK thuần và kho dữ liệu phân trang cục bộ (`MockProductRepository`), **không** phụ thuộc vào API trả phí hay Firebase nên **không bắt buộc** cấu hình file `.env` để chạy ứng dụng.
> - Nếu muốn tùy chỉnh biến môi trường cục bộ, bạn có thể sao chép file mẫu `.env.example` ở thư mục gốc thành `.env`:
>   ```bash
>   cp .env.example .env
>   ```

**Bước 4: Chạy ứng dụng**
- Chạy trên Windows Desktop hoặc trình duyệt Web (Chrome):
  ```bash
  flutter run -d windows
  # hoặc
  flutter run -d chrome
  ```
- Chạy trên thiết bị mặc định (Android / iOS):
  ```bash
  flutter run
  ```

---

## 🧪 Kiểm tra chất lượng mã nguồn (Analyze & Unit/Widget Tests)

- Kiểm tra quy chuẩn mã nguồn (`flutter_lints`):
  ```bash
  flutter analyze
  ```
- Chạy kịch bản kiểm thử tự động (`widget_test.dart`):
  ```bash
  flutter test
  ```
