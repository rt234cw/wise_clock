import 'package:flutter/material.dart';

class Menu {
  final String title;
  final String route;
  final IconData iconData;

  const Menu({
    required this.title,
    required this.route,
    required this.iconData,
  });
}

List<Menu> bottomNavItems = [
  Menu(title: 'landing', route: '/', iconData: Icons.home_rounded),
  Menu(title: 'history', route: '/history', iconData: Icons.history_rounded),
  Menu(title: 'profile', route: '/profile', iconData: Icons.settings_rounded),
];
