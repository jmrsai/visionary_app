import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// 1. Overlay Entry Point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlueLightFilterOverlay(),
  ));
}

// 2. Overlay Widget
class BlueLightFilterOverlay extends StatefulWidget {
  const BlueLightFilterOverlay({Key? key}) : super(key: key);

  @override
  _BlueLightFilterOverlayState createState() => _BlueLightFilterOverlayState();
}

class _BlueLightFilterOverlayState extends State<BlueLightFilterOverlay> {
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    // Listen for data from the main app
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data is Map && data.containsKey('show')) {
        setState(() {
          _showOverlay = data['show'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showOverlay
        ? Container(
            color: Colors.orange.withOpacity(0.3),
          )
        : Container();
  }
}

// 3. Overlay Service
class OverlayService {
  static Future<void> initialize() async {
    // Check for permission
    final bool? granted = await FlutterOverlayWindow.isPermissionGranted();
    if (granted != true) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  static Future<void> startBlueLightFilter() async {
    // 1. Check location permissions
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 2. Get location
    Position position = await Geolocator.getCurrentPosition();

    // 3. Get sunrise/sunset times
    final response = await http.get(Uri.parse(
        'https://api.sunrise-sunset.org/json?lat=${position.latitude}&lng=${position.longitude}&formatted=0'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final sunrise = DateTime.parse(data['results']['sunrise']).toLocal();
      final sunset = DateTime.parse(data['results']['sunset']).toLocal();
      final now = DateTime.now();

      // 4. Determine if the filter should be active
      final bool shouldShow = now.isAfter(sunset) || now.isBefore(sunrise);

      // 5. Show/hide the overlay
      await _updateOverlay(shouldShow);

    } else {
      throw Exception('Failed to load sunrise-sunset data');
    }
  }

  static Future<void> _updateOverlay(bool show) async {
    if (await FlutterOverlayWindow.isActive()) {
      await FlutterOverlayWindow.shareData({'show': show});
    } else {
      await FlutterOverlayWindow.showOverlay(
        height: FlutterOverlayWindow.matchParent,
        width: FlutterOverlayWindow.matchParent,
        flag: OverlayFlag.clickThrough,
        overlayMessage: "Visionary Blue Light Filter is active",
        // The overlay widget will be built by overlayMain
      );
      // Small delay to ensure the overlay is ready to receive data
      await Future.delayed(const Duration(milliseconds: 100));
      await FlutterOverlayWindow.shareData({'show': show});
    }
  }
}
