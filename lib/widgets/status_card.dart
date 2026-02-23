import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final bool isMonitoring;
  final String message;

  const StatusCard({
    super.key,
    required this.isMonitoring,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isMonitoring ? Colors.green[50] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              isMonitoring ? Icons.sensors : Icons.sensors_off,
              size: 48,
              color: isMonitoring ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
