# Design Document: Vehicle Telemetry Unsafe Driving Detection

## Overview

This design describes a smartphone-based vehicle telemetry system that detects unsafe driving behaviors in real-time using sensor fusion, signal filtering, and event classification algorithms. The system continuously monitors accelerometer, gyroscope, and GPS sensors, processes the data through a filtering pipeline, fuses the information into a unified representation, and classifies driving events based on configurable thresholds.

The architecture emphasizes:
- **Real-time processing**: Sub-200ms latency from sensor acquisition to event detection
- **Battery efficiency**: Adaptive sampling rates and hardware batching to minimize power consumption
- **Accuracy**: Sensor fusion and filtering to reduce false positives
- **Configurability**: Tunable thresholds for different vehicle types and driving conditions
- **Reliability**: Graceful degradation when sensors are unavailable

The system is designed for Flutter applications and leverages platform-specific sensor APIs through Flutter plugins.

## Architecture

The system follows a pipeline architecture with the following major components:

```
[Sensors] → [Sensor Manager] → [Filter] → [Sensor Fusion] → [Event Classifier] → [Event Logger]
                ↓                                                      ↓
         [Battery Optimizer]                              [Threshold Manager]
```

### Component Responsibilities

1. **Sensor Manager**: Interfaces with device sensors, manages sampling rates, handles sensor lifecycle
2. **Filter**: Applies Kalman or Complementary filtering to reduce noise in sensor data
3. **Sensor Fusion Module**: Combines accelerometer, gyroscope, and GPS data into unified motion representation
4. **Event Classifier**: Analyzes fused data against thresholds to detect unsafe driving behaviors
5. **Threshold Manager**: Stores and provides configurable detection thresholds
6. **Event Logger**: Persists detected events to local storage with comprehensive metadata
7. **Battery Optimizer**: Monitors device state and adjusts sampling rates to conserve power

### Data Flow

1. Sensor Manager acquires raw sensor samples at configured rates (typically 50-100 Hz for IMU, 1-5 Hz for GPS)
2. Raw samples are passed to Filter for noise reduction
3. Filtered samples are passed to Sensor Fusion Module
4. Sensor Fusion Module produces Fused_Data containing vehicle acceleration, velocity, and orientation
5. Event Classifier analyzes Fused_Data against thresholds from Threshold Manager
6. Detected events are sent to Event Logger for persistence
7. Battery Optimizer monitors motion patterns and adjusts Sensor Manager sampling rates

## Components and Interfaces

### Sensor Manager

**Responsibilities:**
- Initialize and manage accelerometer, gyroscope, and GPS sensors
- Sample sensors at configured rates
- Handle sensor availability changes
- Provide timestamped sensor samples to downstream components

**Interface:**

```dart
class SensorManager {
  // Initialize sensors with sampling configuration
  Future<void> initialize(SamplingConfig config);
  
  // Start sensor data acquisition
  Stream<SensorSample> startMonitoring();
  
  // Stop sensor data acquisition
  Future<void> stopMonitoring();
  
  // Update sampling rates (called by Battery Optimizer)
  void updateSamplingRates(SamplingConfig config);
  
  // Check sensor availability
  SensorAvailability getSensorStatus();
}

class SensorSample {
  final SensorType type; // accelerometer, gyroscope, gps
  final DateTime timestamp;
  final Vector3 data; // x, y, z for IMU; lat, lon, speed for GPS
}

class SamplingConfig {
  final int accelerometerHz;
  final int gyroscopeHz;
  final int gpsHz;
}
```

### Filter

**Responsibilities:**
- Apply noise reduction to sensor data
- Smooth data while preserving genuine events
- Maintain filter state across samples

**Filtering Approach:**
We'll use a **Complementary Filter** for sensor fusion (combining accelerometer and gyroscope for orientation) and a **Kalman Filter** for GPS velocity smoothing. The complementary filter is computationally efficient and suitable for real-time mobile applications.

**Complementary Filter:**
- Combines high-frequency gyroscope data with low-frequency accelerometer data
- Formula: `orientation = α * (orientation + gyroscope * dt) + (1 - α) * accelerometer`
- Typical α value: 0.96-0.98

**Kalman Filter for GPS:**
- State: [position, velocity]
- Measurement: GPS position and velocity
- Process noise accounts for vehicle dynamics
- Measurement noise accounts for GPS accuracy

**Interface:**

