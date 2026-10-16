part of '../main.dart';

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
