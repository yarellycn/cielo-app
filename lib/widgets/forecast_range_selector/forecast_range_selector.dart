import 'package:cielo_app/enums/forecast_range.dart';
import 'package:cielo_app/theme/app_button_styles.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/forecast_range_selector/date_range_picker_button.dart';
import 'package:flutter/material.dart';

class ForecastRangeSelector extends StatelessWidget {
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;
  final ValueChanged<ForecastRange> onRangeSelected;
  final ValueChanged<DateTimeRange> onCustomSelectedRange;
  final bool shouldStackRangePicker;

  const ForecastRangeSelector({
    super.key,
    required this.selectedRange,
    required this.selectedCustomRange,
    required this.onRangeSelected,
    required this.onCustomSelectedRange,
    required this.shouldStackRangePicker,
  });

  @override
  Widget build(BuildContext context) {
    Widget rangeButton({required ForecastRange range, required String label}) {
      final isSelected = selectedRange == range;

      return FilledButton(
        style: AppButtonStyles.forecastRangeButton(
          context,
          isSelected: isSelected,
          shouldStackRangePicker: shouldStackRangePicker,
        ),
        onPressed: () => onRangeSelected(range),
        child: Text(label),
      );
    }

    Widget buildRangeButtonsContainer() {
      return Wrap(
        spacing: 8.00,
        runSpacing: 6,
        alignment: .center,
        children: <Widget>[
          rangeButton(range: ForecastRange.past3Days, label: '3 j. passés'),
          rangeButton(range: ForecastRange.today, label: "Aujourd'hui"),
          rangeButton(range: ForecastRange.next3Days, label: '3 prochains j.'),
          rangeButton(range: ForecastRange.next7Days, label: '7 prochains j.'),
          rangeButton(range: ForecastRange.all, label: 'Tout'),
        ],
      );
    }

    Widget buildRangePickerContainer() {
      return Row(
        mainAxisAlignment: shouldStackRangePicker ? .center : .start,
        spacing: 8.00,
        children: [
          Icon(
            Icons.date_range,
            size: 15.00,
            color: AppColors.forecastButtonText,
          ),
          Text('Intervalle:'),
          DateRangePickerButton(
            selectedRange: selectedRange,
            selectedCustomRange: selectedCustomRange,
            onCustomSelectedRange: onCustomSelectedRange,
          ),
        ],
      );
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: DefaultTextStyle.merge(
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.forecastButtonText),
        child: Padding(
          padding: EdgeInsets.all(15.00),
          child: shouldStackRangePicker
              ? Column(
                  spacing: 20.00,
                  children: [
                    buildRangeButtonsContainer(),
                    buildRangePickerContainer(),
                  ],
                )
              : Row(
                  spacing: 20.00,
                  children: [
                    buildRangeButtonsContainer(),
                    buildRangePickerContainer(),
                  ],
                ),
        ),
      ),
    );
  }
}
