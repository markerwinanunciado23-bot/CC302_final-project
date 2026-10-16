import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Minimal Charcoal + Dark Mode palette
const Color pageBg = Color(0xFF111418);
const Color cardBg = Color(0xFF1E232B);
const Color charcoal = Color(0xFF168BFF);
const Color primaryText = Color(0xFFF2F4F7);
const Color mutedText = Color(0xFFA8B0BA);
const Color subtleSurface = Color(0xFF263343);
const Color borderColor = Color(0xFF343A40);

void main() {
  runApp(const BlueWayApp());
}

// ============================================================
// BLUE WAY DATA
// ============================================================

class BlueWayBus {
  final String id;
  final String name;
  final String busNumber;
  final String route;
  final String from;
  final String to;
  final String departure;
  final String arrival;
  final String fare;
  final String driver;
  final String busType;
  final String status;
  final String eta;
  final int seats;
  final List<String> stops;
  final List<String> features;
  final IconData icon;

  BlueWayBus({
    required this.id,
    required this.name,
    required this.busNumber,
    required this.route,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.fare,
    required this.driver,
    required this.busType,
    required this.status,
    required this.eta,
    required this.seats,
    required this.stops,
    required this.features,
    required this.icon,
  });

  factory BlueWayBus.fromJson(Map<String, dynamic> json) {
    final busType = json['busType'] as String;
    return BlueWayBus(
      id: json['id'] as String,
      name: json['name'] as String,
      busNumber: json['busNumber'] as String,
      route: json['route'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      departure: json['departure'] as String,
      arrival: json['arrival'] as String,
      fare: json['fare'] as String,
      driver: json['driver'] as String,
      busType: busType,
      status: json['status'] as String,
      eta: json['eta'] as String,
      seats: json['seats'] as int,
      stops: List<String>.from(json['stops'] as List),
      features: List<String>.from(json['features'] as List),
      icon: busType.toLowerCase().contains('shuttle')
          ? Icons.airport_shuttle
          : Icons.directions_bus,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'busNumber': busNumber,
    'from': from,
    'to': to,
    'departure': departure,
    'arrival': arrival,
    'fare': fare,
    'driver': driver,
    'busType': busType,
    'status': status,
    'eta': eta,
    'seats': seats,
    'stops': stops,
    'features': features,
  };
}

// ============================================================
// BLUE WAY FLEET
// ============================================================

final List<BlueWayBus> blueWayBuses = [
  BlueWayBus(
    id: 'bus-101',
    name: 'Blue Way Bohol Express',
    busNumber: 'BW-101',
    route: 'Tagbilaran → Tubigon',
    from: 'Tagbilaran',
    to: 'Tubigon',
    departure: '6:30 AM',
    arrival: '8:00 AM',
    fare: '₱85',
    driver: 'Rogelio Santos',
    busType: 'Air-Conditioned Bus',
    status: 'ON TIME',
    eta: '12 min',
    seats: 18,
    stops: [
      'Tagbilaran Terminal',
      'Cortes',
      'Calape',
      'Clarin',
      'Tubigon Terminal',
    ],
    features: ['Aircon', 'USB Charging', 'Reclining Seats', 'Luggage Space'],
    icon: Icons.directions_bus,
  ),

  BlueWayBus(
    id: 'bus-102',
    name: 'Blue Way Provincial',
    busNumber: 'BW-102',
    route: 'Tagbilaran → Carmen',
    from: 'Tagbilaran',
    to: 'Carmen',
    departure: '7:15 AM',
    arrival: '8:30 AM',
    fare: '₱70',
    driver: 'Jose Dela Cruz',
    busType: 'Provincial Bus',
    status: 'BOARDING',
    eta: '5 min',
    seats: 24,
    stops: ['Tagbilaran Terminal', 'Dao', 'Batuan Junction', 'Carmen Terminal'],
    features: ['Aircon', 'Comfortable Seats', 'Luggage Space'],
    icon: Icons.directions_bus,
  ),

  BlueWayBus(
    id: 'bus-103',
    name: 'Blue Way Island Transport',
    busNumber: 'BW-103',
    route: 'Tagbilaran → Loboc',
    from: 'Tagbilaran',
    to: 'Loboc',
    departure: '8:00 AM',
    arrival: '9:00 AM',
    fare: '₱60',
    driver: 'Pedro Garcia',
    busType: 'Island Transport Bus',
    status: 'ON TIME',
    eta: '20 min',
    seats: 14,
    stops: [
      'Tagbilaran Terminal',
      'Corella',
      'Loboc Junction',
      'Loboc Terminal',
    ],
    features: ['Aircon', 'Comfortable Seats', 'Luggage Space'],
    icon: Icons.directions_bus,
  ),

  BlueWayBus(
    id: 'bus-104',
    name: 'Blue Way Transit',
    busNumber: 'BW-104',
    route: 'Tubigon → Tagbilaran',
    from: 'Tubigon',
    to: 'Tagbilaran',
    departure: '9:00 AM',
    arrival: '10:30 AM',
    fare: '₱85',
    driver: 'Michael Cruz',
    busType: 'Transit Bus',
    status: 'ON TIME',
    eta: '25 min',
    seats: 20,
    stops: [
      'Tubigon Terminal',
      'Clarin',
      'Calape',
      'Cortes',
      'Tagbilaran Terminal',
    ],
    features: ['Aircon', 'USB Charging', 'Reclining Seats'],
    icon: Icons.directions_bus,
  ),

  BlueWayBus(
    id: 'bus-105',
    name: 'Blue Way Express',
    busNumber: 'BW-105',
    route: 'Tagbilaran → Jagna',
    from: 'Tagbilaran',
    to: 'Jagna',
    departure: '10:00 AM',
    arrival: '12:00 PM',
    fare: '₱100',
    driver: 'Carlos Mendoza',
    busType: 'Express Bus',
    status: 'ON TIME',
    eta: '35 min',
    seats: 16,
    stops: [
      'Tagbilaran Terminal',
      'Baclayon',
      'Alburquerque',
      'Dimiao',
      'Jagna Terminal',
    ],
    features: ['Aircon', 'USB Charging', 'Reclining Seats', 'Wi-Fi'],
    icon: Icons.directions_bus,
  ),

  BlueWayBus(
    id: 'bus-106',
    name: 'Blue Way Shuttle',
    busNumber: 'BW-106',
    route: 'Tagbilaran → Panglao',
    from: 'Tagbilaran',
    to: 'Panglao',
    departure: '11:00 AM',
    arrival: '11:45 AM',
    fare: '₱50',
    driver: 'Ramon Reyes',
    busType: 'Shuttle Bus',
    status: 'BOARDING',
    eta: '8 min',
    seats: 22,
    stops: ['Tagbilaran Terminal', 'Bool', 'Dauis', 'Panglao'],
    features: ['Aircon', 'Comfortable Seats', 'Fast Boarding'],
    icon: Icons.airport_shuttle,
  ),

  BlueWayBus(
    id: 'bus-107',
    name: 'Blue Way Bus Service',
    busNumber: 'BW-107',
    route: 'Tagbilaran → Ubay',
    from: 'Tagbilaran',
    to: 'Ubay',
    departure: '1:00 PM',
    arrival: '3:30 PM',
    fare: '₱120',
    driver: 'Fernando Lim',
    busType: 'Provincial Bus Service',
    status: 'DELAYED',
    eta: '45 min',
    seats: 19,
    stops: [
      'Tagbilaran Terminal',
      'Carmen',
      'Trinidad',
      'Talibon',
      'Ubay Terminal',
    ],
    features: ['Aircon', 'USB Charging', 'Luggage Space', 'Reclining Seats'],
    icon: Icons.directions_bus,
  ),
];

// ============================================================
// BOOKING MODEL
// ============================================================

class Booking {
  final String id;
  final String reference;
  final BlueWayBus bus;
  final String passenger;
  final String phone;
  final String date;
  final String seat;

  Booking({
    required this.id,
    required this.reference,
    required this.bus,
    required this.passenger,
    required this.phone,
    required this.date,
    required this.seat,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    reference: json['reference'] as String,
    bus: BlueWayBus.fromJson(json['bus'] as Map<String, dynamic>),
    passenger: json['passenger'] as String,
    phone: json['phone'] as String,
    date: json['date'] as String,
    seat: json['seat'] as String,
  );
}

final List<Booking> bookings = [];

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
// APP
// ============================================================

class BlueWayApp extends StatelessWidget {
  const BlueWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blue Way Transit',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Arial',
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: charcoal,
              brightness: Brightness.dark,
              surface: cardBg,
            ).copyWith(
              primary: primaryText,
              onPrimary: pageBg,
              secondary: mutedText,
              onSurface: primaryText,
              surface: cardBg,
              outline: borderColor,
            ),
        scaffoldBackgroundColor: pageBg,
        canvasColor: pageBg,
        dividerColor: borderColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: pageBg,
          foregroundColor: primaryText,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: borderColor),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          backgroundColor: cardBg,
          indicatorColor: subtleSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? primaryText
                  : mutedText,
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? primaryText
                  : mutedText,
              size: 22,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardBg,
          hintStyle: const TextStyle(color: mutedText),
          labelStyle: const TextStyle(color: mutedText),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryText, width: 1.5),
          ),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    blueWayStore.addListener(_storeChanged);
    if (!blueWayStore.ready) blueWayStore.load();
  }

  @override
  void dispose() {
    blueWayStore.removeListener(_storeChanged);
    super.dispose();
  }

  void _storeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!blueWayStore.ready) {
      return Scaffold(
        body: blueWayStore.loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 52,
                        color: mutedText,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Blue Way API unavailable',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        blueWayStore.loadError ??
                            'Start the API server and try again.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: mutedText),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: blueWayStore.load,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry connection'),
                      ),
                    ],
                  ),
                ),
              ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [HomePage(), BusListPage(), ProfilePage()],
      ),
      bottomNavigationBar: NavigationBar(
        // Shared navigation bar for Home, Buses, and Profile.
        // Styling is centralized in navigationBarTheme above.
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus_outlined),
            selectedIcon: Icon(Icons.directions_bus),
            label: 'Buses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color blue = Color(0xFF168BFF);
  static const Color blueDeep = Color(0xFF082D53);

  @override
  Widget build(BuildContext context) {
    final nextBus = blueWayBuses.isEmpty ? null : blueWayBuses.first;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        children: [
          // Brand header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF39A5FF), Color(0xFF0865C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: blue.withOpacity(.22),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BLUE WAY',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'BUS INFORMATION SYSTEM',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  tooltip: 'Notifications',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  ),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Main promotional poster
          _travelPoster(
            height: 225,
            imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=85',
            eyebrow: 'TRAVEL WITH BLUE WAY',
            headline: 'EXPLORE\nBOHOL',
            accentLine: 'WITH BLUE WAY',
            footer: 'Safe  •  Comfortable  •  Reliable',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BusListPage()),
            ),
          ),
          const SizedBox(height: 20),

          // Search destination
          TextField(
            readOnly: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BusListPage()),
            ),
            decoration: InputDecoration(
              hintText: 'Where do you want to go?',
              hintStyle: const TextStyle(color: mutedText),
              prefixIcon: const Icon(Icons.search_rounded, color: blue),
              suffixIcon: const Icon(Icons.arrow_forward_rounded, size: 19),
              filled: true,
              fillColor: cardBg,
              contentPadding: const EdgeInsets.symmetric(vertical: 17),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: blue),
              ),
            ),
          ),
          const SizedBox(height: 22),

          const Text(
            'QUICK ACCESS',
            style: TextStyle(
              color: mutedText,
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _quickAction(
                  context,
                  Icons.calendar_month_rounded,
                  'Schedules',
                  'Check departure times',
                  const SchedulePage(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _quickAction(
                  context,
                  Icons.payments_rounded,
                  'Fares',
                  'View ticket prices',
                  const FarePage(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _quickAction(
                  context,
                  Icons.confirmation_num_rounded,
                  'Tickets',
                  'Your bookings',
                  const MyTicketsPage(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Next Bus',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BusListPage()),
                ),
                icon: const Text('View all'),
                label: const Icon(Icons.arrow_forward_rounded, size: 17),
              ),
            ],
          ),
          if (nextBus == null)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text('No buses are available right now.'),
            )
          else
            _featuredBusCard(context, nextBus),
          const SizedBox(height: 20),

          // Second promotional poster
          _travelPoster(
            height: 170,
            imageUrl: 'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?auto=format&fit=crop&w=1400&q=85',
            eyebrow: 'YOUR NEXT',
            headline: 'ADVENTURE',
            accentLine: 'STARTS HERE',
            footer: 'Discover more destinations with Blue Way',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BusListPage()),
            ),
          ),
          const SizedBox(height: 26),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Our Services',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              Text(
                '${blueWayBuses.length} routes',
                style: const TextStyle(color: mutedText, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...blueWayBuses.take(4).map((bus) => _serviceRow(context, bus)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _travelPoster({
    required double height,
    required String imageUrl,
    required String eyebrow,
    required String headline,
    required String accentLine,
    required String footer,
    required VoidCallback onTap,
  }) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF07549B), Color(0xFF101923)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.landscape_rounded,
                    size: 100,
                    color: Color(0x4439A5FF),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xE6081727),
                      const Color(0x99101B2A),
                      Colors.transparent,
                    ],
                    stops: const [0, .58, 1],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      eyebrow,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      headline,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: height < 190 ? 30 : 39,
                        height: .98,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.5,
                      ),
                    ),
                    Text(
                      accentLine,
                      style: TextStyle(
                        color: const Color(0xFF69B9FF),
                        fontSize: height < 190 ? 21 : 26,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Flexible(
                      child: Text(
                        footer,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget page,
  ) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: blue.withOpacity(.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF69B9FF), size: 23),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: mutedText,
                  fontSize: 9,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featuredBusCard(BuildContext context, BlueWayBus bus) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF23405C)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.18),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
            child: SizedBox(
              height: 145,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=1200&q=85',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: blueDeep,
                      child: const Icon(
                        Icons.directions_bus_rounded,
                        color: Colors.white54,
                        size: 95,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xDD061426), Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            bus.name.toUpperCase(),
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .4,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF075D42),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 7,
                                color: Color(0xFF8AF0C2),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                bus.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      color: Color(0xFF69B9FF),
                      size: 22,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        '${bus.from}  →  ${bus.to}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      bus.fare,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF69B9FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _busMetric(
                      Icons.schedule_rounded,
                      bus.departure,
                      'Departure',
                    ),
                    _busMetric(
                      Icons.event_seat_rounded,
                      '${bus.seats}',
                      'Seats left',
                    ),
                    _busMetric(Icons.timer_outlined, bus.eta, 'Est. travel'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookingPage(bus: bus)),
                    ),
                    icon: const Icon(Icons.confirmation_num_outlined),
                    label: const Text(
                      'BOOK NOW',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _busMetric(IconData icon, String value, String label) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF69B9FF), size: 20),
          const SizedBox(width: 7),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: const TextStyle(color: mutedText, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceRow(BuildContext context, BlueWayBus bus) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: cardBg,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 5,
          ),
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: blue.withOpacity(.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: Color(0xFF69B9FF),
            ),
          ),
          title: Text(
            bus.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${bus.from}  →  ${bus.to}  •  ${bus.fare}',
              style: const TextStyle(color: mutedText, fontSize: 12),
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: mutedText),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BusDetailsPage(bus: bus)),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REALISTIC BUS POSTER HEADER
// ============================================================

