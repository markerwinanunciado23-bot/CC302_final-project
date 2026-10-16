part of '../main.dart';

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
