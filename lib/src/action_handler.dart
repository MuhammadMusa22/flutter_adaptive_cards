import 'package:flutter/material.dart';

class DefaultAdaptiveCardHandlers extends InheritedWidget {
  final Function(Map map) onSubmit;
  final Function(String url) onOpenUrl;

  DefaultAdaptiveCardHandlers({
    Key? key,
    required this.onSubmit,
    required this.onOpenUrl,
    required Widget child,
  }) : super(key: key, child: child);

  static DefaultAdaptiveCardHandlers? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DefaultAdaptiveCardHandlers>();
  }

  @override
  bool updateShouldNotify(DefaultAdaptiveCardHandlers oldWidget) =>
      oldWidget.onSubmit != onSubmit || oldWidget.onOpenUrl != onOpenUrl;
}
