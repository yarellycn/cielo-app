import 'package:flutter/material.dart';

class CieloAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CieloAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.cloud),
      backgroundColor: const Color.fromARGB(255, 15, 130, 207),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Cielo', overflow: TextOverflow.ellipsis),
          Text(
            'HISTORIQUE ET PRÉVISIONS MÉTÉO',
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
