import 'package:athkar/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  testWidgets('App launches with Nur branding', (WidgetTester tester) async {
    await GetStorage.init();
    await tester.pumpWidget(const NurTasbeehApp());
    await tester.pumpAndSettle();

    expect(find.text('Nur'), findsWidgets);
  });
}
