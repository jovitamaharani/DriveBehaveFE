# Vehicle Telemetry Sensor Demo

A minimal Flutter application to verify sensor library functionality for vehicle telemetry monitoring.

## Features

- Real-time accelerometer data (X, Y, Z axes)
- Real-time gyroscope data (X, Y, Z axes)
- GPS location tracking (coordinates, speed, altitude)
- Clean architecture with separation of concerns
- Permission handling

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── sensor_data.dart        # Data models (Vector3D, GpsData, SensorReadings)
├── services/
│   ├── sensor_service.dart     # Sensor data acquisition
│   └── permission_service.dart # Permission management
├── screens/
│   └── sensor_demo_screen.dart # Main screen
└── widgets/
    ├── status_card.dart        # Status display
    ├── sensor_card.dart        # Sensor data cards
    └── control_buttons.dart    # Start/Stop controls
```

## Quick Start

### Install Dependencies
```bash
flutter pub get
```

### Run Application
```bash
flutter run
```

### iOS Setup
```bash
cd ios && pod install && cd ..
flutter run
```

## Usage

1. Launch the app
2. Tap "Start" button
3. Grant location permissions when prompted
4. Move device to see sensor values update

## Testing Sensors

**Accelerometer**: Tilt or move the device
**Gyroscope**: Rotate the device
**GPS**: Go outdoors for best results

## Requirements

- Flutter SDK 3.5.4+
- Android: API 21+ (Location permissions)
- iOS: iOS 12+ (Location and motion permissions)
