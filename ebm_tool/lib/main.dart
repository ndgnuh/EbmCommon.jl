import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import './model.dart';
import './view_model_experiment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'EBM Tool'),
    );
  }
}

class ExperimentSelection extends StatelessWidget {
  const ExperimentSelection({super.key});
  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context, listen: false);
    return Row(
      spacing: 10,
      children: [
        Text("Thí nghiệm:"),
        Expanded(
          child: DropdownMenu(
            width: 700,
            onSelected: (e) {
              state.experimentType = e;
            },
            dropdownMenuEntries: [
              for (final etype in ExperimentType.values)
                DropdownMenuEntry(value: etype, label: etype.label),
            ],
          ),
        ),
      ],
    );
  }
}

class ExperimentEditor extends StatelessWidget {
  const ExperimentEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context);
    final modelSpecs = state.modelSpecs;
    final ExperimentType? etype = state.experimentType;
    if (etype == null) {
      return Text("Select an experiment first");
    }

    return Column(
      spacing: 10,
      children: [
        if (modelSpecs != null && etype.needSimulation)
          NumberEditor(
            label: "Thời gian tối đa",
            controller: state.tmaxController,
          ),
        if (modelSpecs != null && etype.needSimulation)
          NumberEditor(
            label: "Bước thời gian tối đa",
            controller: state.dtmaxController,
          ),
        if (modelSpecs != null && etype.variesInitialCondition)
          VariableVariationEditor(
            variableSpecs: state.modelSpecs!.variables,
            controller: state.variableControllerX,
          ),
        if (modelSpecs != null && etype.variesInitialCondition)
          VariableVariationEditor(
            variableSpecs: state.modelSpecs!.variables,
            controller: state.variableControllerY,
          ),
        if (modelSpecs != null && etype.variesParameters >= 1)
          ParameterVariationEditor(
            parameters: state.modelSpecs!.parameters,
            controller: state.parameterControllerX,
          ),
        if (modelSpecs != null && etype.variesParameters >= 2)
          ParameterVariationEditor(
            parameters: state.modelSpecs!.parameters,
            controller: state.parameterControllerY,
          ),
      ],
    );
  }
}

class RunButton extends StatelessWidget {
  const RunButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context);
    return FutureBuilder(
      future: state.resultImageFuture,
      builder: (context, connection) {
        final callback = switch ((
          state.experimentType,
          connection.connectionState,
        )) {
          (null, _) => null,
          (_, ConnectionState.done) => state.run,
          _ => null,
        };

        return FilledButton.icon(
          onPressed: callback,
          label: Text("Chạy"),
          icon: Icon(Icons.play_arrow),
        );
      },
    );
  }
}

class InitialConditionInput extends StatelessWidget {
  const InitialConditionInput({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context);
    if (state.modelSpecs == null) return Text("No model");
    final variables = state.modelSpecs!.variables;
    final controllers = state.u0Controllers;
    return Column(
      children: [
        for (final (i, variable) in variables.indexed)
          NumberEditor(
            controller: controllers[i].formatController,
            label: "${variable.description} (${variable.name})",
          ),
      ],
    );
  }
}

class ParameterInput extends StatelessWidget {
  const ParameterInput({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context);

    if (state.modelSpecs == null) {
      return Text("No model");
    }

    final parameters = state.modelSpecs!.parameters;
    final controllers = state.parameterControllers;

    return Column(
      children: [
        for (final param in parameters)
          NumberEditor(
            controller: controllers[param.name],
            label: "${param.description} (${param.name})",
          ),
      ],
    );
  }
}

class ExperimentState extends ChangeNotifier {
  String? serverUrl;
  Future<Uint8List?> resultImageFuture = Future.value(null);
  Uint8List? resultImage;
  final inputPanelScrollController = ScrollController();

  ModelSpecs? modelSpecs;
  ExperimentType? _experimentType;
  final Map<String, TextEditingController> parameterControllers = {};
  final List<FloatNotifier> u0Controllers = [];
  final tmaxController = TextEditingController(text: "500.0");
  final dtmaxController = TextEditingController(text: "0.2");
  var variableControllerX = VariableVariationController();
  var variableControllerY = VariableVariationController();
  var parameterControllerX = ParameterVariationController();
  var parameterControllerY = ParameterVariationController();

  final serverUrlController = TextEditingController(text: "http://localhost");

