import 'package:flutter/material.dart';

class _HotelRoom {
  const _HotelRoom({
    required this.name,
    required this.roomType,
    required this.shortDescription,
    required this.detailedDescription,
    required this.pricePerNight,
    required this.capacity,
    required this.sizeSqm,
    required this.bedType,
    required this.imageAsset,
    required this.facilities,
    required this.extraAmenities,
    required this.icon,
  });

  final String name;
  final String roomType;
  final String shortDescription;
  final String detailedDescription;
  final double pricePerNight;
  final int capacity;
  final int sizeSqm;
  final String bedType;
  final String imageAsset;
  final List<String> facilities;
  final List<String> extraAmenities;
  final IconData icon;
}

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  double _maxPrice = 800;
  String _selectedRoomType = 'All';
  bool _isGridView = false;
  final Set<String> _expandedRoomNames = <String>{};

  final Map<String, bool> _selectedFacilities = {
    'Wi-Fi': false,
    'Breakfast': false,
    'Parking': false,
    'Swimming Pool': false,
  };

  static const List<String> _roomTypes = ['All', 'Single', 'Double', 'Suite'];

  static const List<_HotelRoom> _rooms = [
    _HotelRoom(
      name: 'Standard Garden Room',
      roomType: 'Single',
      shortDescription:
          'Cozy garden-facing room tailored for solo travelers and business guests.',
      detailedDescription:
          'Unwind in a tranquil 28 sqm sanctuary overlooking lush Borneo ferns. Includes blackout curtains, an ergonomic work desk, high-speed fiber Wi-Fi, complimentary parking, and a walk-in rain shower.',
      pricePerNight: 180,
      capacity: 2,
      sizeSqm: 28,
      bedType: 'Queen Bed',
      imageAsset: 'assets/images/room_standard.jpg',
      facilities: ['Wi-Fi', 'Parking'],
      extraAmenities: ['Rain Shower', 'Work Desk', 'Smart TV'],
      icon: Icons.single_bed_outlined,
    ),
    _HotelRoom(
      name: 'Deluxe Riverfront Twin',
      roomType: 'Double',
      shortDescription:
          'Spacious river-view room with private balcony and daily breakfast buffet.',
      detailedDescription:
          'Wake up to golden Sarawak River reflections from your private balcony. Features dual plush beds, daily buffet breakfast for two, complimentary basement parking, and high-speed Wi-Fi.',
      pricePerNight: 320,
      capacity: 3,
      sizeSqm: 38,
      bedType: 'Twin or King Bed',
      imageAsset: 'assets/images/room_deluxe.jpg',
      facilities: ['Wi-Fi', 'Breakfast', 'Parking'],
      extraAmenities: ['River Balcony', 'Smart TV', 'Mini Bar'],
      icon: Icons.bed_outlined,
    ),
    _HotelRoom(
      name: 'Executive Horizon Suite',
      roomType: 'Suite',
      shortDescription:
          'Panoramic corner suite with lounge privileges, soaking tub, and pool access.',
      detailedDescription:
          'Designed for extended luxury with a separate living lounge, panoramic sunset views, complimentary breakfast buffet, infinity swimming pool access, and evening refreshments at the Horizon Lounge.',
      pricePerNight: 540,
      capacity: 4,
      sizeSqm: 56,
      bedType: 'King Bed + Sofa Bed',
      imageAsset: 'assets/images/room_executive.jpg',
      facilities: ['Wi-Fi', 'Breakfast', 'Swimming Pool'],
      extraAmenities: ['Lounge Access', 'Soaking Tub', 'Airport Transfer'],
      icon: Icons.king_bed_outlined,
    ),
    _HotelRoom(
      name: 'Presidential Canopy Loft',
      roomType: 'Suite',
      shortDescription:
          'Signature two-level penthouse loft with private terrace and butler service.',
      detailedDescription:
          'Our flagship 98 sqm loft delivers unmatched privacy with vaulted timber ceilings, private plunge terrace, dedicated butler, gourmet breakfast, priority parking, and full swimming pool & spa privileges.',
      pricePerNight: 780,
      capacity: 6,
      sizeSqm: 98,
      bedType: '2 King Beds',
      imageAsset: 'assets/images/room_presidential.jpg',
      facilities: ['Wi-Fi', 'Breakfast', 'Parking', 'Swimming Pool'],
      extraAmenities: ['Private Terrace', 'Butler Service', 'Dining Area'],
      icon: Icons.villa_outlined,
    ),
  ];

  List<_HotelRoom> get _filteredRooms {
    final activeFacilities = _selectedFacilities.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return _rooms.where((room) {
      if (room.pricePerNight > _maxPrice) {
        return false;
      }
      if (_selectedRoomType != 'All' && room.roomType != _selectedRoomType) {
        return false;
      }
      for (final facility in activeFacilities) {
        if (!room.facilities.contains(facility)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _maxPrice = 800;
      _selectedRoomType = 'All';
      for (final key in _selectedFacilities.keys) {
        _selectedFacilities[key] = false;
      }
    });
  }

  void _selectRoom(_HotelRoom room) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${room.name} selected (RM ${room.pricePerNight.toInt()}/night)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildRoomImage(_HotelRoom room, ColorScheme colorScheme) {
    return SizedBox(
      height: 165,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            room.imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: colorScheme.primaryContainer,
              child: Icon(room.icon, size: 54, color: colorScheme.primary),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                room.roomType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'RM ${room.pricePerNight.toInt()} / night',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(_HotelRoom room, ColorScheme colorScheme) {
    final isExpanded = _expandedRoomNames.contains(room.name);

    return Card(
      key: Key('roomCard_${room.name}'),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoomImage(room, colorScheme),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        room.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Up to ${room.capacity} guests',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  room.shortDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: room.facilities
                      .map(
                        (facility) => Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            facility,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            dividerColor: Colors.grey.shade200,
            expansionCallback: (panelIndex, currentIsExpanded) {
              setState(() {
                if (_expandedRoomNames.contains(room.name)) {
                  _expandedRoomNames.remove(room.name);
                } else {
                  _expandedRoomNames.add(room.name);
                }
              });
            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: isExpanded,
                headerBuilder: (context, expanded) => ListTile(
                  key: Key('expandRoom_${room.name}'),
                  dense: true,
                  leading: Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  title: const Text(
                    'Room Details, Facilities & Description',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.detailedDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.square_foot,
                              size: 16, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text('${room.sizeSqm} sqm'),
                          const SizedBox(width: 16),
                          Icon(Icons.bed_outlined,
                              size: 16, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Expanded(child: Text(room.bedType)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Additional Amenities',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: room.extraAmenities
                            .map(
                              (amenity) => Chip(
                                visualDensity: VisualDensity.compact,
                                avatar: const Icon(Icons.check, size: 14),
                                label: Text(
                                  amenity,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _selectRoom(room),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Select This Room'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Rooms',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  key: const Key('resetRoomFilters'),
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Max Nightly Price Preference',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'RM ${_maxPrice.round()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            Slider(
              key: const Key('roomPriceSlider'),
              value: _maxPrice,
              min: 180,
              max: 800,
              divisions: 12,
              label: 'RM ${_maxPrice.round()}',
              onChanged: (value) {
                setState(() {
                  _maxPrice = value;
                });
              },
            ),
            const Divider(),
            const Text(
              'Room Type',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            RadioGroup<String>(
              groupValue: _selectedRoomType,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRoomType = value;
                  });
                }
              },
              child: Wrap(
                spacing: 4,
                children: _roomTypes
                    .map(
                      (type) => SizedBox(
                        width: 145,
                        child: RadioListTile<String>(
                          key: Key('roomTypeRadio_$type'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(type),
                          value: type,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Divider(),
            const Text(
              'Additional Facilities',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Wrap(
              spacing: 4,
              children: _selectedFacilities.keys
                  .map(
                    (facility) => SizedBox(
                      width: 170,
                      child: CheckboxListTile(
                        key: Key('facilityCheckbox_$facility'),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(facility),
                        value: _selectedFacilities[facility],
                        onChanged: (value) {
                          setState(() {
                            _selectedFacilities[facility] = value ?? false;
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filteredRooms = _filteredRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rooms'),
        actions: [
          IconButton(
            key: const Key('toggleRoomLayout'),
            tooltip: _isGridView ? 'Switch to List View' : 'Switch to Grid View',
            icon: Icon(_isGridView ? Icons.view_agenda_outlined : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = _isGridView && constraints.maxWidth >= 600;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildFiltersCard(colorScheme),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${filteredRooms.length} of ${_rooms.length} Rooms',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (filteredRooms.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No rooms match your current filters',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Try increasing your budget or clearing a facility filter.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed: _resetFilters,
                          child: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (useTwoColumns)
                Wrap(
                  spacing: 12,
                  runSpacing: 0,
                  children: filteredRooms
                      .map(
                        (room) => SizedBox(
                          width: (constraints.maxWidth - 44) / 2,
                          child: _buildRoomCard(room, colorScheme),
                        ),
                      )
                      .toList(),
                )
              else
                ...filteredRooms.map((room) => _buildRoomCard(room, colorScheme)),
            ],
          );
        },
      ),
    );
  }
}
