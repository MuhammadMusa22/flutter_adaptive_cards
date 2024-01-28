import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'additional.dart';
import 'base.dart';

// TODO add separator for each

class AdaptiveTextInput extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveTextInput({Key? key, required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;
  @override
  _AdaptiveTextInputState createState() => _AdaptiveTextInputState();
}

class _AdaptiveTextInputState extends State<AdaptiveTextInput>
    with AdaptiveTextualInputMixin, AdaptiveInputMixin, AdaptiveElementMixin {
  TextEditingController controller = TextEditingController();
  late bool isMultiline;
  late int maxLength;
  late TextInputType style;

  @override
  void initState() {
    super.initState();
    isMultiline = widget.adaptiveMap["isMultiline"] ?? false;
    maxLength = widget.adaptiveMap["maxLength"] ?? 0;
    style = loadTextInputType();
    controller.text = value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: widget.adaptiveMap,
      child: TextField(
        controller: controller,
        maxLength: maxLength == 0 ? null : maxLength,
        keyboardType: style,
        maxLines: isMultiline ? null : 1,
        decoration: InputDecoration(
          labelText: placeholder,
        ),
      ),
    );
  }

  @override
  void appendInput(Map map) {
    map[id] = controller.text;
  }

  TextInputType loadTextInputType() {
    /// Can be one of the following:
    /// - "text"
    /// - "tel"
    /// - "url"
    /// - "email"
    String style = widget.adaptiveMap["style"] ?? "text";
    switch (style) {
      case "text":
        return TextInputType.text;
      case "tel":
        return TextInputType.phone;
      case "url":
        return TextInputType.url;
      case "email":
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}

class AdaptiveNumberInput extends StatefulWidget
    with AdaptiveElementWidgetMixin {
  AdaptiveNumberInput({Key? key,required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;
  @override
  _AdaptiveNumberInputState createState() => _AdaptiveNumberInputState();
}

class _AdaptiveNumberInputState extends State<AdaptiveNumberInput>
    with AdaptiveTextualInputMixin, AdaptiveInputMixin, AdaptiveElementMixin {
  TextEditingController controller = TextEditingController();

  late var min;
  late var max;

  @override
  void initState() {
    super.initState();

    controller.text = value ?? '';
    min = widget.adaptiveMap?["min"];
    max = widget.adaptiveMap?["max"];
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: widget.adaptiveMap ?? {},
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        controller: controller,
        decoration: InputDecoration(
          labelText: placeholder,
        ),
      ),
    );
  }

  @override
  void appendInput(Map map) {
    map[id] = controller.text;
  }
}

class AdaptiveDateInput extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveDateInput({Key? key,required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;
  @override
  _AdaptiveDateInputState createState() => _AdaptiveDateInputState();
}

class _AdaptiveDateInputState extends State<AdaptiveDateInput>
    with AdaptiveTextualInputMixin, AdaptiveElementMixin, AdaptiveInputMixin {
  DateTime? selectedDateTime;
  DateTime? min;
  DateTime? max;

  @override
  void initState() {
    super.initState();

    try {
      selectedDateTime = DateTime.tryParse(value ?? '');
      min = DateTime.tryParse(widget.adaptiveMap?["min"] ?? '');
      max = DateTime.tryParse(widget.adaptiveMap?["max"] ?? '');
    } catch (formatException) {}
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: widget.adaptiveMap ?? {},
      child: ElevatedButton(
        onPressed: () async {
          // Implement date picker
        },
        child: Text(selectedDateTime == null
            ? placeholder ?? ''
            : selectedDateTime!.toIso8601String()),
      ),
    );
  }

  @override
  void appendInput(Map map) {
    map[id] = selectedDateTime?.toIso8601String();
  }
}

class AdaptiveTimeInput extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveTimeInput({Key? key,required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;
  @override
  _AdaptiveTimeInputState createState() => _AdaptiveTimeInputState();
}

class _AdaptiveTimeInputState extends State<AdaptiveTimeInput>
    with AdaptiveTextualInputMixin, AdaptiveElementMixin, AdaptiveInputMixin {
  TimeOfDay? selectedTime;
  TimeOfDay? min;
  TimeOfDay? max;

  @override
  void initState() {
    super.initState();

    selectedTime = parseTime(value) ?? TimeOfDay.now();
    min = parseTime(widget.adaptiveMap?["min"]) ?? TimeOfDay(minute: 0, hour: 0);
    max = parseTime(widget.adaptiveMap?["max"]) ?? TimeOfDay(minute: 59, hour: 23);
  }

  TimeOfDay? parseTime(String? time) {
    if (time == null) return null;
    List<String> times = time.split(":");
    assert(times.length == 2, "Invalid TimeOfDay format");
    return TimeOfDay(
      hour: int.parse(times[0]),
      minute: int.parse(times[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: widget.adaptiveMap ?? {},
      child: ElevatedButton(
        onPressed: () async {
          // Implement time picker
        },
        child: Text(selectedTime == null
            ? placeholder ?? ''
            : selectedTime!.format(context)),
      ),
    );
  }

  @override
  void appendInput(Map map) {
    map[id] = selectedTime?.toString();
  }
}

class AdaptiveToggle extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveToggle({Key? key,required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;
  @override
  _AdaptiveToggleState createState() => _AdaptiveToggleState();
}

class _AdaptiveToggleState extends State<AdaptiveToggle>
    with AdaptiveInputMixin, AdaptiveElementMixin {
  bool boolValue = false;

  String? valueOff;
  String? valueOn;

  String? title;

  @override
  void initState() {
    super.initState();

    valueOff = widget.adaptiveMap?["valueOff"] ?? "false";
    valueOn = widget.adaptiveMap?["valueOn"] ?? "true";
    boolValue = value == valueOn;
    title = widget.adaptiveMap?["title"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: widget.adaptiveMap ?? {},
      child: Row(
        children: <Widget>[
          Switch(
            value: boolValue,
            onChanged: (newValue) {
              setState(() {
                boolValue = newValue;
              });
            },
          ),
          Expanded(
            child: Text(title ?? ''),
          ),
        ],
      ),
    );
  }

  @override
  void appendInput(Map map) {
    map[id] = boolValue ? valueOn : valueOff;
  }
}

class AdaptiveChoiceSet extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveChoiceSet({Key? key,required this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;
  @override
  _AdaptiveChoiceSetState createState() => _AdaptiveChoiceSetState();
}

class _AdaptiveChoiceSetState extends State<AdaptiveChoiceSet>
    with AdaptiveInputMixin, AdaptiveElementMixin {
  // Map from title to value
  Map<String, String> choices = {};
  // Contains the values (the things to send as request)
  Set<String> _selectedChoice = {};

  bool isCompact = false;
  bool isMultiSelect = false;

  @override
  void initState() {
    super.initState();
    if (widget.adaptiveMap != null && widget.adaptiveMap!["choices"] != null) {
      for (Map map in widget.adaptiveMap!["choices"]) {
        choices[map["title"]] = map["value"].toString();
      }
    }
    isCompact = loadCompact();
    isMultiSelect = widget.adaptiveMap?["isMultiSelect"] ?? false;
    if (value != null) {
      _selectedChoice.addAll(value!.split(","));
    }
  }

  @override
  void appendInput(Map map) {
    map[id] = _selectedChoice;
  }

  @override
  Widget build(BuildContext context) {
    late Widget widget;

    if (isCompact) {
      if (isMultiSelect) {
        widget = _buildExpandedMultiSelect();
      } else {
        widget = _buildCompact();
      }
    } else {
      if (isMultiSelect) {
        widget = _buildExpandedMultiSelect();
      } else {
        widget = _buildExpandedSingleSelect();
      }
    }

    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: widget,
    );
  }

  /// This is built when multiSelect is false and isCompact is true
  Widget _buildCompact() {
    return DropdownButton<String>(
      items: choices.keys
          .map((choice) => DropdownMenuItem<String>(
        value: choices[choice],
        child: Text(choice),
      ))
          .toList(),
      onChanged: (String? value){
        select(value ?? '');
      },
      value: _selectedChoice.single,
    );
  }

  Widget _buildExpandedSingleSelect() {
    return Column(
      children: choices.keys.map((key) {
        return RadioListTile<String>(
          value: choices[key] ?? '',
          onChanged: (String? value){
            select(value ?? '');
          },
          groupValue:
          _selectedChoice.contains(choices[key]) ? choices[key] : null,
          title: Text(key),
        );
      }).toList(),
    );
  }

  Widget _buildExpandedMultiSelect() {
    return Column(
      children: choices.keys.map((key) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: _selectedChoice.contains(choices[key]),
          onChanged: (_) {
            select(choices[key] ?? '');
          },
          title: Text(key),
        );
      }).toList(),
    );
  }

  void select(String choice) {
    if (!isMultiSelect) {
      _selectedChoice.clear();
      _selectedChoice.add(choice);
    } else {
      if (_selectedChoice.contains(choice)) {
        _selectedChoice.remove(choice);
      } else {
        _selectedChoice.add(choice);
      }
    }
    setState(() {});
  }

  bool loadCompact() {
    if (widget.adaptiveMap == null || !widget.adaptiveMap!.containsKey("style"))
      return false;
    if (widget.adaptiveMap!["style"] == "compact") return true;
    if (widget.adaptiveMap!["style"] == "expanded") return false;
    throw StateError(
        "The style of the ChoiceSet needs to be either compact or expanded");
  }
}
