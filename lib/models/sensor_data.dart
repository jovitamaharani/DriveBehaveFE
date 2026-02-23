import 'dart:math';

class Vector3D {
  final double x;
  final double y;
  final double z;

  const Vector3D({
    required this.x,
    required this.y,
    required this.z,
  });

  const Vector3D.zero() : x = 0, y = 0, z = 0;

  double get magnitude => sqrt(x * x + y * y + z * z);
}

class GpsData {
  final double latitude;
  final double longitude;
  final double speed;
  final double altitude;

  const GpsData({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.altitude,
  });

  const GpsData.zero()
      : latitude = 0,
        longitude = 0,
        speed = 0,
        altitude = 0;
}

class SensorReadings {
  final Vector3D accelerometer;
  final Vector3D gyroscope;
  final GpsData gps;

  const SensorReadings({
    required this.accelerometer,
    required this.gyroscope,
    required this.gps,
  });

  const SensorReadings.initial()
      : accelerometer = const Vector3D.zero(),
        gyroscope = const Vector3D.zero(),
        gps = const GpsData.zero();
}