```dart
class Filter {
  // Initialize filter with noise parameters
  void initialize(FilterConfig config);
  
  // Process accelerometer sample
  Vector3 filterAccelerometer(Vector3 rawAccel, DateTime timestamp);
  
  // Process gyroscope sample
  Vector3 filterGyroscope(Vector3 rawGyro, DateTime timestamp);
  
  // Process GPS sample with Kalman filter
  GpsData filterGps(GpsData rawGps, DateTime timestamp);
  
  // Reset filter state (called on numerical instability)
  void reset();
}

class FilterConfig {
  final double complementaryAlpha; // 0.96-0.98
  final double kalmanProcessNoise;
  final double kalmanMeasurementNoise;
}
```

### Sensor Fusion Module

**Responsibilities:**
- Combine filtered sensor data into unified representation
- Compute vehicle acceleration in global frame
- Compute vehicle orientation (pitch, roll, yaw)
- Compute vehicle velocity
- Handle missing sensor data gracefully

**Fusion Algorithm:**
1. Use complementary filter output for device orientation
2. Rotate accelerometer data from device frame to global frame using orientation
3. Subtract gravity vector to get vehicle acceleration
4. Use GPS velocity when available, otherwise integrate acceleration
5. Compute lateral acceleration for turn detection

**Interface:**

```dart
class SensorFusionModule {
  // Process new filtered sensor data
  FusedData? fuse({
    Vector3? filteredAccel,
    Vector3? filteredGyro,
    GpsData? filteredGps,
    DateTime timestamp,
  });
}

class FusedData {
  final DateTime timestamp;
  final Vector3 acceleration; // m/s² in global frame (forward, lateral, vertical)
  final Orientation orientation; // pitch, roll, yaw in radians
  final double velocity; // m/s
  final GpsCoordinates? location;
}

class Orientation {
  final double pitch;
  final double roll;
  final double yaw;
}
```

### Event Classifier

**Responsibilities:**
- Analyze fused data against thresholds
- Classify unsafe driving events
- Compute event severity and duration
- Emit detected events

**Classification Logic:**

```
Harsh Braking:
  - Condition: acceleration.forward < -threshold_harsh_braking
  - Severity: |acceleration.forward| / threshold_harsh_braking

Rapid Acceleration:
  - Condition: acceleration.forward > threshold_rapid_accel
  - Severity: acceleration.forward / threshold_rapid_accel

Sharp Turn:
  - Condition: |acceleration.lateral| > threshold_sharp_turn
  - Severity: |acceleration.lateral| / threshold_sharp_turn

Speeding:
  - Condition: velocity > threshold_speed_limit
  - Severity: (velocity - threshold_speed_limit) / threshold_speed_limit

Aggressive Lane Change:
  - Condition: |acceleration.lateral| > threshold_lane_change AND 
               acceleration.forward > threshold_lane_change_forward
  - Severity: max(lateral_severity, forward_severity)
```

**Interface:**

```dart
class EventClassifier {
  EventClassifier(ThresholdManager thresholdManager);
  
  // Analyze fused data and return detected event (if any)
  DrivingEvent? classify(FusedData data);
}

class DrivingEvent {
  final EventType type;
  final DateTime timestamp;
  final GpsCoordinates? location;
  final Severity severity;
  final Duration duration;
  final Map<String, double> sensorValues; // acceleration, velocity, etc.
  final String sessionId;
}

enum EventType {
  harshBraking,
  rapidAcceleration,
  sharpTurn,
  speeding,
  aggressiveLaneChange,
}

enum Severity {
  low,    // 1.0x - 1.5x threshold
  medium, // 1.5x - 2.0x threshold
  high,   // > 2.0x threshold
}
```

### Threshold Manager

**Responsibilities:**
- Store configurable thresholds for each event type
- Validate threshold values
- Persist and load configurations
- Provide thread-safe access to thresholds

**Default Thresholds:**
- Harsh Braking: -4.0 m/s² (approximately 0.4g deceleration)
- Rapid Acceleration: 3.0 m/s² (approximately 0.3g acceleration)
- Sharp Turn: 4.0 m/s² lateral (approximately 0.4g lateral)
- Speeding: Configurable per region (default 120 km/h)
- Aggressive Lane Change: 3.0 m/s² lateral + 2.0 m/s² forward

**Interface:**

