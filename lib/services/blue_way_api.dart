part of '../main.dart';

class BlueWayApi {
  static const _configuredUrl = String.fromEnvironment('BLUE_WAY_API_URL');
  static const _timeout = Duration(seconds: 10);
  static http.Client client = http.Client();

  static String get baseUrl {
    if (_configuredUrl.isNotEmpty) {
      return _configuredUrl.replaceFirst(RegExp(r'/$'), '');
    }
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return 'http://localhost:3000/api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  static Future<Object?> _request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.Request(method, uri);
    if (body != null) {
      request.headers['content-type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    try {
      final response = await client.send(request).timeout(_timeout);
      final text = await response.stream.bytesToString();
      final Object? data = text.isEmpty ? null : jsonDecode(text);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = data is Map<String, dynamic>
            ? data['error'] as String? ?? 'Request failed.'
            : 'Request failed with status ${response.statusCode}.';
        throw Exception(message);
      }
      return data;
    } on http.ClientException catch (error) {
      throw Exception('Could not reach the Blue Way API at $baseUrl: $error');
    } on FormatException catch (error) {
      throw Exception('The Blue Way API returned invalid data: $error');
    }
  }

  static Future<List<BlueWayBus>> getBuses() async {
    final data = await _request('/buses');
    return (data! as List)
        .map((item) => BlueWayBus.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<BlueWayBus> createBus(BlueWayBus bus) async =>
      BlueWayBus.fromJson(
        await _request('/buses', method: 'POST', body: bus.toJson())
            as Map<String, dynamic>,
      );

  static Future<BlueWayBus> updateBus(BlueWayBus bus) async =>
      BlueWayBus.fromJson(
        await _request(
          '/buses/${Uri.encodeComponent(bus.id)}',
          method: 'PATCH',
          body: bus.toJson(),
        ) as Map<String, dynamic>,
      );

  static Future<void> deleteBus(String id) async {
    await _request('/buses/${Uri.encodeComponent(id)}', method: 'DELETE');
  }

  static Future<List<Booking>> getBookings() async {
    final data = await _request('/bookings');
    return (data! as List)
        .map((item) => Booking.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<Booking> createBooking({
    required BlueWayBus bus,
    required String passenger,
    required String phone,
    required String date,
    required String seat,
  }) async => Booking.fromJson(
    await _request(
      '/bookings',
      method: 'POST',
      body: {
        'busId': bus.id,
        'passenger': passenger,
        'phone': phone,
        'date': date,
        'seat': seat,
      },
    ) as Map<String, dynamic>,
  );

  static Future<Booking> updateBooking({
    required Booking booking,
    required String passenger,
    required String phone,
    required String date,
    required String seat,
  }) async => Booking.fromJson(
    await _request(
      '/bookings/${Uri.encodeComponent(booking.id)}',
      method: 'PATCH',
      body: {
        'passenger': passenger,
        'phone': phone,
        'date': date,
        'seat': seat,
      },
    ) as Map<String, dynamic>,
  );

  static Future<void> deleteBooking(String id) async {
    await _request('/bookings/${Uri.encodeComponent(id)}', method: 'DELETE');
  }
}

class BlueWayStore extends ChangeNotifier {
  bool loading = true;
  bool ready = false;
  String? loadError;

  Future<void> load() async {
    loading = true;
    loadError = null;
    notifyListeners();
    try {
      final buses = await BlueWayApi.getBuses();
      final loadedBookings = await BlueWayApi.getBookings();
      blueWayBuses
        ..clear()
        ..addAll(buses);
      bookings
        ..clear()
        ..addAll(loadedBookings);
      ready = true;
    } catch (error) {
      loadError = error.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> createBus(BlueWayBus bus) async {
    final saved = await BlueWayApi.createBus(bus);
    blueWayBuses.add(saved);
    notifyListeners();
    await _refreshBookings();
  }

  Future<void> updateBus(BlueWayBus bus) async {
    final saved = await BlueWayApi.updateBus(bus);
    final index = blueWayBuses.indexWhere((item) => item.id == saved.id);
    if (index >= 0) blueWayBuses[index] = saved;
    notifyListeners();
    await _refreshBookings();
  }

  Future<void> deleteBus(String id) async {
    await BlueWayApi.deleteBus(id);
    blueWayBuses.removeWhere((bus) => bus.id == id);
    notifyListeners();
  }

  Future<Booking> createBooking({
    required BlueWayBus bus,
    required String passenger,
    required String phone,
    required String date,
    required String seat,
  }) async {
    final booking = await BlueWayApi.createBooking(
      bus: bus,
      passenger: passenger,
      phone: phone,
      date: date,
      seat: seat,
    );
    bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  Future<void> updateBooking({
    required Booking booking,
    required String passenger,
    required String phone,
    required String date,
    required String seat,
  }) async {
    final updated = await BlueWayApi.updateBooking(
      booking: booking,
      passenger: passenger,
      phone: phone,
      date: date,
      seat: seat,
    );
    final index = bookings.indexWhere((item) => item.id == updated.id);
    if (index >= 0) bookings[index] = updated;
    notifyListeners();
  }

  Future<void> deleteBooking(String id) async {
    await BlueWayApi.deleteBooking(id);
    bookings.removeWhere((booking) => booking.id == id);
    notifyListeners();
  }

  Future<void> _refreshBookings() async {
    final latest = await BlueWayApi.getBookings();
    bookings
      ..clear()
      ..addAll(latest);
    notifyListeners();
  }
}

final BlueWayStore blueWayStore = BlueWayStore();

// ============================================================