Widget _busPosterHeader(BlueWayBus bus) {
  return Container(
    height: 184,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _posterColors(bus.name),
      ),
    ),
    child: Stack(
      children: [
        // Real bus photo background so the fleet cards read as posters, not just icons.
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=1400&q=85',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _posterColors(bus.name),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xD9081727),
                  const Color(0xA6081727),
                  Colors.black.withOpacity(.18),
                ],
                stops: const [0.0, 0.58, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          right: -12,
          bottom: -38,
          child: Icon(
            bus.icon,
            size: 205,
            color: Colors.white.withOpacity(.13),
          ),
        ),
        Positioned(
          left: 18,
          top: 16,
          right: 18,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BLUE WAY TRANSIT',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      bus.name.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(bus.status),
            ],
          ),
        ),
        Positioned(
          left: 18,
          bottom: 16,
          right: 18,
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(.24)),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                  size: 37,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.busNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      bus.busType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'SAFE  •  COMFORTABLE  •  RELIABLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

List<Color> _posterColors(String name) {
  if (name.contains('Bohol Express')) {
    return const [Color(0xFF68727E), Color(0xFF303640)];
  }

  if (name.contains('Provincial')) {
    return const [Color(0xFF555E68), Color(0xFF252B33)];
  }

  if (name.contains('Island')) {
    return const [Color(0xFF7D8793), charcoal];
  }

  if (name.contains('Transit')) {
    return const [charcoal, Color(0xFF343A40)];
  }

  if (name.contains('Express')) {
    return const [Color(0xFF68727E), Color(0xFF252B33)];
  }

  if (name.contains('Shuttle')) {
    return const [Color(0xFF7D8793), charcoal];
  }

  return const [Color(0xFF555E68), Color(0xFF252B33)];
}

