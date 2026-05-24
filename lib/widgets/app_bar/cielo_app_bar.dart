import 'package:cielo_app/models/city.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/app_bar/city_search_bar.dart';
import 'package:flutter/material.dart';

class CieloAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<City>? onCitySelected;
  final double maxContentWidth;
  final double padding;
  final bool shouldStackSearchBar;

  const CieloAppBar({
    super.key,
    required this.maxContentWidth,
    required this.padding,
    this.onCitySelected,
    required this.shouldStackSearchBar,
  });

  static const _iconSize = 40.00;
  static const _logoWidth = 85.00;
  static const _logoHeight = 27.00;
  static const maxHeightSearchBar = 40.00;
  static const appBarContentHeight = _iconSize;
  static const stackedSpacing = 14.00;

  double get stackedBarHeight =>
      appBarContentHeight + stackedSpacing + maxHeightSearchBar + padding * 2;

  double get minHeightAppBar => appBarContentHeight + padding * 2;

  @override
  Size get preferredSize => Size.fromHeight(
    shouldStackSearchBar ? stackedBarHeight : minHeightAppBar,
  );

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    Widget buildAppBarContent(
      double contentSpacing, {
      bool flexibleText = false,
    }) {
      final logoAndText = Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/app_logo.png',
              width: _logoWidth,
              height: _logoHeight,
              cacheWidth: (_logoWidth * devicePixelRatio).round(),
              cacheHeight: (_logoHeight * devicePixelRatio).round(),
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
              isAntiAlias: true,
            ),
            Text(
              'HISTORIQUE ET PRÉVISIONS MÉTÉO',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.logoColor,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

      return Row(
        spacing: contentSpacing,
        children: [
          Image.asset(
            'assets/icons/app_icon.png',
            width: _iconSize,
            height: _iconSize,
            cacheWidth: (_iconSize * devicePixelRatio).round(),
            cacheHeight: (_iconSize * devicePixelRatio).round(),
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            isAntiAlias: true,
          ),
          flexibleText ? Flexible(child: logoAndText) : logoAndText,
        ],
      );
    }

    return AppBar(
      toolbarHeight: shouldStackSearchBar ? stackedBarHeight : minHeightAppBar,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      backgroundColor: AppColors.mainBackgroundColor,
      shape: const Border(
        bottom: BorderSide(color: AppColors.forecastButtonBackground),
      ),
      title: Align(
        alignment: shouldStackSearchBar
            ? Alignment.topCenter
            : Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barSpacing = shouldStackSearchBar ? 14.00 : 40.00;
                final logoSpacing = 20.00;

                if (shouldStackSearchBar) {
                  return Column(
                    crossAxisAlignment: .stretch,
                    spacing: barSpacing,
                    children: [
                      buildAppBarContent(logoSpacing, flexibleText: true),
                      CitySearchBar(
                        onCitySelected: onCitySelected,
                        maxBarHeight: maxHeightSearchBar,
                        expandToAvailableWidth: true,
                      ),
                    ],
                  );
                }
                return Row(
                  spacing: barSpacing,
                  children: [
                    buildAppBarContent(logoSpacing),
                    Flexible(
                      child: CitySearchBar(
                        onCitySelected: onCitySelected,
                        maxBarHeight: maxHeightSearchBar,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
