import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CieloAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CieloAppBar({super.key});
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
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.00),
        child: Image.asset(
          'assets/icons/app_icon.png',
          width: _iconSize,
          height: _iconSize,
          cacheWidth: (_iconSize * devicePixelRatio).round(),
          cacheHeight: (_iconSize * devicePixelRatio).round(),
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          isAntiAlias: true,
        ),
      ),
      backgroundColor: AppColors.mainBackgroundColor,
      // backgroundColor: Colors.orange,
      shape: const Border(
        bottom: BorderSide(color: AppColors.forecastButtonBackground),
      ),
      title: Row(
        spacing: 20,
        children: [
          Column(
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.logoColor,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 40),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: .antiAlias,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher une ville...',
                    prefixIcon: const Icon(Icons.search),
                    hintStyle: TextStyle(color: AppColors.forecastButtonText),
                    prefixIconColor: AppColors.forecastButtonText,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
