import 'package:flutter/material.dart';

class ForecastRangeSelector extends StatelessWidget {
  const ForecastRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {}
    return Row(
      children: <Widget>[
        FilledButton.tonal(
          onPressed: onPressed,
          child: const Text('3 j. passés'),
        ),
        FilledButton.tonal(
          onPressed: onPressed,
          child: const Text("Aujourd'hui"),
        ),
        FilledButton.tonal(
          onPressed: onPressed,
          child: const Text('3 prochains j.'),
        ),
        FilledButton.tonal(
          onPressed: onPressed,
          child: const Text('7 prochains j.'),
        ),
        FilledButton.tonal(
          onPressed: onPressed,
          child: const Text('Tout'),
        ),
      ],
    );
  }
}
