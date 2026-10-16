import 'dart:convert';

import 'package:http/http.dart' show Response;
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcoo/main.dart';

void main() {
  setUp(() {
    BlueWayApi.client = MockClient((request) async {
      if (request.url.path.endsWith('/buses')) {
        final buses = blueWayBuses
            .map((bus) => {'id': bus.id, 'route': bus.route, ...bus.toJson()})
            .toList();
        return Response(
          jsonEncode(buses),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
      if (request.url.path.endsWith('/bookings')) {
        return Response(
          '[]',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
      return Response(
        jsonEncode({'error': 'Unexpected test request'}),
        404,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
  });

  testWidgets('Blue Way app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const BlueWayApp());
    await tester.pumpAndSettle();

    expect(blueWayStore.ready, isTrue, reason: blueWayStore.loadError);
    expect(find.text('BLUE WAY'), findsWidgets);
    expect(find.text('QUICK ACCESS'), findsOneWidget);
  });

  testWidgets('Bottom navigation displays all destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BlueWayApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Buses'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
