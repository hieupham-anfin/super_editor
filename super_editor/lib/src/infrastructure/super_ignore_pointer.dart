import 'package:flutter/material.dart';

class SuperIgnorePointer extends InheritedWidget {
  const SuperIgnorePointer({
    Key? key,
    required this.child,
    required this.onSpanTap,
    this.shouldIgnorePointer = true,
  }) : super(key: key, child: child);

  final Widget child;

  final void Function(String) onSpanTap;

  final shouldIgnorePointer;

  @override
  bool updateShouldNotify(covariant SuperIgnorePointer oldWidget) {
    return shouldIgnorePointer != oldWidget.shouldIgnorePointer;
  }
}