```dart
class ThresholdManager {
  // Load thresholds from storage
  Future<void> initialize();
  
  // Get current thresholds
  Thresholds getThresholds();
  
  // Update thresholds with validation
  Future<void> updateThresholds(Thresholds newThresholds);
  
  // Reset to defaults
  Future<void> resetToDefaults();
}

class Thresholds {
  final double harshBraking; // m/s² (negative)
  final double rapidAcceleration; // m/s²
  final double sharpTurn; // m/s² lateral
  final double speedLimit; // m/s
  final double aggressiveLaneChangeLateral; // m/s²
  final double aggressiveLaneChangeForward; // m/s²
  
  // Validation: ensure values are within safe ranges
  bool validate();
}
```

### Event Logger

**Responsibilities:**
- Persist detected events to local storage
- Buffer events in memory on storage failure
- Support querying events by various criteria
- Export events in JSON format

**Storage Schema:**

```json
{
  "event_id": "uuid",
  "session_id": "uuid",
  "type": "harsh_braking | rapid_acceleration | sharp_turn | speeding | aggressive_lane_change",
  "timestamp": "ISO8601 datetime",
  "location": {
    "latitude": 0.0,
    "longitude": 0.0
  },
  "severity": "low | medium | high",
  "duration_ms": 0,
  "sensor_values": {
    "acceleration_forward": 0.0,
    "acceleration_lateral": 0.0,
    "acceleration_vertical": 0.0,
    "velocity": 0.0,
    "pitch": 0.0,
    "roll": 0.0,
    "yaw": 0.0
  }
}
```

**Interface:**

```dart
class EventLogger {
  // Initialize storage
  Future<void> initialize();
  
  // Log a detected event
  Future<void> logEvent(DrivingEvent event);
  
  // Query events
  Future<List<DrivingEvent>> queryEvents({
    DateTime? startDate,
    DateTime? endDate,
    EventType? type,
    Severity? severity,
    String? sessionId,
  });
  
  // Export events as JSON
  Future<String> exportEventsJson({
    DateTime? startDate,
    DateTime? endDate,
  });
  
  // Delete old events (for storage management)
  Future<void> deleteEventsBefore(DateTime date);
}
```

### Battery Optimizer

**Responsibilities:**
- Monitor device battery level and motion state
- Adjust sensor sampling rates based on conditions
- Use hardware sensor batching when available
- Minimize CPU wake cycles

**Optimization Strategy:**

1. **Motion-based adaptation:**
   - Stationary (< 0.5 m/s² for 30s): Reduce to 10 Hz IMU, 0.2 Hz GPS
   - Moving: Normal rates (50-100 Hz IMU, 1-5 Hz GPS)

2. **Battery-based adaptation:**
   - Battery > 15%: Normal rates
   - Battery ≤ 15%: Reduce rates by 50%

3. **Hardware batching:**
   - Batch sensor samples (e.g., 50 samples at a time)
   - Process batches to reduce CPU wake frequency
   - Typical batch interval: 500ms - 1000ms

4. **Sensor prioritization:**
   - GPS is most power-hungry: reduce first
   - Accelerometer is essential: reduce last

**Interface:**

```dart
class BatteryOptimizer {
  BatteryOptimizer(SensorManager sensorManager);
  
  // Start monitoring battery and motion
  void start();
  
  // Stop monitoring
  void stop();
  
  // Called when battery level changes
  void onBatteryLevelChanged(double level);
  
  // Called when motion state changes
  void onMotionStateChanged(MotionState state);
}

enum MotionState {
  stationary,
  moving,
}
```

## Data Models

### Core Data Structures

**Vector3:**
```dart
class Vector3 {
  final double x;
  final double y;
  final double z;
  
  Vector3(this.x, this.y, this.z);
  
  // Vector operations
  double magnitude();
  Vector3 normalize();
  Vector3 operator +(Vector3 other);
  Vector3 operator -(Vector3 other);
  Vector3 operator *(double scalar);
}
```

**GpsCoordinates:**
```dart
class GpsCoordinates {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy; // meters
  
  GpsCoordinates({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
  });
}
```

**GpsData:**
```dart
class GpsData {
  final GpsCoordinates coordinates;
  final double speed; // m/s
  final double? bearing; // degrees
  final DateTime timestamp;
  
  GpsData({
    required this.coordinates,
    required this.speed,
    this.bearing,
    required this.timestamp,
  });
}
```

### Sampling Rate Recommendations

Based on vehicle dynamics and mobile device capabilities:

**Normal Operation:**
- Accelerometer: 50-100 Hz (sufficient for detecting rapid changes)
- Gyroscope: 50-100 Hz (matches accelerometer for fusion)
- GPS: 1-5 Hz (limited by GPS update rate)

