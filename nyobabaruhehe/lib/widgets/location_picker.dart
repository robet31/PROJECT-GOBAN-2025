// lib/widgets/location_picker.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends StatefulWidget {
  final LatLng? initialLocation;
  final ValueChanged<LatLng> onLocationSelected;

  const LocationPicker({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedLocation != null
                    ? 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}'
                    : 'No location selected',
              ),
            ),
            TextButton(
              onPressed: _selectOnMap,
              child: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectOnMap() async {
    // TODO: Implement map selection screen
    // This would navigate to a full-screen map where user can select location
    
    // For demo, we'll use a mock location
    final location = LatLng(-8.409518, 115.188919); // Bali, Indonesia
    
    setState(() => _selectedLocation = location);
    widget.onLocationSelected(location);
  }
}