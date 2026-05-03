import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CieloAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CieloAppBar({super.key});
  static const appBarHeight = 75.00;

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: appBarHeight,
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.00),
        child: Image.asset('assets/icons/app_icon.png', filterQuality: FilterQuality.medium,),
      ),
      backgroundColor: AppColors.mainBackgroundColor,
      shape: const Border(bottom: BorderSide(color: AppColors.forecastButtonBackground)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logos/app_logo.png', scale: 8.00, filterQuality: FilterQuality.medium,),
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
    );
  }
}