**Power Saving (Stationary):**
- Accelerometer: 10 Hz (detect motion resumption)
- Gyroscope: 10 Hz
- GPS: 0.2 Hz (every 5 seconds)

**Low Battery Mode:**
- Accelerometer: 25-50 Hz
- Gyroscope: 25-50 Hz
- GPS: 0.5-1 Hz

**Rationale:**
- Vehicle dynamics typically occur at < 10 Hz
- Nyquist theorem requires 2x sampling (20 Hz minimum)
- Higher rates (50-100 Hz) provide margin for filtering and noise reduction
- GPS updates are inherently slow (1-10 Hz typical)


## Correctness Properties

A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.

### Property Reflection

After analyzing all acceptance criteria, I identified several opportunities to consolidate redundant properties:

- Requirements 1.2, 1.3, 1.4 all test sampling rate accuracy for different sensors → Combined into Property 1
- Requirements 4.1-4.5 all test threshold-based classification → Combined into Property 7
- Requirements 5.1-5.5 all test threshold storage → Combined into Property 10
- Requirements 9.1-9.4 all test query filtering → Combined into Property 16
- Requirements 3.1, 3.2 both test filtering → Combined into Property 4

This consolidation reduces redundancy while maintaining comprehensive coverage of all testable requirements.

### Properties

Property 1: Sensor sampling rate accuracy
*For any* configured sampling rate and sensor type, the actual sampling intervals should match the configured rate within ±10% tolerance over a 10-second monitoring period.
**Validates: Requirements 1.2, 1.3, 1.4**

Property 2: Sensor failure graceful degradation
*For any* sensor failure scenario (accelerometer, gyroscope, or GPS unavailable), the system should log the failure and continue monitoring with remaining available sensors without crashing.
**Validates: Requirements 1.5, 12.4**

Property 3: Timestamp precision
*For any* sensor sample produced by the system, the timestamp should have millisecond precision (timestamp granularity ≤ 1ms).
**Validates: Requirements 1.6**

Property 4: Filtering reduces noise
*For any* raw sensor data stream with injected high-frequency noise (> 20 Hz), the filtered output should have reduced noise amplitude (measured by standard deviation) compared to the raw input while preserving low-frequency components (< 10 Hz).
**Validates: Requirements 3.1, 3.2, 3.3**

Property 5: Fusion produces output for valid inputs
*For any* valid combination of filtered sensor samples (at least accelerometer data present), the Sensor Fusion Module should produce FusedData output with non-null acceleration and orientation fields.
**Validates: Requirements 2.1**

Property 6: Orientation values in valid ranges
*For any* FusedData output, the orientation values should be within valid ranges: pitch ∈ [-π/2, π/2], roll ∈ [-π, π], yaw ∈ [-π, π].
**Validates: Requirements 2.3**

Property 7: Threshold-based event classification
*For any* FusedData where a specific acceleration or velocity component exceeds its corresponding threshold, the Event Classifier should produce a DrivingEvent with the correct EventType matching the exceeded threshold.
**Validates: Requirements 4.1, 4.2, 4.3, 4.4, 4.5**

Property 8: Event severity computation
*For any* detected DrivingEvent, the severity level should correctly reflect the magnitude of threshold exceedance: low (1.0x-1.5x), medium (1.5x-2.0x), high (>2.0x).
**Validates: Requirements 4.6**

Property 9: Velocity fallback when GPS unavailable
*For any* sequence of sensor samples where GPS data is absent but accelerometer data is present, the Sensor Fusion Module should still produce FusedData with a non-null velocity field estimated from acceleration integration.
**Validates: Requirements 2.5**

Property 10: Threshold persistence round-trip
*For any* valid Thresholds configuration, saving the configuration and then loading it should produce an equivalent Thresholds object with all values matching within floating-point precision.
**Validates: Requirements 5.1, 5.2, 5.3, 5.4, 5.5, 11.1, 11.2**

Property 11: Threshold validation rejects invalid values
*For any* Thresholds object with values outside safe operational ranges (e.g., negative speed limits, zero acceleration thresholds), the validation should fail and the update should be rejected.
**Validates: Requirements 5.6**

Property 12: Threshold updates apply immediately
*For any* threshold update operation, subsequent event classifications should use the new threshold values without requiring system restart.
**Validates: Requirements 5.7**

Property 13: Event logging persistence
*For any* DrivingEvent passed to the Event Logger, querying the logger immediately after should return an event with matching type, timestamp, and location.
**Validates: Requirements 6.1**

