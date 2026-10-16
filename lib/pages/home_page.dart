part of '../main.dart';

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
