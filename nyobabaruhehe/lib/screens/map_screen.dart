// lib/screens/map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

import '../models/destination.dart';
import '../utils/app_constants.dart';
import '../utils/location_service.dart';
import '../widgets/map_view.dart';
import '../widgets/destination_carousel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/edit_destination_screen.dart';
import '../screens/destination_detail_screen.dart';
import '../services/destination_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key}); // Use super.key

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // Ganti MapController dengan AnimatedMapController
  late final AnimatedMapController _animatedMapController;
  final PageController _pageController = PageController();
  LatLng? _userLocation;
  LatLng? _highlightedDestination;
  String? _distanceTimeInfo;
  bool _isMapReady = false; // Flag untuk cek kesiapan peta
  List<LatLng> _routePoints = [];
  List<Destination> _currentDestinations = [];

  // Di dalam _MapScreenState:
  late Stream<List<Destination>> _destinationsStream;
  final DestinationService _destinationService = DestinationService();

  @override
  void initState() {
    super.initState();
    _checkLocationAndGet();
    _destinationsStream = _destinationService.getDestinations();
    _destinationsStream.listen((destinations) {
      setState(() {
        _currentDestinations = destinations;
      });
    });
    // Listener untuk PageController agar peta bergerak saat carousel digeser
    // Inisialisasi AnimatedMapController
    _animatedMapController = AnimatedMapController(vsync: this);
    _pageController.addListener(() {
      int? currentPage = _pageController.page?.round();
      if (currentPage != null && currentPage < _currentDestinations.length) {
        _onDestinationSelected(currentPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animatedMapController
        .dispose(); // Penting untuk dispose controller animasi
    super.dispose();
  }

  Future<void> _getDirections(LatLng start, LatLng end) async {
    try {
      final OpenRouteService client = OpenRouteService(
        apiKey: openRouteServiceApiKey,
      );

      // Gunakan method directionsRouteCoordsGet
      final List<ORSCoordinate> routeCoordinates = await client
          .directionsRouteCoordsGet(
            startCoordinate: ORSCoordinate(
              latitude: start.latitude,
              longitude: start.longitude,
            ),
            endCoordinate: ORSCoordinate(
              latitude: end.latitude,
              longitude: end.longitude,
            ),
          );

      final List<LatLng> points = routeCoordinates
          .map((coord) => LatLng(coord.latitude, coord.longitude))
          .toList();

      setState(() {
        _routePoints = points;
      });
    } catch (e) {
      debugPrint('Error getting directions: $e');
      setState(() {
        _routePoints = [];
      });
    }
  }

  Future<void> _checkLocationAndGet() async {
    final locationService = LocationService();
    Position? position = await locationService.getCurrentLocation();

    if (position != null) {
      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
        });
        if (_isMapReady) {
          _animateToUserLocation();
        }
      }
    } else {
      _showLocationDeniedNotification();
    }
  }

  void _animateToUserLocation() {
    if (_userLocation != null && _isMapReady) {
      _animatedMapController.animateTo(
        dest: _userLocation!,
        zoom: 12.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showLocationDeniedNotification() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Akses lokasi ditolak. Harap aktifkan lokasi Anda untuk pengalaman terbaik.',
        ),
        action: SnackBarAction(
          label: 'Pengaturan',
          onPressed: () {
            // Buka pengaturan
          },
        ),
      ),
    );
  }

  void _onDestinationSelected(int index) async {
    if (mounted && index < _currentDestinations.length) {
      setState(() {
        _highlightedDestination = _currentDestinations[index].location;
      });

      _animatedMapController.animateTo(
        dest: _currentDestinations[index].location,
        zoom: 12.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );

      if (_userLocation != null) {
        await _getDirections(
          _userLocation!,
          _currentDestinations[index].location,
        );
        await _getDistanceAndTime(
          _userLocation!,
          _currentDestinations[index].location,
        );
      }
    }
  }

  Future<void> _getDistanceAndTime(LatLng start, LatLng end) async {
    try {
      final double distanceMeters = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );

      final double distanceKm = distanceMeters / 1000;
      const double averageSpeedKmPerHour = 40.0;
      final double durationHours = distanceKm / averageSpeedKmPerHour;
      final int durationMinutes = (durationHours * 60).round();

      if (mounted) {
        setState(() {
          _distanceTimeInfo =
              'Jarak: ${distanceKm.toStringAsFixed(2)} km\nEstimasi Waktu: $durationMinutes menit';
        });
      }
    } catch (e) {
      debugPrint('Error getting distance and time: $e');
      if (mounted) {
        setState(() {
          _distanceTimeInfo = 'Gagal mengambil informasi rute.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapView(
            userLocation: _userLocation,
            destinations: _currentDestinations,
            animatedMapController: _animatedMapController,
            highlightedDestination: _highlightedDestination,
            routePoints: _routePoints,
            onMapReady: () =>
                setState(() => _isMapReady = true), // Callback saat peta siap
            // // Di MapView, tambahkan PolylineLayer:
            // PolylineLayer(
            //   polylines: [
            //     Polyline(
            //       points: _routePoints,
            //       strokeWidth: 4.0,
            //       color: Colors.blue,
            //     ),
            //   ],
            // ),
          ),
          // Tombol Kembali
          Positioned(
            top: 50,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: Container(
                padding: const EdgeInsets.all(10), // Padding lebih besar
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.8), // Alternatif
                  borderRadius: BorderRadius.circular(
                    15,
                  ), // Sudut lebih membulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.blue,
                ), // Warna ikon biru
              ),
            ),
          ),
          // Tombol My Location
          Positioned(
            top: 50,
            right: 16,
            child: GestureDetector(
              onTap: () {
                if (_userLocation != null) {
                  _animatedMapController.animateTo(
                    dest: _userLocation!,
                    zoom: 14.0, // Zoom in ke lokasi user
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _showLocationDeniedNotification(); // Tampilkan peringatan jika lokasi tidak ada
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.8), // Alternatif
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ),
          // Informasi Jarak dan Waktu
          if (_distanceTimeInfo != null)
            Positioned(
              top: 110, // Posisi di bawah tombol navigasi
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.8), // Alternatif
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _distanceTimeInfo!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // Di dalam lib/screens/map_screen.dart
          // Destination Carousel
          StreamBuilder<List<Destination>>(
            stream: _destinationsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada destinasi'));
              }
              return DestinationCarousel(
                destinations: snapshot.data!,
                onDestinationSelected: _onDestinationSelected,
                onDestinationTapped: (destination) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DestinationDetailScreen(destination: destination),
                    ),
                  );
                },
                pageController: _pageController,
              );
            },
          ),
          // Tambahkan tombol add di Stack:
          Positioned(
            bottom: 180, // Di atas carousel
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditDestinationScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
        
      ),
    );
  }
}

// extension on OpenRouteService {
//   Future directionsRoutePointGet({required ORSCoordinate start, required ORSCoordinate end, required ORSProfile profileOverride}) {
//     throw UnimplementedError('directionsRoutePointGet is not implemented');
//   }
// }
