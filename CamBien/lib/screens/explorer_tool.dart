import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class ExplorerTool extends StatefulWidget {
  const ExplorerTool({super.key});

  @override
  State<ExplorerTool> createState() => _ExplorerToolState();
}

class _ExplorerToolState extends State<ExplorerTool> {
  String _locationMessage = "Đang lấy vị trí...";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationMessage = "Hãy bật GPS (Location Service)!");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationMessage = "Quyền vị trí bị từ chối.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _locationMessage = "Quyền vị trí bị từ chối vĩnh viễn. Vào cài đặt để bật.");
      return;
    }

    final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
    setState(() {
      _locationMessage =
          "Vĩ độ (Lat): ${position.latitude}\nKinh độ (Long): ${position.longitude}\nĐộ cao (Alt): ${position.altitude.toStringAsFixed(1)}m";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Explorer Tool"), backgroundColor: Colors.grey[900]),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.blueGrey[900],
            child: Text(
              _locationMessage,
              style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontFamily: 'monospace'),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: StreamBuilder<MagnetometerEvent>(
              stream: magnetometerEventStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final event = snapshot.data!;
                double heading = atan2(event.y, event.x);
                double headingDegrees = heading * 180 / pi;
                if (headingDegrees < 0) headingDegrees += 360;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${headingDegrees.toStringAsFixed(0)}°",
                          style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
                      const Text("HƯỚNG BẮC", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),
                      Transform.rotate(
                        angle: -heading,
                        child: const Icon(Icons.navigation, size: 150, color: Colors.redAccent),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
