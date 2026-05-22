import 'package:cielo_app/models/city.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:cielo_app/widgets/app_bar/city_search_bar.dart';
import 'package:flutter/material.dart';

class CieloAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<City>? onCitySelected;
  final double maxContentWidth;
  final double padding;

  const CieloAppBar({
    super.key,
    required this.maxContentWidth,
    required this.padding,
    this.onCitySelected,
  });
  static const appBarHeight = 75.00;
  static const _iconSize = 40.00;
  static const _logoWidth = 85.00;
  static const _logoHeight = 27.00;

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return AppBar(
      toolbarHeight: appBarHeight,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      backgroundColor: AppColors.mainBackgroundColor,
      // backgroundColor: Colors.orange,
      shape: const Border(
        bottom: BorderSide(color: AppColors.forecastButtonBackground),
      ),
      title: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              spacing: 20,
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
                Material(
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
                ),

                CitySearchBar(onCitySelected: onCitySelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
