part of '../main.dart';

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
