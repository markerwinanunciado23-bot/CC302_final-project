part of '../main.dart';

class AppRoutes {
  static const String home = '/';

  static final Map<String, WidgetBuilder> routes = {
    home: (_) => const MainNavigation(),
    '/buses': (_) => const BusListPage(),
    '/profile': (_) => const ProfilePage(),
    '/tickets': (_) => const MyTicketsPage(),
    '/schedule': (_) => const SchedulePage(),
    '/fares': (_) => const FarePage(),
    '/booking-history': (_) => const BookingHistoryPage(),
    '/notifications': (_) => const NotificationsPage(),
    '/settings': (_) => const SettingsPage(),
    '/about': (_) => const AboutPage(),
  };
}
