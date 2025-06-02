import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
abstract class VariableSpecs with _$VariableSpecs {
  const factory VariableSpecs({
    required String name,
    required String description,
    required int index,
    @JsonKey(name: "default") required double defaultValue,
  }) = _VariableSpecs;

  factory VariableSpecs.fromJson(Map<String, Object?> json) =>
      _$VariableSpecsFromJson(json);
}

@freezed
abstract class ParameterSpecs with _$ParameterSpecs {
  const factory ParameterSpecs({
    required String name,
    required String description,
    @JsonKey(name: "default") required double defaultValue,
    required String alias,
  }) = _ParameterSpecs;

  factory ParameterSpecs.fromJson(Map<String, Object?> json) =>
      _$ParameterSpecsFromJson(json);
}

@freezed
abstract class ModelSpecs with _$ModelSpecs {
  const factory ModelSpecs({
    required List<VariableSpecs> variables,
    required List<ParameterSpecs> parameters,
  }) = _ModelSpecs;

  factory ModelSpecs.fromJson(Map<String, Object?> json) =>
      _$ModelSpecsFromJson(json);
}

@freezed
abstract class InitialValueVariation with _$InitialValueVariation {
  const factory InitialValueVariation({
    required int index,
    required double min,
    required double max,
    required int n,
  }) = _InitialValueVariation;

  factory InitialValueVariation.fromJson(Map<String, dynamic> json) =>
      _$InitialValueVariationFromJson(json);
}

@freezed
abstract class Bifurcation1dRequest with _$Bifurcation1dRequest {
  const factory Bifurcation1dRequest({
    required Map<String, double> parameters,
    required ParamVariation update,
    required List<double> u0,
    required double tmax,
    required double dtmax,
  }) = _Bifurcation1dRequest;

  factory Bifurcation1dRequest.fromJson(Map<String, dynamic> json) =>
      _$Bifurcation1dRequestFromJson(json);
}

@freezed
abstract class Bifurcation2dRequest with _$Bifurcation2dRequest {
  const factory Bifurcation2dRequest({
    required Map<String, double> parameters,
    @JsonKey(name: "x_update") required ParamVariation xUpdate,
    @JsonKey(name: "y_update") required ParamVariation yUpdate,
  }) = _Bifurcation2dRequest;

  factory Bifurcation2dRequest.fromJson(Map<String, dynamic> json) =>
      _$Bifurcation2dRequestFromJson(json);
}

@freezed
abstract class ParamVariation with _$ParamVariation {
  const factory ParamVariation({
    required String name,
    required double min,
    required double max,
    required int n,
  }) = _ParamVariation;

  factory ParamVariation.fromJson(Map<String, dynamic> json) =>
      _$ParamVariationFromJson(json);
}

@freezed
abstract class PhasePortraitRequest with _$PhasePortraitRequest {
  const factory PhasePortraitRequest({
    required Map<String, double> parameters,
    required List<double> u0,
    required InitialValueVariation xchange,
    required InitialValueVariation ychange,
    required double tmax,
    required double dtmax,
  }) = _PhasePortraitRequest;

  factory PhasePortraitRequest.fromJson(Map<String, Object?> json) =>
      _$PhasePortraitRequestFromJson(json);
  // Map<String, Object?> toJson() => _$SimulationRequestToJson(json);
}

@freezed
abstract class SimulationRequest with _$SimulationRequest {
  const factory SimulationRequest({
    required Map<String, double> parameters,
    required List<double> u0,
    required double tmax,
    required double dtmax,
  }) = _SimulationRequest;

  factory SimulationRequest.fromJson(Map<String, Object?> json) =>
      _$SimulationRequestFromJson(json);
  // Map<String, Object?> toJson() => _$SimulationRequestToJson(json);
}

class Api {
  final String serverUrl;
  const Api(this.serverUrl);

  Future<ModelSpecs?> getModelSpecifications() async {
    final dio = Dio();
    final response = await dio.get(
      "$serverUrl/model/specifications",
      options: Options(responseType: ResponseType.json),
    );
    final json = response.data as Map<String, Object?>;
    try {
      return ModelSpecs.fromJson(json);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Uint8List> requestSimulation(SimulationRequest request) async {
    final dio = Dio();
    final response = await dio.post(
      "$serverUrl/experiment/simulate",
      data: request.toJson(),
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }

  Future<Uint8List> requestPhasePortrait(PhasePortraitRequest request) async {
    final dio = Dio();
    print(request.toJson());
    final response = await dio.post(
      "$serverUrl/experiment/phase-portrait",
      data: request.toJson(),
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }

  Future<Uint8List> requestBifurcationDiagram1d(
    Bifurcation1dRequest request,
  ) async {
    final dio = Dio();
    print(request);
    final response = await dio.post(
      "$serverUrl/experiment/bifurcation-1d",
      data: request.toJson(),
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }

  Future<Uint8List> requestBifurcationDiagram2d(
    Bifurcation2dRequest request,
  ) async {
    final dio = Dio();
    print(request);
    final response = await dio.post(
      "$serverUrl/experiment/bifurcation-2d",
      data: request.toJson(),
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }
}

enum ExperimentType {
  simpleSimulation(value: "simulation", label: "Chạy mô phỏng đơn thuần"),
  phasePortrait(
    value: "phase",
    label: "Vẽ biểu đồ pha",
    variesInitialCondition: true,
  ),
  bifurcation1d(
    value: "bifurcation1d",
    label: "Biểu đồ rẽ nhánh (1 tham số)",
    variesParameters: 1,
  ),
  bifurcation2d(
    value: "bifurcation2d",
    label: "Biểu đồ rẽ nhánh (2 tham số)",
    needSimulation: false,
    variesParameters: 2,
  );

  const ExperimentType({
    required this.value,
    required this.label,
    this.needSimulation = true,
    this.variesInitialCondition = false,
    this.variesParameters = 0,
  });

  final String value;
  final String label;
  final bool needSimulation;
  final bool variesInitialCondition;
  final int variesParameters;
}