// ============================================================
// BUS LIST PAGE
// ============================================================

class BusListPage extends StatefulWidget {
  const BusListPage({super.key});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  final searchController = TextEditingController();

  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final search = searchController.text.toLowerCase();

    final filtered = blueWayBuses.where((bus) {
      final matchesSearch =
          bus.name.toLowerCase().contains(search) ||
          bus.route.toLowerCase().contains(search) ||
          bus.busNumber.toLowerCase().contains(search) ||
          bus.from.toLowerCase().contains(search) ||
          bus.to.toLowerCase().contains(search);

      bool matchesFilter = true;

      if (filter == 'Morning') {
        matchesFilter = bus.departure.contains('AM');
      }

      if (filter == 'Afternoon') {
        matchesFilter = bus.departure.contains('PM');
      }

      if (filter == 'On Time') {
        matchesFilter = bus.status == 'ON TIME';
      }

      return matchesSearch && matchesFilter;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Blue Way Fleet',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Add bus',
                  onPressed: () => _editBus(),
                  icon: const Icon(Icons.add_circle_outline),
                ),
                IconButton(
                  onPressed: () {
                    _showFilters();
                  },
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
          ),

          // Fleet promotional poster: matches the Blue Way home-page style.
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
            child: _fleetHeroPoster(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search bus, route or destination...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                _chip('All'),
                _chip('Morning'),
                _chip('Afternoon'),
                _chip('On Time'),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final bus = filtered[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      _busPosterHeader(bus),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    bus.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  bus.fare,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: charcoal,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  tooltip: 'Manage bus',
                                  onSelected: (action) {
                                    if (action == 'edit') _editBus(bus);
                                    if (action == 'delete') _deleteBus(bus);
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: ListTile(
                                        leading: Icon(Icons.edit_outlined),
                                        title: Text('Edit bus'),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete_outline),
                                        title: Text('Delete bus'),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                bus.route,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                _listInfo(Icons.schedule, bus.departure),
                                _listInfo(
                                  Icons.event_seat,
                                  '${bus.seats} seats',
                                ),
                                _listInfo(Icons.timer, bus.eta),
                              ],
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BusDetailsPage(bus: bus),
                                    ),
                                  );
                                },
                                child: const Text('VIEW BUS DETAILS'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _editBus([BlueWayBus? bus]) async {
    final edited = await showDialog<BlueWayBus>(
      context: context,
      builder: (_) => BusFormDialog(bus: bus),
    );
    if (edited == null) return;
    try {
      if (bus == null) {
        await blueWayStore.createBus(edited);
      } else {
        await blueWayStore.updateBus(edited);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(bus == null ? 'Bus added.' : 'Bus updated.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

  Future<void> _deleteBus(BlueWayBus bus) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete bus?'),
        content: Text('Delete ${bus.busNumber} from the fleet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await blueWayStore.deleteBus(bus.id);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

  Widget _fleetHeroPoster() {
    return Material(
      color: const Color(0xFF102A43),
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: 142,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF168BFF), Color(0xFF12365A), Color(0xFF1E232B)],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=1400&q=85',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.expand(),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xE6081727),
                        Color(0xA6081727),
                        Color(0x66101723),
                      ],
                      stops: [0.0, 0.62, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -18,
                bottom: -38,
                child: Icon(
                  Icons.directions_bus_rounded,
                  size: 185,
                  color: Colors.white.withOpacity(.13),
                ),
              ),
              Positioned(
                right: 22,
                top: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.16),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    'BLUE WAY FLEET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 20,
                right: 115,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'YOUR JOURNEY,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'OUR PRIORITY.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Safe  •  Comfortable  •  Reliable',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 18,
                bottom: 13,
                child: Row(
                  children: const [
                    Icon(Icons.route_rounded, size: 15, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Find your next ride',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(value),
        selected: filter == value,
        onSelected: (_) {
          setState(() {
            filter = value;
          });
        },
      ),
    );
  }

  Widget _listInfo(IconData icon, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: charcoal),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Bus Schedules',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ...['All', 'Morning', 'Afternoon', 'On Time'].map(
                (option) => ListTile(
                  leading: Icon(
                    filter == option
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: charcoal,
                  ),
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      filter = option;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BusFormDialog extends StatefulWidget {
  final BlueWayBus? bus;

  const BusFormDialog({super.key, this.bus});

  @override
  State<BusFormDialog> createState() => _BusFormDialogState();
}

class _BusFormDialogState extends State<BusFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields;
  late String _status;

  @override
  void initState() {
    super.initState();
    final bus = widget.bus;
    _fields = {
      'name': TextEditingController(text: bus?.name ?? ''),
      'busNumber': TextEditingController(text: bus?.busNumber ?? ''),
      'from': TextEditingController(text: bus?.from ?? ''),
      'to': TextEditingController(text: bus?.to ?? ''),
      'departure': TextEditingController(text: bus?.departure ?? ''),
      'arrival': TextEditingController(text: bus?.arrival ?? ''),
      'fare': TextEditingController(text: bus?.fare ?? ''),
      'driver': TextEditingController(text: bus?.driver ?? ''),
      'busType': TextEditingController(text: bus?.busType ?? ''),
      'eta': TextEditingController(text: bus?.eta ?? ''),
      'seats': TextEditingController(text: bus?.seats.toString() ?? ''),
      'stops': TextEditingController(text: bus?.stops.join(', ') ?? ''),
      'features': TextEditingController(text: bus?.features.join(', ') ?? ''),
    };
    _status = bus?.status ?? 'ON TIME';
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.bus == null ? 'Add bus' : 'Edit bus'),
      content: SizedBox(
        width: 420,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.65,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                _textField('name', 'Bus name'),
                _textField('busNumber', 'Bus number'),
                _textField('from', 'From'),
                _textField('to', 'To'),
                _textField('departure', 'Departure time'),
                _textField('arrival', 'Arrival time'),
                _textField('fare', 'Fare'),
                _textField('driver', 'Driver'),
                _textField('busType', 'Bus type'),
                _textField('eta', 'ETA'),
                _textField(
                  'seats',
                  'Number of seats',
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const ['ON TIME', 'BOARDING', 'DELAYED']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _status = value);
                  },
                ),
                _textField('stops', 'Stops (comma-separated)', required: false),
                _textField(
                  'features',
                  'Features (comma-separated)',
                  required: false,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(widget.bus == null ? 'ADD BUS' : 'SAVE CHANGES'),
        ),
      ],
    );
  }

  Widget _textField(
    String key,
    String label, {
    TextInputType? keyboardType,
    bool required = true,
  }) {
    return TextFormField(
      controller: _fields[key],
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$label is required.';
        }
        if (key == 'seats' &&
            (int.tryParse(value ?? '') == null || int.parse(value!) < 1)) {
          return 'Enter a positive whole number.';
        }
        return null;
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    String value(String key) => _fields[key]!.text.trim();
    List<String> list(String key) =>
        value(key)
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();

    final from = value('from');
    final to = value('to');
    final busType = value('busType');
    Navigator.pop(
      context,
      BlueWayBus(
        id: widget.bus?.id ?? '',
        name: value('name'),
        busNumber: value('busNumber'),
        route: '$from → $to',
        from: from,
        to: to,
        departure: value('departure'),
        arrival: value('arrival'),
        fare: value('fare'),
        driver: value('driver'),
        busType: busType,
        status: _status,
        eta: value('eta'),
        seats: int.parse(value('seats')),
        stops: list('stops'),
        features: list('features'),
        icon: busType.toLowerCase().contains('shuttle')
            ? Icons.airport_shuttle
            : Icons.directions_bus,
      ),
    );
  }
}

// ============================================================
// BUS DETAILS
// ============================================================

class BusDetailsPage extends StatelessWidget {
  final BlueWayBus bus;

  const BusDetailsPage({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bus.busNumber)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          _busPosterHeader(bus),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bus.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: charcoal,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  bus.route,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 20),

                _infoContainer(
                  children: [
                    _detailRow(
                      Icons.schedule,
                      'Schedule',
                      '${bus.departure} - ${bus.arrival}',
                    ),
                    _detailRow(Icons.timer, 'Travel Time', _travelTime(bus)),
                    _detailRow(Icons.person, 'Driver', bus.driver),
                    _detailRow(Icons.directions_bus, 'Bus Type', bus.busType),
                    _detailRow(
                      Icons.event_seat,
                      'Available Seats',
                      '${bus.seats}',
                    ),
                    _detailRow(Icons.payments, 'Fare', bus.fare),
                    _detailRow(Icons.my_location, 'ETA', bus.eta),
                  ],
                ),

                const SizedBox(height: 22),

                const Text(
                  'Bus Features',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bus.features
                      .map(
                        (feature) => Chip(
                          avatar: const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: charcoal,
                          ),
                          label: Text(feature),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Route Stops',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ...bus.stops.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stop = entry.value;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: charcoal,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: cardBg,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          if (index < bus.stops.length - 1)
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(stop),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF263A31),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.gps_fixed, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bus.status,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Estimated arrival: ${bus.eta}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingPage(bus: bus),
                        ),
                      );
                    },
                    icon: const Icon(Icons.confirmation_num),
                    label: const Text(
                      'BOOK THIS BUS',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: charcoal, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _travelTime(BlueWayBus bus) {
    return '${bus.from} to ${bus.to}';
  }
}

// ============================================================
// BOOKING
// ============================================================

class BookingPage extends StatefulWidget {
  final BlueWayBus bus;

