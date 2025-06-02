import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './model.dart';

// This notifier behaves a little different from the text fields'
// when the dropdown value is selected, the value is changed first,
// the text changes follow that.
class SelectionNotifier<T> extends ChangeNotifier {
  final formatController = TextEditingController();
  T? _value;

  SelectionNotifier() {
    addListener(() {
      formatController.text = value.toString();
    });
  }

  T? get value => _value;
  set value(T? newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class FloatNotifier extends ValueNotifier<double> {
  final formatController = TextEditingController();

  FloatNotifier(super.value) {
    formatController.text = value.toString();
    formatController.addListener(() {
      try {
        value = double.parse(formatController.text);
      } finally {}
    });
  }
}

class IntNotifier extends ValueNotifier<int> {
  final formatController = TextEditingController();

  IntNotifier(super.value) {
    formatController.text = value.toString();
    formatController.addListener(() {
      try {
        value = int.parse(formatController.text);
      } finally {}
    });
  }
}

class VariableVariationController extends ChangeNotifier {
  final name = IntNotifier(1);
  final min = FloatNotifier(1e-7);
  final max = FloatNotifier(10);
  final n = IntNotifier(8);

  VariableVariationController() {
    name.addListener(notifyListeners);
    min.addListener(notifyListeners);
    max.addListener(notifyListeners);
    n.addListener(notifyListeners);
  }

  get value => InitialValueVariation(
    index: name.value,
    min: min.value,
    max: max.value,
    n: n.value,
  );
}

class ParameterVariationController extends ChangeNotifier {
  final name = SelectionNotifier<String>();
  final min = FloatNotifier(0);
  final max = FloatNotifier(1);
  final n = IntNotifier(100);

  ParameterVariationController() {
    name.addListener(notifyListeners);
    min.addListener(notifyListeners);
    max.addListener(notifyListeners);
    n.addListener(notifyListeners);
    notifyListeners();
  }

  get value => ParamVariation(
    name: name.value ?? "",
    min: min.value,
    max: max.value,
    n: n.value,
  );
}

class VariableVariationEditor extends StatelessWidget {
  final List<VariableSpecs> variableSpecs;
  final VariableVariationController controller;

  const VariableVariationEditor({
    super.key,
    required this.variableSpecs,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      spacing: 10,
      children: [
        Flexible(
          child: DropdownMenu<int>(
            controller: controller.name.formatController,
            initialSelection: variableSpecs.first.index,
            dropdownMenuEntries: [
              for (final spec in variableSpecs)
                DropdownMenuEntry(label: spec.name, value: spec.index),
            ],
            onSelected: (int? value) {
              switch (value) {
                case int value:
                  controller.name.value = value;
              }
            },
          ),
        ),
        Flexible(
          child: NumberEditor(
            label: "min",
            controller: controller.min.formatController,
          ),
        ),
        Flexible(
          child: NumberEditor(
            label: "max",
            controller: controller.max.formatController,
          ),
        ),
        Flexible(
          child: NumberEditor(
            label: "n",
            controller: controller.n.formatController,
          ),
        ),
      ],
    );
  }
}

class ParameterVariationEditor extends StatelessWidget {
  final List<ParameterSpecs> parameters;
  final ParameterVariationController controller;

  const ParameterVariationEditor({
    super.key,
    required this.parameters,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      spacing: 10,
      children: [
        Flexible(
          child: DropdownMenu<String>(
            controller: controller.name.formatController,
            initialSelection: parameters.first.name,
            dropdownMenuEntries: [
              for (final spec in parameters)
                DropdownMenuEntry(label: spec.name, value: spec.name),
            ],
            onSelected: (String? value) {
              switch (value) {
                case String value:
                  controller.name.value = value;
              }
            },
          ),
        ),
        Flexible(
          child: NumberEditor(
            label: "min",
            controller: controller.min.formatController,
          ),
        ),
        Flexible(
          child: NumberEditor(
            label: "max",
            controller: controller.max.formatController,
          ),
        ),
        Flexible(
          child: NumberEditor(
            label: "n",
            controller: controller.n.formatController,
          ),
        ),
      ],
    );
  }
}

class SimulateEditor extends StatelessWidget {
  final TextEditingController tmaxController;
  final TextEditingController dtmaxController;
  const SimulateEditor({
    super.key,
    required this.tmaxController,
    required this.dtmaxController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberEditor(label: "Thời gian tối đa", controller: tmaxController),
        NumberEditor(
          label: "Bước thời gian tối đa",
          controller: dtmaxController,
        ),
      ],
    );
  }
}

extension NumberValue on TextEditingController {
  double get doubleValue => double.parse(text);
  int get intValue => int.parse(text);
}

class NumberEditor extends StatelessWidget {
  final ValueChanged<double>? onChange;
  final TextEditingController? controller;
  final String label;
  final bool integerOnly;
  const NumberEditor({
    super.key,
    required this.label,
    this.onChange,
    this.controller,
    this.integerOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final pattern = switch (integerOnly) {
      true => RegExp("[0-9+-]"),
      false => RegExp(r"[0-9.e-]"),
    };
    final formatter = FilteringTextInputFormatter(pattern, allow: true);

    return TextField(
      inputFormatters: [formatter],
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onChanged: (String source) {
        final value = double.parse(source);
        switch (onChange) {
          case ValueChanged<double> onChange:
            onChange(value);
        }
      },
    );
  }
}
