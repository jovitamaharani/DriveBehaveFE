import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const SensorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}

class DataRow extends StatelessWidget {
  final String label;
  final double value;
  final int decimals;
  final String unit;
  final bool highlight;

  const DataRow({
    super.key,
    required this.label,
    required this.value,
    this.decimals = 2,
    this.unit = '',
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${value.toStringAsFixed(decimals)}$unit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class AccelerometerCard extends StatelessWidget {
  final Vector3D data;

  const AccelerometerCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SensorCard(
      title: 'Accelerometer (m/s²)',
      icon: Icons.speed,
      color: Colors.blue,
      children: [
        DataRow(label: 'X', value: data.x),
        DataRow(label: 'Y', value: data.y),
        DataRow(label: 'Z', value: data.z),
        DataRow(label: 'Total', value: data.magnitude, highlight: true),
      ],
    );
  }
}

class GyroscopeCard extends StatelessWidget {
  final Vector3D data;

  const GyroscopeCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SensorCard(
      title: 'Gyroscope (rad/s)',
      icon: Icons.rotate_right,
      color: Colors.orange,
      children: [
        DataRow(label: 'X', value: data.x),
        DataRow(label: 'Y', value: data.y),
        DataRow(label: 'Z', value: data.z),
        DataRow(label: 'Total', value: data.magnitude, highlight: true),
      ],
    );
  }
}

class GpsCard extends StatelessWidget {
  final GpsData data;

  const GpsCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SensorCard(
      title: 'GPS',
      icon: Icons.location_on,
      color: Colors.red,
      children: [
        DataRow(label: 'Latitude', value: data.latitude, decimals: 6),
        DataRow(label: 'Longitude', value: data.longitude, decimals: 6),
        DataRow(label: 'Speed', value: data.speed, unit: ' m/s'),
        DataRow(label: 'Altitude', value: data.altitude, unit: ' m'),
      ],
    );
  }
}
