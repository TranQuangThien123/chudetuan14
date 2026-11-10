import 'package:flutter_test/flutter_test.dart';
import 'package:chudetuan14/main.dart';

void main() {
  testWidgets('Product catalog loads and displays title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Chờ Future.delayed hoàn thành và giải phóng các frame/timer
    await tester.pumpAndSettle();
    expect(find.text('Khám Phá Sản Phẩm'), findsOneWidget);
  });
}
