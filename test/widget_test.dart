import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavan360/app.dart';
import 'package:uzhavan360/core/services/storage_service.dart';

void main() {
  testWidgets('Uzhavan360App smoke test builds successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    await tester.pumpWidget(const Uzhavan360App());
    expect(find.byType(Uzhavan360App), findsOneWidget);
  });
}
