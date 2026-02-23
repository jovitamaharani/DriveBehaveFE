# Sensor Demo App - Quick Test

This is a minimal demo app to verify that the sensor libraries (sensors_plus, geolocator) work correctly on your device.

## What This Demo Does

- Displays real-time data from:
  - **Accelerometer** (X, Y, Z axes in m/s²)
  - **Gyroscope** (X, Y, Z axes in rad/s)
  - **GPS** (Latitude, Longitude, Speed, Altitude)
- Simple Start/Stop controls
- Visual feedback of sensor status

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run on Device

**For Android:**
```bash
flutter run
```

**For iOS:**
```bash
cd ios
pod install
cd ..
flutter run
```

### 3. Grant Permissions

When the app starts:
- Tap "Start" button
- Grant location permissions when prompted
- Move your device to see sensor values change

## What to Look For

✅ **Working Correctly:**
- Accelerometer values change when you move the device
- Gyroscope values change when you rotate the device
- GPS coordinates update (may take 10-30 seconds outdoors)
- No error messages in status area

❌ **Issues:**
- "Permission denied" - Grant location permissions in device settings
- "Location services disabled" - Enable GPS in device settings
- Sensor values stay at 0.0 - Check device sensor availability
- GPS not updating - Go outdoors or near a window

## Testing Tips

1. **Accelerometer Test:**
   - Tilt device forward/backward → Y value changes
   - Tilt device left/right → X value changes
   - Move device up/down → Z value changes

2. **Gyroscope Test:**
   - Rotate device around vertical axis → Z value changes
   - Rotate device around horizontal axis → X or Y values change

3. **GPS Test:**
   - Best results outdoors with clear sky view
   - May not work well indoors
   - Speed will show 0 if stationary

## Expected Values

- **Accelerometer at rest:** ~9.8 m/s² total (gravity)
- **Gyroscope at rest:** ~0.0 rad/s
- **GPS:** Your actual coordinates and speed

## Next Steps

If all sensors work correctly, you can proceed with implementing the full telemetry system from the spec:
- `.kiro/specs/vehicle-telemetry-unsafe-driving-detection/requirements.md`
- `.kiro/specs/vehicle-telemetry-unsafe-driving-detection/design.md`
- `.kiro/specs/vehicle-telemetry-unsafe-driving-detection/tasks.md`

## Troubleshooting

**Flutter not found:**
```bash
# Install Flutter: https://flutter.dev/docs/get-started/install
```

**Build errors:**
```bash
flutter clean
flutter pub get
flutter run
```

**Permission issues on Android:**
- Go to Settings → Apps → DrivingBehavior → Permissions
- Enable Location permissions

**Permission issues on iOS:**
- Go to Settings → Privacy → Location Services
- Enable for DrivingBehavior app
