import 'package:cielo_app/models/forecast_range.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateRangeButton extends StatelessWidget {
  final ValueChanged<ForecastRange> onRangeSelected;

  const CustomDateRangeButton({super.key, required this.onRangeSelected});

  @override
  Widget build(BuildContext context) {
    final customRangeButtonKey = GlobalKey();

    return FilledButton.tonal(
      key: customRangeButtonKey,
      onPressed: () async {
        final colorScheme = Theme.of(context).colorScheme;
        final today = DateTime.now();

        final buttonContext = customRangeButtonKey.currentContext;
        if (buttonContext == null) return;

        final renderBox = buttonContext.findRenderObject() as RenderBox;
        final buttonPosition = renderBox.localToGlobal(Offset.zero);
        final buttonSize = renderBox.size;

        final selectedDateRange = await showDialog<DateTimeRange>(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) {
            return Stack(
              children: [
                Positioned(
                  left: buttonPosition.dx,
                  top: buttonPosition.dy + buttonSize.height + 5,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: 300,
                      height: 350,
                      child: SfDateRangePicker(
                        headerHeight: 65.00,
                        headerStyle: DateRangePickerHeaderStyle(
                          backgroundColor: colorScheme.secondaryContainer,
                          textStyle: TextStyle(fontWeight: .bold),
                        ),
                        selectionMode: DateRangePickerSelectionMode.range,
                        minDate: today.subtract(const Duration(days: 15)),
                        maxDate: today.add(const Duration(days: 15)),
                        showNavigationArrow: true,
                        showActionButtons: true,
                        initialSelectedRange: PickerDateRange(
                          today,
                          today.add(const Duration(days: 3)),
                        ),
                        backgroundColor: Colors.white,
                        onSubmit: (value) {
                          if (value is PickerDateRange &&
                              value.startDate != null &&
                              value.endDate != null) {
                            Navigator.of(context).pop(
                              DateTimeRange(
                                start: value.startDate!,
                                end: value.endDate!,
                              ),
                            );
                          }
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (selectedDateRange == null) return;

        debugPrint('Start: ${selectedDateRange.start}');
        debugPrint('End: ${selectedDateRange.end}');
      },
      child: const Text('Choisir dates'),
    );
  }
}