  const BookingPage({super.key, required this.bus});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedSeat;

  DateTime selectedDate = DateTime.now();

  final Set<int> occupiedSeats = {2, 5, 8, 11, 15};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Ride')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: subtleSurface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bus.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: charcoal,
                  ),
                ),
                const SizedBox(height: 5),
                Text(widget.bus.busNumber),
                Text(widget.bus.route),
                const SizedBox(height: 5),
                Text('${widget.bus.departure} • ${widget.bus.fare}'),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Travel Date',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                initialDate: selectedDate,
              );

              if (date != null) {
                setState(() {
                  selectedDate = date;
                });
              }
            },
            icon: const Icon(Icons.calendar_month),
            label: Text(
              '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Select Seat',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.bus.seats,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final number = index + 1;
                final occupied = occupiedSeats.contains(number);
                final selected = selectedSeat == 'Seat $number';

                return InkWell(
                  onTap: occupied
                      ? null
                      : () {
                          setState(() {
                            selectedSeat = 'Seat $number';
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: occupied
                          ? Colors.grey.shade300
                          : selected
                          ? charcoal
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      Icons.event_seat,
                      color: occupied
                          ? Colors.grey
                          : selected
                          ? Colors.white
                          : charcoal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Passenger Information',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
              filled: true,
              fillColor: cardBg,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              prefixIcon: Icon(Icons.phone_outlined),
              filled: true,
              fillColor: cardBg,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                _summary('Service', widget.bus.name),
                _summary('Bus', widget.bus.busNumber),
                _summary('Route', widget.bus.route),
                _summary('Seat', selectedSeat ?? 'Not selected'),
                _summary('Fare', widget.bus.fare, bold: true),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 55,
            child: FilledButton(
              onPressed: _confirmBooking,
              child: const Text(
                'CONFIRM BOOKING',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                color: bold ? charcoal : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmBooking() async {
    if (nameController.text.trim().isEmpty) {
      _error('Please enter your full name.');
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      _error('Please enter your mobile number.');
      return;
    }

    if (selectedSeat == null) {
      _error('Please select a seat.');
      return;
    }

    try {
      final booking = await blueWayStore.createBooking(
        bus: widget.bus,
        passenger: nameController.text.trim(),
        phone: phoneController.text.trim(),
        date: '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
        seat: selectedSeat!,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TicketPage(booking: booking)),
      );
    } catch (error) {
      _error(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _error(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

// ============================================================
// TICKET
// ============================================================

class TicketPage extends StatelessWidget {
  final Booking booking;

  const TicketPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Digital Ticket',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Ticket information',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Your digital ticket'),
                content: const Text(
                  'Keep this ticket ready and present it to Blue Way staff before boarding.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('GOT IT'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF168BFF),
                  Color(0xFF07549B),
                  Color(0xFF12365A),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -12,
                  bottom: -28,
                  child: Icon(
                    Icons.directions_bus_rounded,
                    size: 140,
                    color: Colors.white.withOpacity(.10),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.16),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.directions_bus_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 11),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BLUE WAY TRANSIT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.1,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'OFFICIAL DIGITAL TICKET',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9,
                                  letterSpacing: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'BOOKING CONFIRMED',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Your ride is ready.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(height: 1, color: Colors.white24),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          color: Colors.white70,
                          size: 17,
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'BOOKING REFERENCE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Text(
                            booking.reference,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _ticketRoutePoint('FROM', booking.bus.from),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xFF168BFF),
                                  size: 21,
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'DIRECT',
                                  style: TextStyle(
                                    color: mutedText,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: _ticketRoutePoint(
                              'TO',
                              booking.bus.to,
                              alignEnd: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: subtleSurface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _ticketInfo(
                                'BUS NO.',
                                booking.bus.busNumber,
                              ),
                            ),
                            _ticketVerticalDivider(),
                            Expanded(child: _ticketInfo('SEAT', booking.seat)),
                            _ticketVerticalDivider(),
                            Expanded(
                              child: _ticketInfo('FARE', booking.bus.fare),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _ticketDetailRow(
                        Icons.person_outline_rounded,
                        'Passenger',
                        booking.passenger,
                      ),
                      _ticketDetailRow(
                        Icons.phone_outlined,
                        'Mobile',
                        booking.phone,
                      ),
                      _ticketDetailRow(
                        Icons.calendar_month_outlined,
                        'Travel date',
                        booking.date,
                      ),
                      _ticketDetailRow(
                        Icons.schedule_rounded,
                        'Departure',
                        booking.bus.departure,
                      ),
                      _ticketDetailRow(
                        Icons.directions_bus_outlined,
                        'Bus service',
                        booking.bus.name,
                      ),
                      _ticketDetailRow(
                        Icons.badge_outlined,
                        'Driver',
                        booking.bus.driver,
                      ),
                    ],
                  ),
                ),
                // Ticket-style perforated divider.
                SizedBox(
                  height: 18,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Divider(
                        color: borderColor,
                        height: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: pageBg,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: pageBg,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
                  child: Column(
                    children: [
                      const Text(
                        'BOARDING PASS',
                        style: TextStyle(
                          color: mutedText,
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 172,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.qr_code_2_rounded,
                              size: 112,
                              color: Color(0xFF111418),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.reference,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF111418),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 15,
                            color: Color(0xFF168BFF),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Keep this ticket ready when boarding',
                            style: TextStyle(color: mutedText, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              icon: const Icon(Icons.home_rounded),
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              label: const Text(
                'BACK TO HOME',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: .6,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF168BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketRoutePoint(
    String label,
    String value, {
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: mutedText,
            fontSize: 9,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: primaryText,
            fontSize: 17,
            height: 1.15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _ticketInfo(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: mutedText,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _ticketVerticalDivider() =>
      Container(height: 29, width: 1, color: borderColor);

  Widget _ticketDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: subtleSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: const Color(0xFF168BFF)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: mutedText, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MY TICKETS
// ============================================================

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: bookings.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_num_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No tickets yet.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your bookings will appear here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: subtleSurface,
                      child: Icon(Icons.directions_bus, color: charcoal),
                    ),
                    title: Text(
                      booking.bus.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${booking.bus.route}\n'
                      '${booking.date} • ${booking.seat}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Manage ticket',
                      onSelected: (action) {
                        if (action == 'edit') {
                          _editBooking(context, booking);
                        }
                        if (action == 'delete') {
                          _deleteBooking(context, booking);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Edit booking'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Delete booking'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketPage(booking: booking),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _editBooking(BuildContext context, Booking booking) async {
  final updated = await showDialog<Booking>(
    context: context,
    builder: (_) => BookingFormDialog(booking: booking),
  );
  if (updated == null) return;
  try {
    await blueWayStore.updateBooking(
      booking: booking,
      passenger: updated.passenger,
      phone: updated.phone,
      date: updated.date,
      seat: updated.seat,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Booking updated.')));
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }
}

Future<void> _deleteBooking(BuildContext context, Booking booking) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete booking?'),
      content: Text('Delete ticket ${booking.reference}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('DELETE'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await blueWayStore.deleteBooking(booking.id);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }
}

class BookingFormDialog extends StatefulWidget {
  final Booking booking;

  const BookingFormDialog({super.key, required this.booking});

  @override
  State<BookingFormDialog> createState() => _BookingFormDialogState();
}

class _BookingFormDialogState extends State<BookingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passenger;
  late final TextEditingController _phone;
  late final TextEditingController _date;
  late final TextEditingController _seat;

  @override
  void initState() {
    super.initState();
    _passenger = TextEditingController(text: widget.booking.passenger);
    _phone = TextEditingController(text: widget.booking.phone);
    _date = TextEditingController(text: widget.booking.date);
    _seat = TextEditingController(text: widget.booking.seat);
  }

  @override
  void dispose() {
    _passenger.dispose();
    _phone.dispose();
    _date.dispose();
    _seat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit booking'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _passenger,
                decoration: const InputDecoration(labelText: 'Passenger name'),
                validator: _required,
              ),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: _required,
              ),
              TextFormField(
                controller: _date,
                decoration: const InputDecoration(labelText: 'Travel date'),
                validator: _required,
              ),
              TextFormField(
                controller: _seat,
                decoration: const InputDecoration(labelText: 'Seat'),
                validator: _required,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              Booking(
                id: widget.booking.id,
                reference: widget.booking.reference,
                bus: widget.booking.bus,
                passenger: _passenger.text.trim(),
                phone: _phone.text.trim(),
                date: _date.text.trim(),
                seat: _seat.text.trim(),
              ),
            );
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;
}

// ============================================================
// SCHEDULE PAGE
// ============================================================

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus Schedules')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: blueWayBuses.length,
        itemBuilder: (context, index) {
          final bus = blueWayBuses[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: subtleSurface,
                  child: Icon(bus.icon, color: charcoal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        bus.route,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${bus.departure} - ${bus.arrival}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  bus.fare,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: charcoal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// FARE PAGE
// ============================================================

class FarePage extends StatelessWidget {
  const FarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fare Information')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Blue Way Fare Guide',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          const Text(
            'Sample fares for the Blue Way Transit system.',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          ...blueWayBuses.map(
            (bus) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.route, color: charcoal),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bus.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          bus.route,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    bus.fare,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: charcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Note: Fares are sample values for this school project.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE PAGE
// ============================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          const Text(
            'My Profile',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your Blue Way passenger account',
            style: TextStyle(color: mutedText, fontSize: 13),
          ),
          const SizedBox(height: 18),

          // Passenger profile banner with a premium Blue Way look.
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF168BFF),
                  Color(0xFF0866B5),
                  Color(0xFF17334F),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF168BFF).withOpacity(0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // New photo-backed passenger banner, matching the bus posters.
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=1200&q=85',
                      fit: BoxFit.cover,
                      alignment: Alignment.centerRight,
                      errorBuilder: (_, __, ___) => const SizedBox.expand(),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xF0081727),
                          Color(0xD0081727),
                          Color(0x8A07549B),
                        ],
                        stops: [0.0, 0.62, 1.0],
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  right: -8,
                  bottom: -16,
                  child: Icon(
                    Icons.directions_bus_rounded,
                    size: 108,
                    color: Color(0x33202A35),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFEAF4FF),
                        child: Icon(
                          Icons.person_rounded,
                          size: 38,
                          color: Color(0xFF168BFF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BLUE WAY PASSENGER',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Blue Way Passenger',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'passenger@blueway.ph',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: _ProfileQuickCard(
                  icon: Icons.confirmation_num_rounded,
                  title: 'My Tickets',
                  subtitle: 'Your passes',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ProfileQuickCard(
                  icon: Icons.route_rounded,
                  title: 'Routes',
                  subtitle: 'Explore trips',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ProfileQuickCard(
                  icon: Icons.support_agent_rounded,
                  title: 'Support',
                  subtitle: 'We can help',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // New profile-page travel poster linking passengers back to the fleet.
          Material(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BusListPage()),
              ),
              child: SizedBox(
                height: 132,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=1200&q=85',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF168BFF), Color(0xFF10263D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xED081727),
                            Color(0xB3081727),
                            Color(0x33081727),
                          ],
                          stops: [0.0, 0.68, 1.0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'YOUR NEXT JOURNEY',
                                  style: TextStyle(
                                    color: Color(0xFF80C7FF),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Travel with Blue Way',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Explore buses, routes and fares',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.16),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'ACCOUNT & TRAVEL',
            style: TextStyle(
              color: mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          _profileItem(
            context,
            Icons.confirmation_num_outlined,
            'My Tickets',
            'View your digital tickets',
            const MyTicketsPage(),
          ),
          _profileItem(
            context,
            Icons.history_rounded,
            'Booking History',
            'Review your past bookings',
            const BookingHistoryPage(),
          ),
          _profileItem(
            context,
            Icons.notifications_none_rounded,
            'Notifications',
            'Travel updates and alerts',
            const NotificationsPage(),
          ),
          _profileItem(
            context,
            Icons.schedule_rounded,
            'Bus Schedules',
            'Check departure times',
            const SchedulePage(),
          ),
          _profileItem(
            context,
            Icons.payments_outlined,
            'Fare Information',
            'Know your travel fares',
            const FarePage(),
          ),

          const SizedBox(height: 14),
          const Text(
            'PREFERENCES',
            style: TextStyle(
              color: mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          _profileItem(
            context,
            Icons.settings_outlined,
            'Settings',
            'Personalize your experience',
            const SettingsPage(),
          ),
          _profileItem(
            context,
            Icons.info_outline_rounded,
            'About Blue Way',
            'Learn more about our service',
            const AboutPage(),
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: charcoal, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel with confidence',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Safe • Comfortable • Reliable',
                        style: TextStyle(color: mutedText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget page,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor.withOpacity(0.75)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 4,
          ),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: charcoal.withOpacity(0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: charcoal, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: mutedText, fontSize: 11),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: mutedText),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
        ),
      ),
    );
  }
}

class _ProfileQuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileQuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: charcoal, size: 23),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: mutedText, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BOOKING HISTORY
// ============================================================

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking History')),
      body: bookings.isEmpty
          ? const Center(child: Text('No booking history yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.bus.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking.bus.route,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '${booking.date} • ${booking.seat}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        booking.bus.fare,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// NOTIFICATIONS
// ============================================================

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          _Notification(
            icon: Icons.directions_bus,
            title: 'Bus Update',
            message: 'BW-101 Blue Way Bohol Express is currently on time.',
          ),
          _Notification(
            icon: Icons.access_time,
            title: 'Travel Reminder',
            message: 'Please arrive 15 minutes before departure.',
          ),
          _Notification(
            icon: Icons.campaign,
            title: 'Blue Way Service',
            message: 'Check the latest bus schedules before travelling.',
          ),
        ],
      ),
    );
  }
}

class _Notification extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _Notification({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: subtleSurface,
            child: Icon(icon, color: charcoal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SETTINGS
// ============================================================

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool reminders = true;
  bool location = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SwitchListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Notifications'),
            subtitle: const Text('Receive Blue Way updates.'),
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          const SizedBox(height: 10),

          SwitchListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Travel Reminders'),
            subtitle: const Text('Receive reminders before departure.'),
            value: reminders,
            onChanged: (value) {
              setState(() {
                reminders = value;
              });
            },
          ),

          const SizedBox(height: 10),

          SwitchListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Location Services'),
            subtitle: const Text('Used for bus tracking features.'),
            value: location,
            onChanged: (value) {
              setState(() {
                location = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ABOUT
// ============================================================

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Blue Way')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: charcoal,
            child: Icon(Icons.directions_bus, size: 55, color: cardBg),
          ),

          const SizedBox(height: 18),

          const Text(
            'BLUE WAY TRANSIT',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: charcoal,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Bus Information System',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 25),

          const Text(
            'Blue Way Transit is a local bus information and booking system designed to make travelling easier, safer and more convenient.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.5),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: subtleSurface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Text(
                  'OUR SERVICES',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: charcoal,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Bohol Express • Provincial • Island Transport\n'
                  'Transit • Express • Shuttle • Bus Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STATUS BADGE
// ============================================================

Widget _statusBadge(String status) {
  Color background;
  Color foreground;

  if (status == 'BOARDING') {
    background = const Color(0xFF3B3020);
    foreground = const Color(0xFFFFC66D);
  } else if (status == 'DELAYED') {
    background = const Color(0xFF40272B);
    foreground = const Color(0xFFFF929C);
  } else {
    background = const Color(0xFF263A31);
    foreground = const Color(0xFF8BE0B0);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: foreground,
        fontSize: 9,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
