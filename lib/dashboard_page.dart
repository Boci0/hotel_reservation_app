import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RoomType { single, double, suite }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.initialCheckIn, this.initialCheckOut});

  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _formKey = GlobalKey<FormState>();
  final _guestNameController = TextEditingController();
  final _guestEmailController = TextEditingController();

  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  TimeOfDay _arrivalTime = const TimeOfDay(hour: 15, minute: 0);

  RoomType _selectedRoomType = RoomType.double;
  double _guestCount = 2;
  String _bedPreference = 'King Bed';
  bool _highFloorQuietRoom = true;

  final Map<String, bool> _addOns = {
    'Breakfast Buffet': true,
    'Airport Shuttle': false,
    'Late Check-out (2 PM)': false,
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _checkInDate =
        widget.initialCheckIn ?? DateTime(now.year, now.month, now.day);
    _checkOutDate =
        widget.initialCheckOut ?? _checkInDate.add(const Duration(days: 2));
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestEmailController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  int get _nightCount {
    final checkInDay =
        DateTime(_checkInDate.year, _checkInDate.month, _checkInDate.day);
    final checkOutDay =
        DateTime(_checkOutDate.year, _checkOutDate.month, _checkOutDate.day);
    return checkOutDay.difference(checkInDay).inDays;
  }

  Future<void> _pickCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _pickCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  Future<void> _pickArrivalTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _arrivalTime,
    );
    if (picked != null) {
      setState(() {
        _arrivalTime = picked;
      });
    }
  }

  void _confirmLogout() {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Return to the login screen?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Sign Out'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final guestName = _guestNameController.text.trim();
    final selectedAddOns = _addOns.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .join(', ');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking confirmed for $guestName'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reservation Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Borneo Crest Hotel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Guest: $guestName'),
            Text('Email: ${_guestEmailController.text.trim()}'),
            Text('Check-in: ${_formatDate(_checkInDate)}'),
            Text('Check-out: ${_formatDate(_checkOutDate)}'),
            Text('Arrival: ${_arrivalTime.format(context)}'),
            Text(
                'Room: ${_selectedRoomType.name.toUpperCase()} ($_bedPreference)'),
            Text('Guests: ${_guestCount.round()}'),
            if (selectedAddOns.isNotEmpty) Text('Add-ons: $selectedAddOns'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/rooms');
            },
            child: const Text('Browse Rooms'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 215,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/hotel_banner.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, const Color(0xFF1A6B6B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.hotel_class_rounded,
                    size: 72,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.78),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.8 • 5-Star Riverside Resort',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Welcome back, Guest!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Borneo Crest Hotel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white70,
                        size: 15,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Kuching Waterfront, Sarawak • Riverside Luxury',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickNavigation(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore & Navigate',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    key: const Key('navRoomsButton'),
                    onPressed: () => Navigator.pushNamed(context, '/rooms'),
                    icon: const Icon(Icons.king_bed_outlined),
                    label: const Text('Rooms'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('navSignupButton'),
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('Register'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('navSignOutButton'),
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelInfoCard(ColorScheme colorScheme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 130,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/hotel_pool.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.pool_outlined,
                      size: 48,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 14,
                  bottom: 10,
                  right: 14,
                  child: Text(
                    'Infinity Pool & Sunset Riverfront Terrace',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Borneo Crest Hotel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Overlooking the Sarawak River, Borneo Crest Hotel offers tranquil tropical suites, an infinity pool, complimentary high-speed Wi-Fi, riverfront dining, and 24-hour concierge service.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: Icon(Icons.wifi, size: 16),
                      label: Text('Free Wi-Fi'),
                    ),
                    Chip(
                      avatar: Icon(Icons.pool, size: 16),
                      label: Text('Infinity Pool'),
                    ),
                    Chip(
                      avatar: Icon(Icons.local_parking, size: 16),
                      label: Text('Free Parking'),
                    ),
                    Chip(
                      avatar: Icon(Icons.restaurant, size: 16),
                      label: Text('Riverfront Dining'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Check-in: 3:00 PM • Check-out: 12:00 PM • Tel: +60 82-550-888',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nights = _nightCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borneo Crest Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Room List',
            icon: const Icon(Icons.meeting_room_outlined),
            onPressed: () => Navigator.pushNamed(context, '/rooms'),
          ),
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeroBanner(colorScheme),
                  const SizedBox(height: 14),
                  _buildQuickNavigation(colorScheme),
                  const SizedBox(height: 12),
                  _buildHotelInfoCard(colorScheme),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guest Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const Key('guestName'),
                            controller: _guestNameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Guest Name',
                              hintText: 'Enter full name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Guest name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const Key('guestEmail'),
                            controller: _guestEmailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Guest Email',
                              hintText: 'guest@example.com',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(value.trim())) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stay Dates & Arrival',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (nights > 0)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(
                                    '$nights ${nights == 1 ? 'Night' : 'Nights'}',
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  key: const Key('checkInButton'),
                                  onPressed: _pickCheckInDate,
                                  icon:
                                      const Icon(Icons.calendar_today_outlined),
                                  label:
                                      Text('Check-in: ${_formatDate(_checkInDate)}'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  key: const Key('checkOutButton'),
                                  onPressed: _pickCheckOutDate,
                                  icon: const Icon(Icons.event_outlined),
                                  label: Text(
                                      'Check-out: ${_formatDate(_checkOutDate)}'),
                                ),
                              ),
                            ],
                          ),
                          FormField<DateTime>(
                            key: const Key('stayDatesValidator'),
                            initialValue: _checkOutDate,
                            validator: (_) {
                              if (_nightCount <= 0) {
                                return 'Check-out must be after check-in';
                              }
                              return null;
                            },
                            builder: (state) {
                              if (!state.hasError) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8, left: 4),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.access_time_outlined),
                            title: const Text('Estimated Arrival Time'),
                            subtitle: Text(_arrivalTime.format(context)),
                            trailing: IconButton(
                              key: const Key('arrivalTimeButton'),
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: _pickArrivalTime,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Options',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<RoomType>(
                            segments: const [
                              ButtonSegment(
                                value: RoomType.single,
                                label: Text('Single'),
                                icon: Icon(Icons.single_bed_outlined),
                              ),
                              ButtonSegment(
                                value: RoomType.double,
                                label: Text('Double'),
                                icon: Icon(Icons.bed_outlined),
                              ),
                              ButtonSegment(
                                value: RoomType.suite,
                                label: Text('Suite'),
                                icon: Icon(Icons.king_bed_outlined),
                              ),
                            ],
                            selected: {_selectedRoomType},
                            onSelectionChanged: (selection) {
                              setState(() {
                                _selectedRoomType = selection.first;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Number of Guests'),
                              Chip(
                                label: Text('${_guestCount.round()} Guests'),
                              ),
                            ],
                          ),
                          Slider(
                            key: const Key('guestsSlider'),
                            value: _guestCount,
                            min: 1,
                            max: 6,
                            divisions: 5,
                            label: '${_guestCount.round()}',
                            onChanged: (value) {
                              setState(() {
                                _guestCount = value;
                              });
                            },
                          ),
                          const Divider(),
                          const Text(
                            'Bed Preference',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          RadioGroup<String>(
                            groupValue: _bedPreference,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _bedPreference = value);
                              }
                            },
                            child: Column(
                              children: ['King Bed', 'Queen Bed', 'Twin Beds']
                                  .map(
                                    (bed) => RadioListTile<String>(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(bed),
                                      value: bed,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const Divider(),
                          const Text(
                            'Optional Add-ons',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ..._addOns.keys.map(
                            (addon) => CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(addon),
                              value: _addOns[addon],
                              onChanged: (value) {
                                setState(() {
                                  _addOns[addon] = value ?? false;
                                });
                              },
                            ),
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('High-floor quiet room'),
                            subtitle:
                                const Text('Subject to availability at check-in'),
                            value: _highFloorQuietRoom,
                            onChanged: (value) {
                              setState(() {
                                _highFloorQuietRoom = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    key: const Key('bookNowButton'),
                    onPressed: _submitBooking,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/rooms');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/signup');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.king_bed_outlined),
            selectedIcon: Icon(Icons.king_bed),
            label: 'Rooms',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
