part of '../main.dart';

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
