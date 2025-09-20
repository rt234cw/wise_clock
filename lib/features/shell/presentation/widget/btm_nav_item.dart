import 'package:flutter/material.dart';

import 'package:wise_clock/features/shell/presentation/view/menu.dart';

import 'animdated_bar.dart';

class BtmNavItem extends StatelessWidget {
  const BtmNavItem({
    super.key,
    required this.navBar,
    required this.press,
    required this.selectedNav,
  });

  final Menu navBar;
  final VoidCallback press;

  final Menu selectedNav;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 48,
        child: Column(
          children: [
            AnimatedBar(
              isActive: selectedNav.title == navBar.title,
            ),
            Expanded(
              child: Icon(
                navBar.iconData,
                size: 40,
                color: selectedNav.title == navBar.title
                    ? Theme.of(context).colorScheme.primary
                    : const Color.fromARGB(255, 74, 74, 74),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
