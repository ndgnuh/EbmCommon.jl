// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VariableSpecs _$VariableSpecsFromJson(Map<String, dynamic> json) =>
    _VariableSpecs(
      name: json['name'] as String,
      description: json['description'] as String,
      index: (json['index'] as num).toInt(),
      defaultValue: (json['default'] as num).toDouble(),
    );

Map<String, dynamic> _$VariableSpecsToJson(_VariableSpecs instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'index': instance.index,
      'default': instance.defaultValue,
    };

_ParameterSpecs _$ParameterSpecsFromJson(Map<String, dynamic> json) =>
    _ParameterSpecs(
      name: json['name'] as String,
      description: json['description'] as String,
      defaultValue: (json['default'] as num).toDouble(),
      alias: json['alias'] as String,
    );

Map<String, dynamic> _$ParameterSpecsToJson(_ParameterSpecs instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'default': instance.defaultValue,
      'alias': instance.alias,
    };

_ModelSpecs _$ModelSpecsFromJson(Map<String, dynamic> json) => _ModelSpecs(
  variables: (json['variables'] as List<dynamic>)
      .map((e) => VariableSpecs.fromJson(e as Map<String, dynamic>))
      .toList(),
  parameters: (json['parameters'] as List<dynamic>)
      .map((e) => ParameterSpecs.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ModelSpecsToJson(_ModelSpecs instance) =>
    <String, dynamic>{
      'variables': instance.variables,
      'parameters': instance.parameters,
    };

_InitialValueVariation _$InitialValueVariationFromJson(
  Map<String, dynamic> json,
) => _InitialValueVariation(
  index: (json['index'] as num).toInt(),
  min: (json['min'] as num).toDouble(),
  max: (json['max'] as num).toDouble(),
  n: (json['n'] as num).toInt(),
);

Map<String, dynamic> _$InitialValueVariationToJson(
  _InitialValueVariation instance,
) => <String, dynamic>{
  'index': instance.index,
  'min': instance.min,
  'max': instance.max,
  'n': instance.n,
};

_Bifurcation1dRequest _$Bifurcation1dRequestFromJson(
  Map<String, dynamic> json,
) => _Bifurcation1dRequest(
  parameters: (json['parameters'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  update: ParamVariation.fromJson(json['update'] as Map<String, dynamic>),
  u0: (json['u0'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
  tmax: (json['tmax'] as num).toDouble(),
  dtmax: (json['dtmax'] as num).toDouble(),
);

Map<String, dynamic> _$Bifurcation1dRequestToJson(
  _Bifurcation1dRequest instance,
) => <String, dynamic>{
  'parameters': instance.parameters,
  'update': instance.update,
  'u0': instance.u0,
  'tmax': instance.tmax,
  'dtmax': instance.dtmax,
};

_Bifurcation2dRequest _$Bifurcation2dRequestFromJson(
  Map<String, dynamic> json,
) => _Bifurcation2dRequest(
  parameters: (json['parameters'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  xUpdate: ParamVariation.fromJson(json['x_update'] as Map<String, dynamic>),
  yUpdate: ParamVariation.fromJson(json['y_update'] as Map<String, dynamic>),
);

Map<String, dynamic> _$Bifurcation2dRequestToJson(
  _Bifurcation2dRequest instance,
) => <String, dynamic>{
  'parameters': instance.parameters,
  'x_update': instance.xUpdate,
  'y_update': instance.yUpdate,
};

_ParamVariation _$ParamVariationFromJson(Map<String, dynamic> json) =>
    _ParamVariation(
      name: json['name'] as String,
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      n: (json['n'] as num).toInt(),
    );

Map<String, dynamic> _$ParamVariationToJson(_ParamVariation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'min': instance.min,
      'max': instance.max,
      'n': instance.n,
    };

_PhasePortraitRequest _$PhasePortraitRequestFromJson(
  Map<String, dynamic> json,
) => _PhasePortraitRequest(
  parameters: (json['parameters'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  u0: (json['u0'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
  xchange: InitialValueVariation.fromJson(
    json['xchange'] as Map<String, dynamic>,
  ),
  ychange: InitialValueVariation.fromJson(
    json['ychange'] as Map<String, dynamic>,
  ),
  tmax: (json['tmax'] as num).toDouble(),
  dtmax: (json['dtmax'] as num).toDouble(),
);

Map<String, dynamic> _$PhasePortraitRequestToJson(
  _PhasePortraitRequest instance,
) => <String, dynamic>{
  'parameters': instance.parameters,
  'u0': instance.u0,
  'xchange': instance.xchange,
  'ychange': instance.ychange,
  'tmax': instance.tmax,
  'dtmax': instance.dtmax,
};

_SimulationRequest _$SimulationRequestFromJson(Map<String, dynamic> json) =>
    _SimulationRequest(
      parameters: (json['parameters'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      u0: (json['u0'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      tmax: (json['tmax'] as num).toDouble(),
      dtmax: (json['dtmax'] as num).toDouble(),
    );

Map<String, dynamic> _$SimulationRequestToJson(_SimulationRequest instance) =>
    <String, dynamic>{
      'parameters': instance.parameters,
      'u0': instance.u0,
      'tmax': instance.tmax,
      'dtmax': instance.dtmax,
    };