Property 14: Event completeness
*For any* logged DrivingEvent, all required fields should be present and non-null: event_id, session_id, type, timestamp, severity, duration_ms, and sensor_values map.
**Validates: Requirements 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8**

Property 15: Event buffering on storage failure
*For any* storage write failure, events should be buffered in memory, and subsequent successful storage operations should persist all buffered events.
**Validates: Requirements 6.9**

Property 16: Query filtering correctness
*For any* query with specific filters (date range, event type, severity, session ID), all returned events should satisfy the filter criteria, and no events satisfying the criteria should be omitted.
**Validates: Requirements 9.1, 9.2, 9.3, 9.4**

Property 17: Query result ordering
*For any* query result containing multiple events, the events should be sorted by timestamp in descending order (newest first).
**Validates: Requirements 9.5**

Property 18: JSON export round-trip
*For any* set of logged events, exporting to JSON and then parsing the JSON should produce equivalent event objects with all fields preserved.
**Validates: Requirements 9.6**

Property 19: Battery-based sampling rate adjustment
*For any* battery level below 15%, the sensor sampling rates should be reduced to 50% of normal rates within 1 second of the battery level change.
**Validates: Requirements 7.6**

Property 20: Motion-based sampling rate adjustment
*For any* motion state change (stationary ↔ moving), the Battery Optimizer should adjust sampling rates to the appropriate configuration within 1 second.
**Validates: Requirements 7.1**

Property 21: Shutdown flushes buffered events
*For any* monitoring session with buffered events in memory, stopping monitoring should persist all buffered events to storage before completing.
**Validates: Requirements 10.3**

Property 22: Invalid sensor data handling
*For any* sensor sample with invalid values (NaN, Infinity, or out-of-physical-range values), the system should discard the sample and continue processing subsequent samples without crashing.
**Validates: Requirements 12.1**

Property 23: Storage management when full
*For any* storage full condition, attempting to log a new event should succeed by deleting the oldest event and then persisting the new event.
**Validates: Requirements 12.3**

Property 24: Configuration corruption recovery
*For any* corrupted threshold configuration file, loading the configuration should detect the corruption and initialize with safe default values instead of crashing.
**Validates: Requirements 11.4**

Property 25: Timestamp alignment in fusion
*For any* FusedData output, the timestamp should match the timestamp of the most recent sensor sample used in the fusion computation within 10ms tolerance.
**Validates: Requirements 2.6**

Property 26: Filter processing latency
*For any* sensor sample, the filter should produce filtered output within 100 milliseconds of receiving the input.
**Validates: Requirements 3.4**

Property 27: End-to-end processing latency
*For any* sensor sample that triggers an event, the time from sensor acquisition to event detection should be less than 200 milliseconds.
**Validates: Requirements 8.1**

Property 28: Classification latency
*For any* FusedData that exceeds a threshold, the Event Classifier should produce a DrivingEvent within 50 milliseconds.
**Validates: Requirements 8.2**

## Error Handling

The system implements multiple layers of error handling to ensure resilience:

### Sensor Layer Errors
- **Sensor unavailable**: Log error, continue with available sensors, notify user if all sensors fail
- **Invalid sensor values**: Discard sample, continue processing
- **Sensor permission denied**: Notify user, disable monitoring

### Processing Layer Errors
- **Filter numerical instability**: Reset filter state, log occurrence, continue processing
- **Fusion computation errors**: Skip fusion for current sample, continue with next sample
- **Classification errors**: Log error, skip event detection for current sample

### Storage Layer Errors
- **Write failure**: Buffer events in memory (up to 1000 events), retry on next event
- **Storage full**: Delete oldest events to make space
- **Corruption detected**: Revert to defaults, log error
- **Read failure**: Return empty result set, log error

### Battery and Resource Errors
- **Low battery**: Reduce sampling rates, notify user
- **Low memory**: Reduce event buffer size, increase flush frequency
- **CPU thermal throttling**: Reduce sampling rates temporarily

### Recovery Strategies
- **Graceful degradation**: Continue operation with reduced functionality
- **Automatic retry**: Retry failed operations with exponential backoff
- **State reset**: Reset component state on unrecoverable errors
- **User notification**: Inform user of critical errors requiring intervention

## Testing Strategy

The testing strategy employs a dual approach combining unit tests and property-based tests to ensure comprehensive coverage.

### Unit Testing

