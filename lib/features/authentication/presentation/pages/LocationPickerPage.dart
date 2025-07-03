import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({Key? key}) : super(key: key);

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final loc.Location _location = loc.Location();
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  String _address = 'جاري تحديد الموقع...';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      await _location.requestService();
    }
    final permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      await _location.requestPermission();
    }

    final currentLocation = await _location.getLocation();
    if (!mounted) return; // ✅ الحل هنا
    setState(() {
      _selectedLatLng = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
    });
    _getAddress(_selectedLatLng!);

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_selectedLatLng!),
    );
  }

  Future<void> _goToMyLocation() async {
    final currentLocation = await _location.getLocation();
    LatLng myLatLng =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    if (!mounted) return; // ✅ الحل هنا
    setState(() {
      _selectedLatLng = myLatLng;
      _address = 'جاري تحديد الموقع...';
    });
    _getAddress(myLatLng);
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(myLatLng),
    );
  }

  Future<void> _getAddress(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (!mounted) return; // ✅ الحل هنا
    if (placemarks.isNotEmpty) {
      final p = placemarks.first;

      // ترجمة سريعة لبعض القيم لو ظهرت بالانجليزي
      String? country = p.country;
      if (country == "Saudi Arabia") country = "السعودية";
      if (country == "Yemen") country = "اليمن";

      setState(() {
        _address = [
          if (p.street != null && p.street!.isNotEmpty) p.street,
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
            p.administrativeArea,
          if (country != null && country.isNotEmpty) country,
        ].join('، ');
      });
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
      _address = 'جاري التحديد...';
    });
    _getAddress(latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // الخريطة بكامل الشاشة
          _selectedLatLng == null
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLatLng!,
                    zoom: 16,
                  ),
                  onTap: _onMapTap,
                  markers: _selectedLatLng == null
                      ? {}
                      : {
                          Marker(
                            markerId: MarkerId('selected'),
                            position: _selectedLatLng!,
                          ),
                        },
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),

          // العنوان فوق الخريطة
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.92),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _address,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.text,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.visible,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // أزرار الأسفل
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.my_location),
                        label: Text(
                          'الذهاب إلى موقعي الحالي',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Rubik',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.13),
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 13),
                          textStyle: TextStyle(fontFamily: 'Rubik'),
                        ),
                        onPressed: _goToMyLocation,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'حفظ الموقع',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rubik',
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, _selectedLatLng);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
