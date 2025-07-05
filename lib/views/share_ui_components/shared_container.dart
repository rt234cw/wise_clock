import 'package:flutter/material.dart';

class SharedContainer extends StatelessWidget {
  final Widget child;
  const SharedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Use transparent to avoid background color issues
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 227, 231, 240),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
