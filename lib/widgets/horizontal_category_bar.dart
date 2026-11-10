import 'package:flutter/material.dart';

/// Minh họa CUỘN LỒNG NHAU (Nested Scrolling):
/// Một thanh danh mục cuộn ngang (Axis.horizontal) được đặt lồng
/// bên trong màn hình cuộn dọc chính.
/// Flutter tự động giải quyết xung đột cử chỉ (gesture disambiguation)
/// nhờ vào việc xác định hướng kéo (Horizontal Drag vs Vertical Drag).
class HorizontalCategoryBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const HorizontalCategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.separated(
        // Cuộn ngang lồng trong luồng cuộn dọc
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            avatar: isSelected
                ? const Icon(Icons.check_circle, size: 16, color: Colors.white)
                : null,
            label: Text(
              cat,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            selectedColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
              ),
            ),
            onSelected: (_) => onCategorySelected(cat),
          );
        },
      ),
    );
  }
}
