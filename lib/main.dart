import 'package:flutter/material.dart';
import 'screens/sensor_demo_screen.dart';

void main() {
  runApp(const SensorDemoApp());
}

class SensorDemoApp extends StatelessWidget {
  const SensorDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SensorDemoScreen(),
    );
  }
}