Unit tests focus on:
- **Specific examples**: Concrete scenarios demonstrating correct behavior
- **Edge cases**: Boundary conditions and special cases
- **Integration points**: Component interactions and data flow
- **Error conditions**: Specific error scenarios and recovery

Example unit tests:
- Sensor Manager initializes all three sensors successfully
- Filter handles zero-velocity stationary case correctly
- Event Classifier detects harsh braking at exactly threshold value
- Event Logger handles storage full condition
- Battery Optimizer reduces rates when battery drops to 14%
- Threshold Manager loads default values on first run
- System pauses monitoring when all sensors fail

### Property-Based Testing

Property-based tests validate universal properties across randomized inputs. We'll use the **fast_check** library for Dart/Flutter (or **test_check** if available).

**Configuration:**
- Minimum 100 iterations per property test
- Each test tagged with: **Feature: vehicle-telemetry-unsafe-driving-detection, Property N: [property text]**
- Generators for: Vector3, GpsData, SensorSample, FusedData, Thresholds, DrivingEvent

**Property Test Coverage:**
- Properties 1-28 as defined in Correctness Properties section
- Each property implemented as a single property-based test
- Generators produce valid and edge-case inputs
- Shrinking enabled to find minimal failing cases

**Generator Examples:**

```dart
// Generate random Vector3 with realistic vehicle acceleration ranges
Arbitrary<Vector3> arbVector3() => 
  Arbitrary.combine3(
    Arbitrary.double(min: -20.0, max: 20.0), // m/s²
    Arbitrary.double(min: -20.0, max: 20.0),
    Arbitrary.double(min: -20.0, max: 20.0),
    (x, y, z) => Vector3(x, y, z),
  );

// Generate random FusedData
Arbitrary<FusedData> arbFusedData() =>
  Arbitrary.combine5(
    Arbitrary.dateTime(),
    arbVector3(),
    arbOrientation(),
    Arbitrary.double(min: 0.0, max: 50.0), // velocity m/s
    arbGpsCoordinates().nullable(),
    (ts, accel, orient, vel, loc) => FusedData(
      timestamp: ts,
      acceleration: accel,
      orientation: orient,
      velocity: vel,
      location: loc,
    ),
  );
```

**Test Execution:**
- Run property tests in CI/CD pipeline
- Fail build on any property violation
- Log failing examples for debugging
- Re-run with same seed for reproducibility

### Integration Testing

Integration tests verify end-to-end flows:
- Complete monitoring session from start to stop
- Event detection and logging pipeline
- Configuration persistence across app restarts
- Battery optimization triggering
- Multi-sensor fusion with real sensor data patterns

### Performance Testing

Performance tests validate latency requirements:
- Measure sensor-to-event latency (< 200ms)
- Measure filter processing time (< 100ms)
- Measure classification time (< 50ms)
- Measure battery consumption over 1-hour session
- Measure storage I/O performance

### Test Organization

```
test/
  unit/
    sensor_manager_test.dart
    filter_test.dart
    sensor_fusion_test.dart
    event_classifier_test.dart
    threshold_manager_test.dart
    event_logger_test.dart
    battery_optimizer_test.dart
  
  property/
    sensor_properties_test.dart      # Properties 1-3
    filtering_properties_test.dart   # Properties 4, 26
    fusion_properties_test.dart      # Properties 5, 6, 9, 25
    classification_properties_test.dart  # Properties 7, 8, 27, 28
    threshold_properties_test.dart   # Properties 10, 11, 12, 24
    logging_properties_test.dart     # Properties 13, 14, 15, 23
    query_properties_test.dart       # Properties 16, 17, 18
    battery_properties_test.dart     # Properties 19, 20
    resilience_properties_test.dart  # Properties 2, 21, 22
  
  integration/
    end_to_end_test.dart
    monitoring_session_test.dart
    configuration_persistence_test.dart
  
  performance/
    latency_test.dart
    battery_test.dart
    throughput_test.dart
```

### Testing Best Practices

1. **Property tests handle broad input coverage**: Don't write many unit tests for variations—let property tests cover the input space
2. **Unit tests for specific scenarios**: Focus on concrete examples, edge cases, and integration points
3. **Tag all property tests**: Include feature name and property number for traceability
4. **Use realistic generators**: Generate data that reflects real-world vehicle dynamics
5. **Test error paths**: Ensure error handling is covered by both unit and property tests
6. **Measure coverage**: Aim for >90% code coverage combining both test types
7. **Run tests in CI**: Fail builds on test failures or property violations
