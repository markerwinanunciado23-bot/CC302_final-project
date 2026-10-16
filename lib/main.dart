import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'models/blue_way_bus.dart';
part 'models/booking.dart';
part 'services/blue_way_api.dart';
part 'routes/app_routes.dart';
part 'pages/main_screen.dart';
part 'pages/home_page.dart';
part 'pages/fleet_page.dart';
part 'pages/detail_page.dart';
part 'pages/booking_page.dart';
part 'pages/tickets_page.dart';
part 'pages/schedule_page.dart';
part 'pages/profile_page.dart';

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
