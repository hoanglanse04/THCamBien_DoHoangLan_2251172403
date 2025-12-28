import 'package:flutter/material.dart';
import 'screens/motion_tracker.dart';
import 'screens/explorer_tool.dart';
import 'screens/light_meter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CamBien Demos',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const DemoPicker(),
    );
  }
}

class DemoPicker extends StatelessWidget {
  const DemoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn bài thực hành')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.vibration),
            title: const Text('Bài 1: Máy Đo Chuyển Động'),
            subtitle: const Text('Đếm số lần lắc mạnh'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MotionTracker())),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Bài 2: Nhà Thám Hiểm'),
            subtitle: const Text('GPS + La bàn'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExplorerTool())),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('Bài 3: Cảm biến Ánh sáng'),
            subtitle: const Text('Đo cường độ ánh sáng (Lux)'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LightMeter())),
          ),
        ],
      ),
    );
  }
}
