import 'package:flutter_test/flutter_test.dart';
import 'package:marcoo/main.dart';

void main() {
  testWidgets('Blue Way app loads successfully', (
    WidgetTester tester,
  ) async {
    // Launch the actual Blue Way application.
    await tester.pumpWidget(const BlueWayApp());

    // Verify that the home page appears.
    expect(find.text('Good day! 👋'), findsOneWidget);

    // Verify that the home page contains the main branding.
    expect(find.text('BLUE WAY'), findsWidgets);

    // Verify that the quick services section appears.
    expect(find.text('Quick Services'), findsOneWidget);
  });

  testWidgets('Bottom navigation displays all destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BlueWayApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Buses'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}