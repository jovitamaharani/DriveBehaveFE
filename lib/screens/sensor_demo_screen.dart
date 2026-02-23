import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/sensor_service.dart';
import '../services/permission_service.dart';
import '../widgets/status_card.dart';
import '../widgets/sensor_card.dart';
import '../widgets/control_buttons.dart';

class SensorDemoScreen extends StatefulWidget {
  const SensorDemoScreen({super.key});

  @override
  State<SensorDemoScreen> createState() => _SensorDemoScreenState();
}

class _SensorDemoScreenState extends State<SensorDemoScreen> {
  final _sensorService = SensorService();
  final _permissionService = PermissionService();

  SensorReadings _readings = const SensorReadings.initial();
  bool _isMonitoring = false;
  String _statusMessage = 'Press Start to begin monitoring';

  @override
  void initState() {
    super.initState();
    _sensorService.readings.listen(_onSensorReadings);
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  void _onSensorReadings(SensorReadings readings) {
    setState(() {
      _readings = readings;
    });
  }

  Future<void> _handleStart() async {
    final hasPermission = await _permissionService.requestLocationPermission();
    
    if (!hasPermission) {
      setState(() {
        _statusMessage = 'Location permission denied';
      });
      return;
    }

    await _sensorService.startMonitoring();
    
    setState(() {
      _isMonitoring = true;
      _statusMessage = 'Monitoring active...';
    });
  }

  Future<void> _handleStop() async {
    await _sensorService.stopMonitoring();
    
    setState(() {
      _isMonitoring = false;
      _statusMessage = 'Monitoring stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sensor Demo - Library Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatusCard(
              isMonitoring: _isMonitoring,
              message: _statusMessage,
            ),
            const SizedBox(height: 16),
            AccelerometerCard(data: _readings.accelerometer),
            const SizedBox(height: 16),
            GyroscopeCard(data: _readings.gyroscope),
            const SizedBox(height: 16),
            GpsCard(data: _readings.gps),
            const SizedBox(height: 24),
            ControlButtons(
              isMonitoring: _isMonitoring,
              onStart: _handleStart,
              onStop: _handleStop,
            ),
          ],
        ),
      ),
    );
  }
}
