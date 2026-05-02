import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  static const forecastButtonElevation = 1.5;
  static const forecastButtonShadowColor = Color.fromRGBO(0, 0, 0, 0.2);
  static const forecastButtonPadding = EdgeInsets.all(10);
  static const forecastButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static TextStyle? _forecastButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium;
  }

  static ButtonStyle forecastRangeButton(
    BuildContext context, {
    required bool isSelected,
  }) {
    return FilledButton.styleFrom(
      elevation: forecastButtonElevation,
      shadowColor: forecastButtonShadowColor,
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

  static ButtonStyle customDateRangeButton(
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
}
