import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/theme/app_theme.dart';

/// A full-screen map picker.
/// Usage:
///   final result = await Get.to(() => const MapPickerView());
///   if (result != null) { final LatLng latlng = result['latlng']; final String address = result['address']; }
class MapPickerView extends StatefulWidget {
  const MapPickerView({super.key});

  @override
  State<MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<MapPickerView> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(23.8103, 90.4125); // Dhaka default
  final _isLocating = ValueNotifier(false);
  final _addressCtrl = TextEditingController();

  static const _initZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _tryGetCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _addressCtrl.dispose();
    _isLocating.dispose();
    super.dispose();
  }

  Future<void> _tryGetCurrentLocation() async {
    _isLocating.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isLocating.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          _isLocating.value = false;
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final latLng = LatLng(pos.latitude, pos.longitude);
      setState(() => _selectedLocation = latLng);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, _initZoom));
      _addressCtrl.text = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
    } catch (_) {
      // silently fall back to default
    } finally {
      _isLocating.value = false;
    }
  }

  void _onCameraIdle() {
    // Update address field with lat/lng when user stops moving the map
    _addressCtrl.text =
        '${_selectedLocation.latitude.toStringAsFixed(5)}, ${_selectedLocation.longitude.toStringAsFixed(5)}';
  }

  void _onCameraMove(CameraPosition position) {
    setState(() => _selectedLocation = position.target);
  }

  void _confirm() {
    Get.back(
      result: {
        'latlng': _selectedLocation,
        'address': _addressCtrl.text.trim().isNotEmpty
            ? _addressCtrl.text.trim()
            : '${_selectedLocation.latitude.toStringAsFixed(5)}, ${_selectedLocation.longitude.toStringAsFixed(5)}',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _selectedLocation, zoom: _initZoom),
            onMapCreated: (ctrl) => _mapController = ctrl,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          // Center pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: Icon(Icons.location_pin, size: 48, color: AppTheme.primaryColor),
            ),
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)],
                      ),
                      child: const Text(
                        'Move the map to select location',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black12)],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Selected Location',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2D3D)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF5F6FA),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      hintText: 'Address or coordinates',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // My location button
                      ValueListenableBuilder<bool>(
                        valueListenable: _isLocating,
                        builder: (_, locating, __) => OutlinedButton.icon(
                          onPressed: locating ? null : _tryGetCurrentLocation,
                          icon: locating
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.my_location, size: 18),
                          label: const Text('My Location'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(color: AppTheme.primaryColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _confirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Confirm Location',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
