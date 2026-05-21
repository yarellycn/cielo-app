import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  static const forecastButtonElevation = 1.5;
  static const forecastButtonShadowColor = Color.fromRGBO(0, 0, 0, 0.2);
  static const forecastButtonPadding = EdgeInsets.all(10);
  static const forecastButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const hourlyMetricButtonPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const hourlyMetricButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  static TextStyle? _forecastButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }

  static ButtonStyle forecastRangeButton(
    BuildContext context, {
    required bool isSelected,
  }) {
    return FilledButton.styleFrom(
      elevation: forecastButtonElevation,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      backgroundColor: isSelected
          ? AppColors.highlightedItemBackground
          : AppColors.forecastButtonBackground,
      foregroundColor: isSelected
          ? AppColors.highlightedItemText
          : AppColors.forecastButtonText,
      padding: forecastButtonPadding,
      side: BorderSide(
        color: isSelected
            ? AppColors.highlightedItemBorder
            : Colors.transparent,
      ),
      textStyle: isSelected
          ? _forecastButtonTextStyle(
              context,
            )?.copyWith(fontWeight: FontWeight.bold)
          : _forecastButtonTextStyle(context),
      shape: forecastButtonShape,
    );
  }

  static ButtonStyle dateRangePickerButton(
    BuildContext context, {
    required bool isSelected,
  }) {
    return FilledButton.styleFrom(
      elevation: forecastButtonElevation,
      shadowColor: forecastButtonShadowColor,
      backgroundColor: isSelected
          ? AppColors.highlightedItemBackground
          : Colors.white,
      foregroundColor: isSelected
          ? AppColors.highlightedItemText
          : Colors.black,
      padding: forecastButtonPadding,
      side: BorderSide(
        color: isSelected
            ? AppColors.highlightedItemBorder
            : AppColors.forecastButtonBackground,
      ),
      textStyle: isSelected
          ? _forecastButtonTextStyle(
              context,
            )?.copyWith(fontWeight: FontWeight.bold)
          : _forecastButtonTextStyle(context),
      shape: forecastButtonShape,
    );
  }

  static ButtonStyle hourlyMetricButton(
    BuildContext context, {
    required bool isSelected,
  }) {
    return FilledButton.styleFrom(
      shadowColor: Colors.transparent,
      backgroundColor: isSelected ? Colors.white : Colors.transparent,
      foregroundColor: isSelected ? Colors.black : AppColors.forecastButtonText,
      overlayColor: Colors.transparent,
      padding: hourlyMetricButtonPadding,
      minimumSize: const Size(0, 0),
      textStyle: isSelected
          ? _forecastButtonTextStyle(
              context,
            )?.copyWith(fontWeight: FontWeight.bold)
          : _forecastButtonTextStyle(context),
      shape: hourlyMetricButtonShape,
    );
  }
}
