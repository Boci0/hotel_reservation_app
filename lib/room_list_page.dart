import 'package:flutter/material.dart';

class _HotelRoom {
  const _HotelRoom({
    required this.name,
    required this.category,
    required this.pricePerNight,
    required this.capacity,
    required this.amenities,
    required this.icon,
  });

  final String name;
  final String category;
  final double pricePerNight;
  final int capacity;
  final List<String> amenities;
  final IconData icon;
}

class _FaqItem {
  const _FaqItem({required this.header, required this.body});

  final String header;
  final String body;
}

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  double _maxPrice = 600;
  int _currentlyExpandedIndex = 0;

  static const List<_HotelRoom> _rooms = [
    _HotelRoom(
      name: 'Standard Garden Room',
      category: 'Single',
      pricePerNight: 180,
      capacity: 2,
      amenities: ['Free Wi-Fi', 'Rain Shower', 'Work Desk'],
      icon: Icons.single_bed_outlined,
    ),
    _HotelRoom(
      name: 'Deluxe Riverfront Twin',
      category: 'Double',
      pricePerNight: 320,
      capacity: 3,
      amenities: ['River Balcony', 'Breakfast Included', 'Smart TV'],
      icon: Icons.bed_outlined,
    ),
    _HotelRoom(
      name: 'Executive Horizon Suite',
      category: 'Suite',
      pricePerNight: 540,
      capacity: 4,
      amenities: ['Lounge Access', 'Soaking Tub', 'Airport Transfer'],
      icon: Icons.king_bed_outlined,
    ),
    _HotelRoom(
      name: 'Presidential Canopy Loft',
      category: 'Suite',
      pricePerNight: 780,
      capacity: 6,
      amenities: ['Private Terrace', 'Butler Service', 'Dining Area'],
      icon: Icons.villa_outlined,
    ),
  ];

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      header: 'Check-in & Check-out Policy',
      body: 'Standard check-in starts at 3:00 PM and check-out is by 12:00 PM. '
          'Late check-out until 2:00 PM can be added from the booking dashboard.',
    ),
    _FaqItem(
      header: 'Free Cancellation Window',
      body: 'Reservations may be modified or cancelled without charge up to '
          '48 hours prior to the scheduled check-in date.',
    ),
    _FaqItem(
      header: 'Airport Shuttle & Parking',
      body: 'Complimentary basement parking is provided for all guests. '
          'Airport transfers operate hourly from 6:00 AM to 11:00 PM.',
    ),
  ];

  void _showRoomDetails(_HotelRoom room) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  child: Icon(room.icon),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${room.category} • Up to ${room.capacity} guests',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                Text(
                  'RM ${room.pricePerNight.toInt()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Included Amenities',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: room.amenities
                  .map((amenity) => Chip(label: Text(amenity)))
                  .toList(),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${room.name} selected for booking'),
                    ),
                  );
                },
                child: const Text('Select This Room'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRooms =
        _rooms.where((room) => room.pricePerNight <= _maxPrice).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rooms'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Max Nightly Budget',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'RM ${_maxPrice.round()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _maxPrice,
                    min: 200,
                    max: 800,
                    divisions: 6,
                    label: 'RM ${_maxPrice.round()}',
                    onChanged: (value) {
                      setState(() {
                        _maxPrice = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...filteredRooms.map(
            (room) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 26,
                  child: Icon(room.icon),
                ),
                title: Text(
                  room.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${room.category} • Up to ${room.capacity} guests\n${room.amenities.join(' · ')}',
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'RM ${room.pricePerNight.toInt()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Text('per night', style: TextStyle(fontSize: 11)),
                  ],
                ),
                onTap: () => _showRoomDetails(room),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Hotel Policies & FAQ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_faqs.length, (index) {
            final item = _faqs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ExpansionTile(
                key: ValueKey('faq_${index}_$_currentlyExpandedIndex'),
                initiallyExpanded: index == _currentlyExpandedIndex,
                title: Text(
                  item.header,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _currentlyExpandedIndex = expanded ? index : -1;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(item.body),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
