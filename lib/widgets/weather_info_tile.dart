import 'package:flutter/material.dart';

/// Weather information tile with label and the associated value underneath it.
class WeatherInfoTile extends StatelessWidget {
  final String title;
  final String information;
  final IconData weatherIcon;

  /// Creates a weather information tile.
  const WeatherInfoTile({
    super.key,
    required this.title,
    required this.information,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 9.5,
        children: [
          Icon(weatherIcon, color: Colors.white, size: 15),
          Column(
        mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: .start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              information,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
