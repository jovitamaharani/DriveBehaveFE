import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../models/sensor_data.dart';

class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  Timer? _gpsTimer;

  final _readingsController = StreamController<SensorReadings>.broadcast();
  Stream<SensorReadings> get readings => _readingsController.stream;

  Vector3D _currentAccelerometer = const Vector3D.zero();
  Vector3D _currentGyroscope = const Vector3D.zero();
  GpsData _currentGps = const GpsData.zero();

  Future<void> startMonitoring() async {
    await _startAccelerometer();
    await _startGyroscope();
    await _startGps();
  }

  Future<void> stopMonitoring() async {
    await _accelerometerSubscription?.cancel();
    await _gyroscopeSubscription?.cancel();
    _gpsTimer?.cancel();
    
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _gpsTimer = null;
  }

  Future<void> _startAccelerometer() async {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      _currentAccelerometer = Vector3D(
        x: event.x,
        y: event.y,
        z: event.z,
      );
      _emitCurrentReadings();
    });
  }

  Future<void> _startGyroscope() async {
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      _currentGyroscope = Vector3D(
        x: event.x,
        y: event.y,
        z: event.z,
      );
      _emitCurrentReadings();
    });
  }

  Future<void> _startGps() async {
    _gpsTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        final position = await _getCurrentPosition();
        if (position != null) {
          _currentGps = GpsData(
            latitude: position.latitude,
            longitude: position.longitude,
            speed: position.speed,
            altitude: position.altitude,
          );
          _emitCurrentReadings();
        }
      } catch (_) {}
    });
  }

  Future<Position?> _getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  void _emitCurrentReadings() {
    _readingsController.add(
      SensorReadings(
        accelerometer: _currentAccelerometer,
        gyroscope: _currentGyroscope,
        gps: _currentGps,
      ),
    );
  }

  void dispose() {
    stopMonitoring();
    _readingsController.close();
  }
}
