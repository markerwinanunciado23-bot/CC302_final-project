part of '../main.dart';

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