  get experimentType => _experimentType;
  set experimentType(value) {
    _experimentType = value;
    variableControllerX = VariableVariationController();
    variableControllerY = VariableVariationController();
    parameterControllerX = ParameterVariationController();
    parameterControllerY = ParameterVariationController();

    notifyListeners();
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      final ctl = inputPanelScrollController;
      ctl.jumpTo(ctl.position.maxScrollExtent);
    });
  }

  Api get api => Api(serverUrlController.text);

  Map<String, double> get parameters {
    final parameters = <String, double>{};
    for (final name in parameterControllers.keys) {
      parameters[name] = parameterControllers[name]!.doubleValue;
    }
    return parameters;
  }

  List<double> get u0 {
    final u0 = <double>[];
    for (final controller in u0Controllers) {
      final value = controller.value;
      u0.add(value);
    }
    return u0;
  }

  refresh([String? newServerUrl]) async {
    modelSpecs = null;
    parameterControllers.clear();
    u0Controllers.clear();
    notifyListeners();

    modelSpecs = await api.getModelSpecifications();
    for (final p in modelSpecs?.parameters ?? []) {
      parameterControllers[p.name] = TextEditingController(
        text: p.defaultValue.toString(),
      );
    }
    for (final p in modelSpecs?.variables ?? []) {
      final controller = FloatNotifier(p.defaultValue);
      u0Controllers.add(controller);
    }
    notifyListeners();
  }

  /// This is just to help serialization
  String? currentRequestJson;

  run() async {
    switch (experimentType) {
      case ExperimentType.simpleSimulation:
        final request = SimulationRequest(
          parameters: parameters,
          u0: u0,
          tmax: tmaxController.doubleValue,
          dtmax: dtmaxController.doubleValue,
        );
        currentRequestJson = jsonEncode(request);
        resultImageFuture = api.requestSimulation(request);
      case ExperimentType.phasePortrait:
        final request = PhasePortraitRequest(
          parameters: parameters,
          u0: u0,
          xchange: variableControllerX.value,
          ychange: variableControllerY.value,
          tmax: tmaxController.doubleValue,
          dtmax: dtmaxController.doubleValue,
        );
        currentRequestJson = jsonEncode(request);
        resultImageFuture = api.requestPhasePortrait(request);
      case ExperimentType.bifurcation1d:
        final request = Bifurcation1dRequest(
          parameters: parameters,
          u0: u0,
          update: parameterControllerX.value,
          tmax: tmaxController.doubleValue,
          dtmax: dtmaxController.doubleValue,
        );
        currentRequestJson = jsonEncode(request);
        resultImageFuture = api.requestBifurcationDiagram1d(request);
      case ExperimentType.bifurcation2d:
        final request = Bifurcation2dRequest(
          parameters: parameters,
          xUpdate: parameterControllerX.value,
          yUpdate: parameterControllerY.value,
        );
        currentRequestJson = jsonEncode(request);
        resultImageFuture = api.requestBifurcationDiagram2d(request);
      default:
        resultImageFuture = Future.value(null);
        currentRequestJson = "";
    }

    notifyListeners();
    resultImage = await resultImageFuture;
    notifyListeners();
  }

  save() async {
    switch ((resultImage, currentRequestJson)) {
      case (Uint8List image, String json):
        final result = await FilePicker.platform.saveFile(
          dialogTitle: "Lưu file",
          fileName: "image.png",
        );
        switch (result) {
          case String savePath:
            final basename = p.withoutExtension(savePath);
            final jsonname = "$basename.json";

            // Save figure
            final file = File(savePath);
            await file.writeAsBytes(image);

            final jsonfile = File(jsonname);
            await jsonfile.writeAsString(json);
        }
    }
  }

  ExperimentState init() {
    refresh();
    return this;
  }

  // Shorthand
  static ExperimentState of(BuildContext context, {bool listen = true}) =>
      Provider.of<ExperimentState>(context, listen: listen);
}

class ServerUrlEditor extends StatelessWidget {
  const ServerUrlEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context);
    return TextField(
      decoration: InputDecoration(label: Text("Server URL")),
      controller: state.serverUrlController,
      onSubmitted: (String serverUrl) {
        state.refresh(serverUrl);
      },
    );
  }
}

class ResultImage extends StatelessWidget {
  const ResultImage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context);
    return Center(
      child: FutureBuilder(
        future: state.resultImageFuture,
        builder: (context, future) {
          switch ((future.connectionState, future.data)) {
            case (ConnectionState.done, Uint8List data):
              return Image.memory(data, fit: BoxFit.contain);
            case (ConnectionState.done, null):
              return Text("No image");
            case (ConnectionState.waiting || ConnectionState.active, _):
              return Center(child: CircularProgressIndicator());
            default:
              return Text("Something went wrong");
          }
        },
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});
  @override
  Widget build(BuildContext context) {
    final state = ExperimentState.of(context);
    return FutureBuilder(
      future: state.resultImageFuture,
      builder: (context, connection) {
        final callback = switch ((
          connection.connectionState,
          connection.data,
        )) {
          (ConnectionState.done, Uint8List _) => state.save,
          _ => null,
        };
        return FilledButton.icon(
          icon: Icon(Icons.save),
          label: Text("Lưu"),
          onPressed: callback,
        );
      },
    );
  }
}

class ExperimentInputArea extends StatelessWidget {
  const ExperimentInputArea({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final state = ExperimentState.of(context);
    return SingleChildScrollView(
      controller: state.inputPanelScrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          ServerUrlEditor(),
          Text("Tham số mô hình", style: textTheme.headlineMedium),
          ParameterInput(),
          Text("Nghiệm ban đầu", style: textTheme.headlineMedium),
          InitialConditionInput(),
          Text("Tham số thí nghiệm", style: textTheme.headlineMedium),
          ExperimentSelection(),
          ExperimentEditor(),
        ],
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ChangeNotifierProvider(
        create: (context) => ExperimentState().init(),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Flex(
            spacing: 10,
            direction: Axis.horizontal,
            children: [
              Flexible(flex: 3, fit: FlexFit.tight, child: ResultImage()),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Flex(
                  spacing: 10,
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(child: ExperimentInputArea()),
                    Flex(
                      direction: Axis.horizontal,
                      spacing: 10,
                      children: [
                        Expanded(child: RunButton()),
                        Expanded(child: SaveButton()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
