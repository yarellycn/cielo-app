import 'package:cielo_app/models/forecast_range.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateRangeButton extends StatelessWidget {
  final ForecastRange selectedRange;
  final DateTimeRange? selectedCustomRange;
  final ValueChanged<DateTimeRange> onCustomSelectedRange;

  const CustomDateRangeButton({
    super.key,
    required this.selectedRange,
    required this.selectedCustomRange,
    required this.onCustomSelectedRange,
  });

  @override
  Widget build(BuildContext context) {
    final customRangeButtonKey = GlobalKey();
    final datePickerController = DateRangePickerController();
    final today = DateUtils.dateOnly(DateTime.now());
    final formatter = DateFormat('dd/MM/yy');

    final dateRange = switch (selectedRange) {
      ForecastRange.past3Days => DateTimeRange(
        start: today.subtract(const Duration(days: 3)),
        end: today,
      ),
      ForecastRange.today => DateTimeRange(start: today, end: today),
      ForecastRange.next3Days => DateTimeRange(
        start: today,
        end: today.add(const Duration(days: 3)),
      ),
      ForecastRange.next7Days => DateTimeRange(
        start: today,
        end: today.add(const Duration(days: 7)),
      ),
      ForecastRange.all => DateTimeRange(
        start: today.subtract(const Duration(days: 3)),
        end: today.add(const Duration(days: 7)),
      ),
      ForecastRange.custom =>
        selectedCustomRange ?? DateTimeRange(start: today, end: today),
    };

    final label =
        '${formatter.format(dateRange.start)} - ${formatter.format(dateRange.end)}';

    return FilledButton.tonal(
      key: customRangeButtonKey,
      onPressed: () async {
        final colorScheme = Theme.of(context).colorScheme;

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
                        controller: datePickerController,
                        headerHeight: 65.00,
                        headerStyle: DateRangePickerHeaderStyle(
                          backgroundColor: colorScheme.secondaryContainer,
                          textStyle: TextStyle(fontWeight: .bold),
                        ),
                        selectionMode: DateRangePickerSelectionMode.range,
                        minDate: today.subtract(const Duration(days: 15)),
                        maxDate: today.add(const Duration(days: 14)),
                        showNavigationArrow: true,
                        showActionButtons: true,
                        initialSelectedRange: PickerDateRange(
                          dateRange.start,
                          dateRange.end,
                        ),
                        backgroundColor: Colors.white,
                        onSelectionChanged: (args) {
                          final currentPickerRange = args.value;

                          if (currentPickerRange is PickerDateRange &&
                              currentPickerRange.startDate != null &&
                              currentPickerRange.endDate != null) {
                            final dayCount =
                                currentPickerRange.endDate!
                                    .difference(currentPickerRange.startDate!)
                                    .inDays +
                                1;

                            if (dayCount > 14) {
                              datePickerController.selectedRange =
                                  PickerDateRange(
                                    currentPickerRange.startDate,
                                    currentPickerRange.startDate!.add(
                                      const Duration(days: 14),
                                    ),
                                  );
                            }
                          }
                        },
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

        onCustomSelectedRange(
          DateTimeRange(
            start: DateUtils.dateOnly(selectedDateRange.start),
            end: DateUtils.dateOnly(selectedDateRange.end),
          ),
        );
      },
      child: Text(label),
    );
  }
}
