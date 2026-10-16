part of '../main.dart';

// MY TICKETS
// ============================================================

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: bookings.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_num_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No tickets yet.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your bookings will appear here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: subtleSurface,
                      child: Icon(Icons.directions_bus, color: charcoal),
                    ),
                    title: Text(
                      booking.bus.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${booking.bus.route}\n'
                      '${booking.date} • ${booking.seat}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Manage ticket',
                      onSelected: (action) {
                        if (action == 'edit') {
                          _editBooking(context, booking);
                        }
                        if (action == 'delete') {
                          _deleteBooking(context, booking);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Edit booking'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Delete booking'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketPage(booking: booking),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _editBooking(BuildContext context, Booking booking) async {
  final updated = await showDialog<Booking>(
    context: context,
    builder: (_) => BookingFormDialog(booking: booking),
  );
  if (updated == null) return;
  try {
    await blueWayStore.updateBooking(
      booking: booking,
      passenger: updated.passenger,
      phone: updated.phone,
      date: updated.date,
      seat: updated.seat,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Booking updated.')));
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }
}

Future<void> _deleteBooking(BuildContext context, Booking booking) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete booking?'),
      content: Text('Delete ticket ${booking.reference}?'),
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
    await blueWayStore.deleteBooking(booking.id);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }
}

class BookingFormDialog extends StatefulWidget {
  final Booking booking;

  const BookingFormDialog({super.key, required this.booking});

  @override
  State<BookingFormDialog> createState() => _BookingFormDialogState();
}

class _BookingFormDialogState extends State<BookingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passenger;
  late final TextEditingController _phone;
  late final TextEditingController _date;
  late final TextEditingController _seat;

  @override
  void initState() {
    super.initState();
    _passenger = TextEditingController(text: widget.booking.passenger);
    _phone = TextEditingController(text: widget.booking.phone);
    _date = TextEditingController(text: widget.booking.date);
    _seat = TextEditingController(text: widget.booking.seat);
  }

  @override
  void dispose() {
    _passenger.dispose();
    _phone.dispose();
    _date.dispose();
    _seat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit booking'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _passenger,
                decoration: const InputDecoration(labelText: 'Passenger name'),
                validator: _required,
              ),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: _required,
              ),
              TextFormField(
                controller: _date,
                decoration: const InputDecoration(labelText: 'Travel date'),
                validator: _required,
              ),
              TextFormField(
                controller: _seat,
                decoration: const InputDecoration(labelText: 'Seat'),
                validator: _required,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              Booking(
                id: widget.booking.id,
                reference: widget.booking.reference,
                bus: widget.booking.bus,
                passenger: _passenger.text.trim(),
                phone: _phone.text.trim(),
                date: _date.text.trim(),
                seat: _seat.text.trim(),
              ),
            );
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;
}

// ============================================================
