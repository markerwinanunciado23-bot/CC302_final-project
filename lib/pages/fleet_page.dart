part of '../main.dart';

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
