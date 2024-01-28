import 'package:flutter/material.dart';
import 'base.dart';
import 'basics.dart';

class IconButtonAction extends StatefulWidget with AdaptiveElementWidgetMixin {
  IconButtonAction({
    Key? key,
    required this.adaptiveMap,
    required this.onTapped,
  }) : super(key: key);

  final Map adaptiveMap;

  final VoidCallback onTapped;

  @override
  _IconButtonActionState createState() => _IconButtonActionState();
}

class _IconButtonActionState extends State<IconButtonAction> with AdaptiveActionMixin, AdaptiveElementMixin {
  String iconUrl='';

  @override
  void initState() {
    super.initState();
    iconUrl = adaptiveMap["iconUrl"];
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ElevatedButton(
      onPressed: onTapped,
      child: Text(title),
    );

    if (iconUrl != null) {
      result = ElevatedButton.icon(
        onPressed: onTapped,
        icon: Image.network(
          iconUrl,
          height: 36.0,
        ),
        label: Text(title),
      );
    }
    return result;
  }

  @override
  void onTapped() => widget.onTapped();
}

class AdaptiveActionShowCard extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveActionShowCard({Key? key,required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveActionShowCardState createState() => _AdaptiveActionShowCardState();
}

class _AdaptiveActionShowCardState extends State<AdaptiveActionShowCard> with AdaptiveActionMixin, AdaptiveElementMixin {
  @override
  void initState() {
    super.initState();

    Widget card = widgetState.cardRegistry.getElement(adaptiveMap["card"]);

    var _adaptiveCardElement = AdaptiveCardElementState.of(context);
    if (_adaptiveCardElement != null) {
      _adaptiveCardElement.registerCard(id, card);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTapped,
      child: Row(
        children: <Widget>[
          Text(title),
          AdaptiveCardElementState.of(context).currentCardId == id ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  @override
  void onTapped() {
    var _adaptiveCardElement = AdaptiveCardElementState.of(context);
    if (_adaptiveCardElement != null) {
      _adaptiveCardElement.showCard(id);
    }
  }
}

class AdaptiveActionSubmit extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveActionSubmit({Key? key,required this.adaptiveMap,required this.color}) : super(key: key);

  final Map adaptiveMap;

  // Native styling
  final Color color;

  @override
  _AdaptiveActionSubmitState createState() => _AdaptiveActionSubmitState();
}

class _AdaptiveActionSubmitState extends State<AdaptiveActionSubmit> with AdaptiveActionMixin, AdaptiveElementMixin {
  late GenericSubmitAction action;

  @override
  void initState() {
    super.initState();
    action = GenericSubmitAction(adaptiveMap, widgetState);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // color: new Color(0xFF1b4f80),
      // textColor: new Color(0xFF0088DB),
      onPressed: onTapped,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void onTapped() {
    action.tap();
  }
}

class AdaptiveActionOpenUrl extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveActionOpenUrl({Key? key,required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveActionOpenUrlState createState() => _AdaptiveActionOpenUrlState();
}

class _AdaptiveActionOpenUrlState extends State<AdaptiveActionOpenUrl> with AdaptiveActionMixin, AdaptiveElementMixin {
  late GenericActionOpenUrl action;
  late String iconUrl;

  @override
  void initState() {
    super.initState();

    action = GenericActionOpenUrl(adaptiveMap, widgetState);
    iconUrl = adaptiveMap["iconUrl"];
  }

  @override
  Widget build(BuildContext context) {
    // TODO
    return IconButtonAction(
      adaptiveMap: adaptiveMap,
      onTapped: onTapped,
    );
  }

  @override
  void onTapped() {
    action.tap();
  }
}
