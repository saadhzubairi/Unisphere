import 'package:flutter/material.dart';
import 'package:unione/unisphere_theme.dart';

class IconWBackground extends StatelessWidget {
  const IconWBackground({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        splashColor: Theme.of(context).splashColor,
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(6), child: Icon(icon, size: 22)),
      ),
    );
  }
}

class IconWBorder extends StatelessWidget {
  const IconWBorder({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: Colors.indigo,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
            color: Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 22,
          ),
        ),
      ),
    );
  }
}
