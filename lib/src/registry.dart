import 'package:flutter/material.dart';

import 'elements/actions.dart';
import 'elements/base.dart';
import 'elements/basics.dart';
import 'elements/input.dart';
import 'flutter_adaptive_cards.dart';

typedef ElementCreator = Widget Function(Map<String, dynamic> map);

class CardRegistry {
  const CardRegistry({
    this.removedElements = const [],
    this.addedElements = const {},
    this.addedActions = const {},
  });

  final Map<String, ElementCreator> addedElements;
  final Map<String, ElementCreator> addedActions;
  final List<String> removedElements;

  Widget getElement(Map<String, dynamic> map) {
    final String stringType = map["type"] as String;

    if (removedElements.contains(stringType)) {
      return AdaptiveUnknown(
        type: stringType,
        adaptiveMap: map,
      );
    }

    if (addedElements.containsKey(stringType)) {
      return addedElements[stringType]!(map);
    } else {
      return getBaseElement(map);
    }
  }

  GenericAction? getGenericAction(
    Map<String, dynamic> map,
    RawAdaptiveCardState state,
  ) {
    final String stringType = map["type"] as String;

    switch (stringType) {
      case "Action.ShowCard":
        assert(false, "Action.ShowCard can only be used directly by the root card");
        return null;
      case "Action.OpenUrl":
        return GenericActionOpenUrl(map, state);
      case "Action.Submit":
        return GenericSubmitAction(map, state);
      default:
        assert(false, "No action found with type $stringType");
        return null;
    }
  }

  Widget getAction(Map<String, dynamic> map) {
    final String stringType = map["type"] as String;

    if (removedElements.contains(stringType)) {
      return AdaptiveUnknown(
        adaptiveMap: map,
        type: stringType,
      );
    }

    if (addedActions.containsKey(stringType)) {
      return addedActions[stringType]!(map);
    } else {
      return _getBaseAction(map);
    }
  }

  Widget getBaseElement(Map<String, dynamic> map) {
    final String stringType = map["type"] as String;

    switch (stringType) {
      case "Media":
        return AdaptiveMedia(adaptiveMap: map);
      case "Container":
        return AdaptiveContainer(adaptiveMap: map);
      case "TextBlock":
        return AdaptiveTextBlock(adaptiveMap: map);
      case "AdaptiveCard":
        return AdaptiveCardElement(adaptiveMap: map);
      case "ColumnSet":
        return AdaptiveColumnSet(adaptiveMap: map);
      case "Image":
        return AdaptiveImage(adaptiveMap: map);
      case "FactSet":
        return AdaptiveFactSet(adaptiveMap: map);
      case "ImageSet":
        return AdaptiveImageSet(adaptiveMap: map);
      case "Input.Text":
        return AdaptiveTextInput(adaptiveMap: map);
      case "Input.Number":
        return AdaptiveNumberInput(adaptiveMap: map);
      case "Input.Date":
        return AdaptiveDateInput(adaptiveMap: map);
      case "Input.Time":
        return AdaptiveTimeInput(adaptiveMap: map);
      case "Input.Toggle":
        return AdaptiveToggle(adaptiveMap: map);
      case "Input.ChoiceSet":
        return AdaptiveChoiceSet(adaptiveMap: map);
      default:
        return AdaptiveUnknown(
          adaptiveMap: map,
          type: stringType,
        );
    }
  }

  Widget _getBaseAction(
    Map<String, dynamic> map,
  ) {
    final String stringType = map["type"] as String;

    switch (stringType) {
      case "Action.ShowCard":
        return AdaptiveActionShowCard(adaptiveMap: map);
      case "Action.OpenUrl":
        return AdaptiveActionOpenUrl(adaptiveMap: map);
      case "Action.Submit":
        return AdaptiveActionSubmit(
          adaptiveMap: map,
          color: Colors.red,
        );
      default:
        return AdaptiveUnknown(
          adaptiveMap: map,
          type: stringType,
        );
    }
  }
}

class DefaultCardRegistry extends InheritedWidget {
  const DefaultCardRegistry({
    Key? key,
    required this.cardRegistry,
    required Widget child,
  }) : super(key: key, child: child);

  final CardRegistry cardRegistry;

  static CardRegistry? of(BuildContext context) {
    final DefaultCardRegistry? cardRegistry = context.dependOnInheritedWidgetOfExactType<DefaultCardRegistry>();
    return cardRegistry?.cardRegistry;
  }

  @override
  bool updateShouldNotify(DefaultCardRegistry oldWidget) => oldWidget.cardRegistry != cardRegistry;
}
