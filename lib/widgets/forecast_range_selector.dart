import 'package:cielo_app/models/forecast_range.dart';
import 'package:cielo_app/widgets/custom_date_range_button.dart';
import 'package:flutter/material.dart';

class ForecastRangeSelector extends StatelessWidget {
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;
  final ValueChanged<ForecastRange> onRangeSelected;
  final ValueChanged<DateTimeRange> onCustomSelectedRange;

  const ForecastRangeSelector({
    super.key,
    required this.selectedRange,
    required this.selectedCustomRange,
    required this.onRangeSelected,
    required this.onCustomSelectedRange,
  });

  @override
  Widget build(BuildContext context) {
    Widget rangeButton({required ForecastRange range, required String label}) {
      final isSelected = selectedRange == range;

      if (isSelected) {
        return FilledButton(
          onPressed: () => onRangeSelected(range),
          child: Text(label),
        );
      }

      return FilledButton.tonal(
        onPressed: () => onRangeSelected(range),
        child: Text(label),
      );
    }

    return Row(
      crossAxisAlignment: .center,
      children: <Widget>[
        rangeButton(range: ForecastRange.past3Days, label: '3 j. passés'),
        rangeButton(range: ForecastRange.today, label: "Aujourd'hui"),
        rangeButton(range: ForecastRange.next3Days, label: '3 prochains j.'),
        rangeButton(range: ForecastRange.next7Days, label: '7 prochains j.'),
        rangeButton(range: ForecastRange.all, label: 'Tout'),
        Icon(Icons.date_range, size: 15.00),
        Text('Intervalle:'),
        CustomDateRangeButton(
          selectedRange: selectedRange,
          selectedCustomRange: selectedCustomRange,
          onCustomSelectedRange: onCustomSelectedRange,
        ),
      ],
    );
  }
}
