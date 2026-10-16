part of '../main.dart';

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
