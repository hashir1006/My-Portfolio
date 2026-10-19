import 'package:flutter_test/flutter_test.dart';
import 'package:hashir_portfolio/app.dart';
import 'package:hashir_portfolio/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Hashir Portfolio loads and displays primary brand elements',
      (WidgetTester tester) async {
    final themeController = ThemeController();

    await tester.pumpWidget(HashirPortfolioApp(themeController: themeController));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(seconds: 4));

    // Verify brand title and key sections exist
    expect(find.text('HASHIR SHAIKH'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('About'), findsWidgets);
    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Skills'), findsWidgets);
  });
}
