import 'package:flutter_test/flutter_test.dart';
import 'package:agrifarm/main.dart';

void main() {
  testWidgets('AgriFarm app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AgriFarmApp());
    expect(find.byType(AgriFarmApp), findsOneWidget);
  });
}
