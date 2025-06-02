// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VariableSpecs {

 String get name; String get description; int get index;@JsonKey(name: "default") double get defaultValue;
/// Create a copy of VariableSpecs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VariableSpecsCopyWith<VariableSpecs> get copyWith => _$VariableSpecsCopyWithImpl<VariableSpecs>(this as VariableSpecs, _$identity);

  /// Serializes this VariableSpecs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VariableSpecs&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.index, index) || other.index == index)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,index,defaultValue);

@override
String toString() {
  return 'VariableSpecs(name: $name, description: $description, index: $index, defaultValue: $defaultValue)';
}


}

/// @nodoc
abstract mixin class $VariableSpecsCopyWith<$Res>  {
  factory $VariableSpecsCopyWith(VariableSpecs value, $Res Function(VariableSpecs) _then) = _$VariableSpecsCopyWithImpl;
@useResult
$Res call({
 String name, String description, int index,@JsonKey(name: "default") double defaultValue
});




}
/// @nodoc
class _$VariableSpecsCopyWithImpl<$Res>
    implements $VariableSpecsCopyWith<$Res> {
  _$VariableSpecsCopyWithImpl(this._self, this._then);

  final VariableSpecs _self;
  final $Res Function(VariableSpecs) _then;

/// Create a copy of VariableSpecs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? index = null,Object? defaultValue = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _VariableSpecs implements VariableSpecs {
  const _VariableSpecs({required this.name, required this.description, required this.index, @JsonKey(name: "default") required this.defaultValue});
  factory _VariableSpecs.fromJson(Map<String, dynamic> json) => _$VariableSpecsFromJson(json);

@override final  String name;
@override final  String description;
@override final  int index;
@override@JsonKey(name: "default") final  double defaultValue;

/// Create a copy of VariableSpecs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VariableSpecsCopyWith<_VariableSpecs> get copyWith => __$VariableSpecsCopyWithImpl<_VariableSpecs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VariableSpecsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VariableSpecs&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.index, index) || other.index == index)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,index,defaultValue);

@override
String toString() {
  return 'VariableSpecs(name: $name, description: $description, index: $index, defaultValue: $defaultValue)';
}


}

/// @nodoc
abstract mixin class _$VariableSpecsCopyWith<$Res> implements $VariableSpecsCopyWith<$Res> {
  factory _$VariableSpecsCopyWith(_VariableSpecs value, $Res Function(_VariableSpecs) _then) = __$VariableSpecsCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, int index,@JsonKey(name: "default") double defaultValue
});




}
/// @nodoc
class __$VariableSpecsCopyWithImpl<$Res>
    implements _$VariableSpecsCopyWith<$Res> {
  __$VariableSpecsCopyWithImpl(this._self, this._then);

  final _VariableSpecs _self;
  final $Res Function(_VariableSpecs) _then;

/// Create a copy of VariableSpecs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? index = null,Object? defaultValue = null,}) {
  return _then(_VariableSpecs(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ParameterSpecs {

 String get name; String get description;@JsonKey(name: "default") double get defaultValue; String get alias;
/// Create a copy of ParameterSpecs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParameterSpecsCopyWith<ParameterSpecs> get copyWith => _$ParameterSpecsCopyWithImpl<ParameterSpecs>(this as ParameterSpecs, _$identity);

  /// Serializes this ParameterSpecs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParameterSpecs&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.alias, alias) || other.alias == alias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,defaultValue,alias);

@override
String toString() {
  return 'ParameterSpecs(name: $name, description: $description, defaultValue: $defaultValue, alias: $alias)';
}


}

/// @nodoc
abstract mixin class $ParameterSpecsCopyWith<$Res>  {
  factory $ParameterSpecsCopyWith(ParameterSpecs value, $Res Function(ParameterSpecs) _then) = _$ParameterSpecsCopyWithImpl;
@useResult
$Res call({
 String name, String description,@JsonKey(name: "default") double defaultValue, String alias
});




}
/// @nodoc
class _$ParameterSpecsCopyWithImpl<$Res>
    implements $ParameterSpecsCopyWith<$Res> {
  _$ParameterSpecsCopyWithImpl(this._self, this._then);

  final ParameterSpecs _self;
  final $Res Function(ParameterSpecs) _then;

/// Create a copy of ParameterSpecs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? defaultValue = null,Object? alias = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as double,alias: null == alias ? _self.alias : alias // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ParameterSpecs implements ParameterSpecs {
  const _ParameterSpecs({required this.name, required this.description, @JsonKey(name: "default") required this.defaultValue, required this.alias});
  factory _ParameterSpecs.fromJson(Map<String, dynamic> json) => _$ParameterSpecsFromJson(json);

@override final  String name;
@override final  String description;
@override@JsonKey(name: "default") final  double defaultValue;
@override final  String alias;

/// Create a copy of ParameterSpecs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParameterSpecsCopyWith<_ParameterSpecs> get copyWith => __$ParameterSpecsCopyWithImpl<_ParameterSpecs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParameterSpecsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParameterSpecs&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.alias, alias) || other.alias == alias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,defaultValue,alias);

@override
String toString() {
  return 'ParameterSpecs(name: $name, description: $description, defaultValue: $defaultValue, alias: $alias)';
}


}

/// @nodoc
abstract mixin class _$ParameterSpecsCopyWith<$Res> implements $ParameterSpecsCopyWith<$Res> {
  factory _$ParameterSpecsCopyWith(_ParameterSpecs value, $Res Function(_ParameterSpecs) _then) = __$ParameterSpecsCopyWithImpl;
@override @useResult
$Res call({
 String name, String description,@JsonKey(name: "default") double defaultValue, String alias
});




}
/// @nodoc
class __$ParameterSpecsCopyWithImpl<$Res>
    implements _$ParameterSpecsCopyWith<$Res> {
  __$ParameterSpecsCopyWithImpl(this._self, this._then);

  final _ParameterSpecs _self;
  final $Res Function(_ParameterSpecs) _then;

/// Create a copy of ParameterSpecs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? defaultValue = null,Object? alias = null,}) {
  return _then(_ParameterSpecs(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as double,alias: null == alias ? _self.alias : alias // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ModelSpecs {

 List<VariableSpecs> get variables; List<ParameterSpecs> get parameters;
/// Create a copy of ModelSpecs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelSpecsCopyWith<ModelSpecs> get copyWith => _$ModelSpecsCopyWithImpl<ModelSpecs>(this as ModelSpecs, _$identity);

  /// Serializes this ModelSpecs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelSpecs&&const DeepCollectionEquality().equals(other.variables, variables)&&const DeepCollectionEquality().equals(other.parameters, parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(variables),const DeepCollectionEquality().hash(parameters));

@override
String toString() {
  return 'ModelSpecs(variables: $variables, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class $ModelSpecsCopyWith<$Res>  {
  factory $ModelSpecsCopyWith(ModelSpecs value, $Res Function(ModelSpecs) _then) = _$ModelSpecsCopyWithImpl;
@useResult
$Res call({
 List<VariableSpecs> variables, List<ParameterSpecs> parameters
});




}
/// @nodoc
class _$ModelSpecsCopyWithImpl<$Res>
    implements $ModelSpecsCopyWith<$Res> {
  _$ModelSpecsCopyWithImpl(this._self, this._then);

  final ModelSpecs _self;
  final $Res Function(ModelSpecs) _then;

/// Create a copy of ModelSpecs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? variables = null,Object? parameters = null,}) {
  return _then(_self.copyWith(
variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as List<VariableSpecs>,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as List<ParameterSpecs>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ModelSpecs implements ModelSpecs {
  const _ModelSpecs({required final  List<VariableSpecs> variables, required final  List<ParameterSpecs> parameters}): _variables = variables,_parameters = parameters;
  factory _ModelSpecs.fromJson(Map<String, dynamic> json) => _$ModelSpecsFromJson(json);

 final  List<VariableSpecs> _variables;
@override List<VariableSpecs> get variables {
  if (_variables is EqualUnmodifiableListView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variables);
}

 final  List<ParameterSpecs> _parameters;
@override List<ParameterSpecs> get parameters {
  if (_parameters is EqualUnmodifiableListView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parameters);
}


/// Create a copy of ModelSpecs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelSpecsCopyWith<_ModelSpecs> get copyWith => __$ModelSpecsCopyWithImpl<_ModelSpecs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelSpecsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelSpecs&&const DeepCollectionEquality().equals(other._variables, _variables)&&const DeepCollectionEquality().equals(other._parameters, _parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_variables),const DeepCollectionEquality().hash(_parameters));

@override
String toString() {
  return 'ModelSpecs(variables: $variables, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class _$ModelSpecsCopyWith<$Res> implements $ModelSpecsCopyWith<$Res> {
  factory _$ModelSpecsCopyWith(_ModelSpecs value, $Res Function(_ModelSpecs) _then) = __$ModelSpecsCopyWithImpl;
@override @useResult
$Res call({
 List<VariableSpecs> variables, List<ParameterSpecs> parameters
});




}
/// @nodoc
class __$ModelSpecsCopyWithImpl<$Res>
    implements _$ModelSpecsCopyWith<$Res> {
  __$ModelSpecsCopyWithImpl(this._self, this._then);

  final _ModelSpecs _self;
  final $Res Function(_ModelSpecs) _then;

/// Create a copy of ModelSpecs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? variables = null,Object? parameters = null,}) {
  return _then(_ModelSpecs(
variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as List<VariableSpecs>,parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as List<ParameterSpecs>,
  ));
}


}


/// @nodoc
mixin _$InitialValueVariation {

 int get index; double get min; double get max; int get n;
/// Create a copy of InitialValueVariation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialValueVariationCopyWith<InitialValueVariation> get copyWith => _$InitialValueVariationCopyWithImpl<InitialValueVariation>(this as InitialValueVariation, _$identity);

  /// Serializes this InitialValueVariation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialValueVariation&&(identical(other.index, index) || other.index == index)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.n, n) || other.n == n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,min,max,n);

@override
String toString() {
  return 'InitialValueVariation(index: $index, min: $min, max: $max, n: $n)';
}


}

/// @nodoc
abstract mixin class $InitialValueVariationCopyWith<$Res>  {
  factory $InitialValueVariationCopyWith(InitialValueVariation value, $Res Function(InitialValueVariation) _then) = _$InitialValueVariationCopyWithImpl;
@useResult
$Res call({
 int index, double min, double max, int n
});




}
/// @nodoc
class _$InitialValueVariationCopyWithImpl<$Res>
    implements $InitialValueVariationCopyWith<$Res> {
  _$InitialValueVariationCopyWithImpl(this._self, this._then);

  final InitialValueVariation _self;
  final $Res Function(InitialValueVariation) _then;

/// Create a copy of InitialValueVariation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? min = null,Object? max = null,Object? n = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _InitialValueVariation implements InitialValueVariation {
  const _InitialValueVariation({required this.index, required this.min, required this.max, required this.n});
  factory _InitialValueVariation.fromJson(Map<String, dynamic> json) => _$InitialValueVariationFromJson(json);

@override final  int index;
@override final  double min;
@override final  double max;
@override final  int n;

/// Create a copy of InitialValueVariation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialValueVariationCopyWith<_InitialValueVariation> get copyWith => __$InitialValueVariationCopyWithImpl<_InitialValueVariation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InitialValueVariationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitialValueVariation&&(identical(other.index, index) || other.index == index)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.n, n) || other.n == n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,min,max,n);

@override
String toString() {
  return 'InitialValueVariation(index: $index, min: $min, max: $max, n: $n)';
}


}

/// @nodoc
abstract mixin class _$InitialValueVariationCopyWith<$Res> implements $InitialValueVariationCopyWith<$Res> {
  factory _$InitialValueVariationCopyWith(_InitialValueVariation value, $Res Function(_InitialValueVariation) _then) = __$InitialValueVariationCopyWithImpl;
@override @useResult
$Res call({
 int index, double min, double max, int n
});




}
/// @nodoc
class __$InitialValueVariationCopyWithImpl<$Res>
    implements _$InitialValueVariationCopyWith<$Res> {
  __$InitialValueVariationCopyWithImpl(this._self, this._then);

  final _InitialValueVariation _self;
  final $Res Function(_InitialValueVariation) _then;

/// Create a copy of InitialValueVariation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? min = null,Object? max = null,Object? n = null,}) {
  return _then(_InitialValueVariation(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Bifurcation1dRequest {

 Map<String, double> get parameters; ParamVariation get update; List<double> get u0; double get tmax; double get dtmax;
/// Create a copy of Bifurcation1dRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Bifurcation1dRequestCopyWith<Bifurcation1dRequest> get copyWith => _$Bifurcation1dRequestCopyWithImpl<Bifurcation1dRequest>(this as Bifurcation1dRequest, _$identity);

  /// Serializes this Bifurcation1dRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bifurcation1dRequest&&const DeepCollectionEquality().equals(other.parameters, parameters)&&(identical(other.update, update) || other.update == update)&&const DeepCollectionEquality().equals(other.u0, u0)&&(identical(other.tmax, tmax) || other.tmax == tmax)&&(identical(other.dtmax, dtmax) || other.dtmax == dtmax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parameters),update,const DeepCollectionEquality().hash(u0),tmax,dtmax);

@override
String toString() {
  return 'Bifurcation1dRequest(parameters: $parameters, update: $update, u0: $u0, tmax: $tmax, dtmax: $dtmax)';
}


}

/// @nodoc
abstract mixin class $Bifurcation1dRequestCopyWith<$Res>  {
  factory $Bifurcation1dRequestCopyWith(Bifurcation1dRequest value, $Res Function(Bifurcation1dRequest) _then) = _$Bifurcation1dRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, double> parameters, ParamVariation update, List<double> u0, double tmax, double dtmax
});


$ParamVariationCopyWith<$Res> get update;

}
/// @nodoc
class _$Bifurcation1dRequestCopyWithImpl<$Res>
    implements $Bifurcation1dRequestCopyWith<$Res> {
  _$Bifurcation1dRequestCopyWithImpl(this._self, this._then);

  final Bifurcation1dRequest _self;
  final $Res Function(Bifurcation1dRequest) _then;

/// Create a copy of Bifurcation1dRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parameters = null,Object? update = null,Object? u0 = null,Object? tmax = null,Object? dtmax = null,}) {
  return _then(_self.copyWith(
parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as ParamVariation,u0: null == u0 ? _self.u0 : u0 // ignore: cast_nullable_to_non_nullable
as List<double>,tmax: null == tmax ? _self.tmax : tmax // ignore: cast_nullable_to_non_nullable
as double,dtmax: null == dtmax ? _self.dtmax : dtmax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of Bifurcation1dRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParamVariationCopyWith<$Res> get update {
  
  return $ParamVariationCopyWith<$Res>(_self.update, (value) {
    return _then(_self.copyWith(update: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Bifurcation1dRequest implements Bifurcation1dRequest {
  const _Bifurcation1dRequest({required final  Map<String, double> parameters, required this.update, required final  List<double> u0, required this.tmax, required this.dtmax}): _parameters = parameters,_u0 = u0;
  factory _Bifurcation1dRequest.fromJson(Map<String, dynamic> json) => _$Bifurcation1dRequestFromJson(json);

 final  Map<String, double> _parameters;
@override Map<String, double> get parameters {
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parameters);
}

@override final  ParamVariation update;
 final  List<double> _u0;
@override List<double> get u0 {
  if (_u0 is EqualUnmodifiableListView) return _u0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_u0);
}

@override final  double tmax;
@override final  double dtmax;

/// Create a copy of Bifurcation1dRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Bifurcation1dRequestCopyWith<_Bifurcation1dRequest> get copyWith => __$Bifurcation1dRequestCopyWithImpl<_Bifurcation1dRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Bifurcation1dRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bifurcation1dRequest&&const DeepCollectionEquality().equals(other._parameters, _parameters)&&(identical(other.update, update) || other.update == update)&&const DeepCollectionEquality().equals(other._u0, _u0)&&(identical(other.tmax, tmax) || other.tmax == tmax)&&(identical(other.dtmax, dtmax) || other.dtmax == dtmax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parameters),update,const DeepCollectionEquality().hash(_u0),tmax,dtmax);

@override
String toString() {
  return 'Bifurcation1dRequest(parameters: $parameters, update: $update, u0: $u0, tmax: $tmax, dtmax: $dtmax)';
}


}

/// @nodoc
abstract mixin class _$Bifurcation1dRequestCopyWith<$Res> implements $Bifurcation1dRequestCopyWith<$Res> {
  factory _$Bifurcation1dRequestCopyWith(_Bifurcation1dRequest value, $Res Function(_Bifurcation1dRequest) _then) = __$Bifurcation1dRequestCopyWithImpl;
@override @useResult
$Res call({
 Map<String, double> parameters, ParamVariation update, List<double> u0, double tmax, double dtmax
});


@override $ParamVariationCopyWith<$Res> get update;

}
/// @nodoc
class __$Bifurcation1dRequestCopyWithImpl<$Res>
    implements _$Bifurcation1dRequestCopyWith<$Res> {
  __$Bifurcation1dRequestCopyWithImpl(this._self, this._then);

  final _Bifurcation1dRequest _self;
  final $Res Function(_Bifurcation1dRequest) _then;

/// Create a copy of Bifurcation1dRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parameters = null,Object? update = null,Object? u0 = null,Object? tmax = null,Object? dtmax = null,}) {
  return _then(_Bifurcation1dRequest(
parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as ParamVariation,u0: null == u0 ? _self._u0 : u0 // ignore: cast_nullable_to_non_nullable
as List<double>,tmax: null == tmax ? _self.tmax : tmax // ignore: cast_nullable_to_non_nullable
as double,dtmax: null == dtmax ? _self.dtmax : dtmax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of Bifurcation1dRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParamVariationCopyWith<$Res> get update {
  
  return $ParamVariationCopyWith<$Res>(_self.update, (value) {
    return _then(_self.copyWith(update: value));
  });
}
}


/// @nodoc
mixin _$Bifurcation2dRequest {

 Map<String, double> get parameters;@JsonKey(name: "x_update") ParamVariation get xUpdate;@JsonKey(name: "y_update") ParamVariation get yUpdate;
/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Bifurcation2dRequestCopyWith<Bifurcation2dRequest> get copyWith => _$Bifurcation2dRequestCopyWithImpl<Bifurcation2dRequest>(this as Bifurcation2dRequest, _$identity);

  /// Serializes this Bifurcation2dRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bifurcation2dRequest&&const DeepCollectionEquality().equals(other.parameters, parameters)&&(identical(other.xUpdate, xUpdate) || other.xUpdate == xUpdate)&&(identical(other.yUpdate, yUpdate) || other.yUpdate == yUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parameters),xUpdate,yUpdate);

@override
String toString() {
  return 'Bifurcation2dRequest(parameters: $parameters, xUpdate: $xUpdate, yUpdate: $yUpdate)';
}


}

/// @nodoc
abstract mixin class $Bifurcation2dRequestCopyWith<$Res>  {
  factory $Bifurcation2dRequestCopyWith(Bifurcation2dRequest value, $Res Function(Bifurcation2dRequest) _then) = _$Bifurcation2dRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, double> parameters,@JsonKey(name: "x_update") ParamVariation xUpdate,@JsonKey(name: "y_update") ParamVariation yUpdate
});


$ParamVariationCopyWith<$Res> get xUpdate;$ParamVariationCopyWith<$Res> get yUpdate;

}
/// @nodoc
class _$Bifurcation2dRequestCopyWithImpl<$Res>
    implements $Bifurcation2dRequestCopyWith<$Res> {
  _$Bifurcation2dRequestCopyWithImpl(this._self, this._then);

  final Bifurcation2dRequest _self;
  final $Res Function(Bifurcation2dRequest) _then;

/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parameters = null,Object? xUpdate = null,Object? yUpdate = null,}) {
  return _then(_self.copyWith(
parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,xUpdate: null == xUpdate ? _self.xUpdate : xUpdate // ignore: cast_nullable_to_non_nullable
as ParamVariation,yUpdate: null == yUpdate ? _self.yUpdate : yUpdate // ignore: cast_nullable_to_non_nullable
as ParamVariation,
  ));
}
/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParamVariationCopyWith<$Res> get xUpdate {
  
  return $ParamVariationCopyWith<$Res>(_self.xUpdate, (value) {
    return _then(_self.copyWith(xUpdate: value));
  });
}/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParamVariationCopyWith<$Res> get yUpdate {
  
  return $ParamVariationCopyWith<$Res>(_self.yUpdate, (value) {
    return _then(_self.copyWith(yUpdate: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Bifurcation2dRequest implements Bifurcation2dRequest {
  const _Bifurcation2dRequest({required final  Map<String, double> parameters, @JsonKey(name: "x_update") required this.xUpdate, @JsonKey(name: "y_update") required this.yUpdate}): _parameters = parameters;
  factory _Bifurcation2dRequest.fromJson(Map<String, dynamic> json) => _$Bifurcation2dRequestFromJson(json);

 final  Map<String, double> _parameters;
@override Map<String, double> get parameters {
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parameters);
}

@override@JsonKey(name: "x_update") final  ParamVariation xUpdate;
@override@JsonKey(name: "y_update") final  ParamVariation yUpdate;

/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Bifurcation2dRequestCopyWith<_Bifurcation2dRequest> get copyWith => __$Bifurcation2dRequestCopyWithImpl<_Bifurcation2dRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Bifurcation2dRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bifurcation2dRequest&&const DeepCollectionEquality().equals(other._parameters, _parameters)&&(identical(other.xUpdate, xUpdate) || other.xUpdate == xUpdate)&&(identical(other.yUpdate, yUpdate) || other.yUpdate == yUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parameters),xUpdate,yUpdate);

@override
String toString() {
  return 'Bifurcation2dRequest(parameters: $parameters, xUpdate: $xUpdate, yUpdate: $yUpdate)';
}


}

/// @nodoc
abstract mixin class _$Bifurcation2dRequestCopyWith<$Res> implements $Bifurcation2dRequestCopyWith<$Res> {
  factory _$Bifurcation2dRequestCopyWith(_Bifurcation2dRequest value, $Res Function(_Bifurcation2dRequest) _then) = __$Bifurcation2dRequestCopyWithImpl;
@override @useResult
$Res call({
 Map<String, double> parameters,@JsonKey(name: "x_update") ParamVariation xUpdate,@JsonKey(name: "y_update") ParamVariation yUpdate
});


@override $ParamVariationCopyWith<$Res> get xUpdate;@override $ParamVariationCopyWith<$Res> get yUpdate;

}
/// @nodoc
class __$Bifurcation2dRequestCopyWithImpl<$Res>
    implements _$Bifurcation2dRequestCopyWith<$Res> {
  __$Bifurcation2dRequestCopyWithImpl(this._self, this._then);

  final _Bifurcation2dRequest _self;
  final $Res Function(_Bifurcation2dRequest) _then;

/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parameters = null,Object? xUpdate = null,Object? yUpdate = null,}) {
  return _then(_Bifurcation2dRequest(
parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,xUpdate: null == xUpdate ? _self.xUpdate : xUpdate // ignore: cast_nullable_to_non_nullable
as ParamVariation,yUpdate: null == yUpdate ? _self.yUpdate : yUpdate // ignore: cast_nullable_to_non_nullable
as ParamVariation,
  ));
}

/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParamVariationCopyWith<$Res> get xUpdate {
  
  return $ParamVariationCopyWith<$Res>(_self.xUpdate, (value) {
    return _then(_self.copyWith(xUpdate: value));
  });
}/// Create a copy of Bifurcation2dRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParamVariationCopyWith<$Res> get yUpdate {
  
  return $ParamVariationCopyWith<$Res>(_self.yUpdate, (value) {
    return _then(_self.copyWith(yUpdate: value));
  });
}
}


/// @nodoc
mixin _$ParamVariation {

 String get name; double get min; double get max; int get n;
/// Create a copy of ParamVariation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParamVariationCopyWith<ParamVariation> get copyWith => _$ParamVariationCopyWithImpl<ParamVariation>(this as ParamVariation, _$identity);

  /// Serializes this ParamVariation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParamVariation&&(identical(other.name, name) || other.name == name)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.n, n) || other.n == n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,min,max,n);

@override
String toString() {
  return 'ParamVariation(name: $name, min: $min, max: $max, n: $n)';
}


}

/// @nodoc
abstract mixin class $ParamVariationCopyWith<$Res>  {
  factory $ParamVariationCopyWith(ParamVariation value, $Res Function(ParamVariation) _then) = _$ParamVariationCopyWithImpl;
@useResult
$Res call({
 String name, double min, double max, int n
});




}
/// @nodoc
class _$ParamVariationCopyWithImpl<$Res>
    implements $ParamVariationCopyWith<$Res> {
  _$ParamVariationCopyWithImpl(this._self, this._then);

  final ParamVariation _self;
  final $Res Function(ParamVariation) _then;

/// Create a copy of ParamVariation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? min = null,Object? max = null,Object? n = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ParamVariation implements ParamVariation {
  const _ParamVariation({required this.name, required this.min, required this.max, required this.n});
  factory _ParamVariation.fromJson(Map<String, dynamic> json) => _$ParamVariationFromJson(json);

@override final  String name;
@override final  double min;
@override final  double max;
@override final  int n;

/// Create a copy of ParamVariation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParamVariationCopyWith<_ParamVariation> get copyWith => __$ParamVariationCopyWithImpl<_ParamVariation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParamVariationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParamVariation&&(identical(other.name, name) || other.name == name)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.n, n) || other.n == n));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,min,max,n);

@override
String toString() {
  return 'ParamVariation(name: $name, min: $min, max: $max, n: $n)';
}


}

/// @nodoc
abstract mixin class _$ParamVariationCopyWith<$Res> implements $ParamVariationCopyWith<$Res> {
  factory _$ParamVariationCopyWith(_ParamVariation value, $Res Function(_ParamVariation) _then) = __$ParamVariationCopyWithImpl;
@override @useResult
$Res call({
 String name, double min, double max, int n
});




}
/// @nodoc
class __$ParamVariationCopyWithImpl<$Res>
    implements _$ParamVariationCopyWith<$Res> {
  __$ParamVariationCopyWithImpl(this._self, this._then);

  final _ParamVariation _self;
  final $Res Function(_ParamVariation) _then;

/// Create a copy of ParamVariation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? min = null,Object? max = null,Object? n = null,}) {
  return _then(_ParamVariation(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PhasePortraitRequest {

 Map<String, double> get parameters; List<double> get u0; InitialValueVariation get xchange; InitialValueVariation get ychange; double get tmax; double get dtmax;
/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhasePortraitRequestCopyWith<PhasePortraitRequest> get copyWith => _$PhasePortraitRequestCopyWithImpl<PhasePortraitRequest>(this as PhasePortraitRequest, _$identity);

  /// Serializes this PhasePortraitRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhasePortraitRequest&&const DeepCollectionEquality().equals(other.parameters, parameters)&&const DeepCollectionEquality().equals(other.u0, u0)&&(identical(other.xchange, xchange) || other.xchange == xchange)&&(identical(other.ychange, ychange) || other.ychange == ychange)&&(identical(other.tmax, tmax) || other.tmax == tmax)&&(identical(other.dtmax, dtmax) || other.dtmax == dtmax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parameters),const DeepCollectionEquality().hash(u0),xchange,ychange,tmax,dtmax);

@override
String toString() {
  return 'PhasePortraitRequest(parameters: $parameters, u0: $u0, xchange: $xchange, ychange: $ychange, tmax: $tmax, dtmax: $dtmax)';
}


}

/// @nodoc
abstract mixin class $PhasePortraitRequestCopyWith<$Res>  {
  factory $PhasePortraitRequestCopyWith(PhasePortraitRequest value, $Res Function(PhasePortraitRequest) _then) = _$PhasePortraitRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, double> parameters, List<double> u0, InitialValueVariation xchange, InitialValueVariation ychange, double tmax, double dtmax
});


$InitialValueVariationCopyWith<$Res> get xchange;$InitialValueVariationCopyWith<$Res> get ychange;

}
/// @nodoc
class _$PhasePortraitRequestCopyWithImpl<$Res>
    implements $PhasePortraitRequestCopyWith<$Res> {
  _$PhasePortraitRequestCopyWithImpl(this._self, this._then);

  final PhasePortraitRequest _self;
  final $Res Function(PhasePortraitRequest) _then;

/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parameters = null,Object? u0 = null,Object? xchange = null,Object? ychange = null,Object? tmax = null,Object? dtmax = null,}) {
  return _then(_self.copyWith(
parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,u0: null == u0 ? _self.u0 : u0 // ignore: cast_nullable_to_non_nullable
as List<double>,xchange: null == xchange ? _self.xchange : xchange // ignore: cast_nullable_to_non_nullable
as InitialValueVariation,ychange: null == ychange ? _self.ychange : ychange // ignore: cast_nullable_to_non_nullable
as InitialValueVariation,tmax: null == tmax ? _self.tmax : tmax // ignore: cast_nullable_to_non_nullable
as double,dtmax: null == dtmax ? _self.dtmax : dtmax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InitialValueVariationCopyWith<$Res> get xchange {
  
  return $InitialValueVariationCopyWith<$Res>(_self.xchange, (value) {
    return _then(_self.copyWith(xchange: value));
  });
}/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InitialValueVariationCopyWith<$Res> get ychange {
  
  return $InitialValueVariationCopyWith<$Res>(_self.ychange, (value) {
    return _then(_self.copyWith(ychange: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _PhasePortraitRequest implements PhasePortraitRequest {
  const _PhasePortraitRequest({required final  Map<String, double> parameters, required final  List<double> u0, required this.xchange, required this.ychange, required this.tmax, required this.dtmax}): _parameters = parameters,_u0 = u0;
  factory _PhasePortraitRequest.fromJson(Map<String, dynamic> json) => _$PhasePortraitRequestFromJson(json);

 final  Map<String, double> _parameters;
@override Map<String, double> get parameters {
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parameters);
}

 final  List<double> _u0;
@override List<double> get u0 {
  if (_u0 is EqualUnmodifiableListView) return _u0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_u0);
}

@override final  InitialValueVariation xchange;
@override final  InitialValueVariation ychange;
@override final  double tmax;
@override final  double dtmax;

/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhasePortraitRequestCopyWith<_PhasePortraitRequest> get copyWith => __$PhasePortraitRequestCopyWithImpl<_PhasePortraitRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhasePortraitRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhasePortraitRequest&&const DeepCollectionEquality().equals(other._parameters, _parameters)&&const DeepCollectionEquality().equals(other._u0, _u0)&&(identical(other.xchange, xchange) || other.xchange == xchange)&&(identical(other.ychange, ychange) || other.ychange == ychange)&&(identical(other.tmax, tmax) || other.tmax == tmax)&&(identical(other.dtmax, dtmax) || other.dtmax == dtmax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parameters),const DeepCollectionEquality().hash(_u0),xchange,ychange,tmax,dtmax);

@override
String toString() {
  return 'PhasePortraitRequest(parameters: $parameters, u0: $u0, xchange: $xchange, ychange: $ychange, tmax: $tmax, dtmax: $dtmax)';
}


}

/// @nodoc
abstract mixin class _$PhasePortraitRequestCopyWith<$Res> implements $PhasePortraitRequestCopyWith<$Res> {
  factory _$PhasePortraitRequestCopyWith(_PhasePortraitRequest value, $Res Function(_PhasePortraitRequest) _then) = __$PhasePortraitRequestCopyWithImpl;
@override @useResult
$Res call({
 Map<String, double> parameters, List<double> u0, InitialValueVariation xchange, InitialValueVariation ychange, double tmax, double dtmax
});


@override $InitialValueVariationCopyWith<$Res> get xchange;@override $InitialValueVariationCopyWith<$Res> get ychange;

}
/// @nodoc
class __$PhasePortraitRequestCopyWithImpl<$Res>
    implements _$PhasePortraitRequestCopyWith<$Res> {
  __$PhasePortraitRequestCopyWithImpl(this._self, this._then);

  final _PhasePortraitRequest _self;
  final $Res Function(_PhasePortraitRequest) _then;

/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parameters = null,Object? u0 = null,Object? xchange = null,Object? ychange = null,Object? tmax = null,Object? dtmax = null,}) {
  return _then(_PhasePortraitRequest(
parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,u0: null == u0 ? _self._u0 : u0 // ignore: cast_nullable_to_non_nullable
as List<double>,xchange: null == xchange ? _self.xchange : xchange // ignore: cast_nullable_to_non_nullable
as InitialValueVariation,ychange: null == ychange ? _self.ychange : ychange // ignore: cast_nullable_to_non_nullable
as InitialValueVariation,tmax: null == tmax ? _self.tmax : tmax // ignore: cast_nullable_to_non_nullable
as double,dtmax: null == dtmax ? _self.dtmax : dtmax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InitialValueVariationCopyWith<$Res> get xchange {
  
  return $InitialValueVariationCopyWith<$Res>(_self.xchange, (value) {
    return _then(_self.copyWith(xchange: value));
  });
}/// Create a copy of PhasePortraitRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InitialValueVariationCopyWith<$Res> get ychange {
  
  return $InitialValueVariationCopyWith<$Res>(_self.ychange, (value) {
    return _then(_self.copyWith(ychange: value));
  });
}
}


/// @nodoc
mixin _$SimulationRequest {

 Map<String, double> get parameters; List<double> get u0; double get tmax; double get dtmax;
/// Create a copy of SimulationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimulationRequestCopyWith<SimulationRequest> get copyWith => _$SimulationRequestCopyWithImpl<SimulationRequest>(this as SimulationRequest, _$identity);

  /// Serializes this SimulationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SimulationRequest&&const DeepCollectionEquality().equals(other.parameters, parameters)&&const DeepCollectionEquality().equals(other.u0, u0)&&(identical(other.tmax, tmax) || other.tmax == tmax)&&(identical(other.dtmax, dtmax) || other.dtmax == dtmax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parameters),const DeepCollectionEquality().hash(u0),tmax,dtmax);

@override
String toString() {
  return 'SimulationRequest(parameters: $parameters, u0: $u0, tmax: $tmax, dtmax: $dtmax)';
}


}

/// @nodoc
abstract mixin class $SimulationRequestCopyWith<$Res>  {
  factory $SimulationRequestCopyWith(SimulationRequest value, $Res Function(SimulationRequest) _then) = _$SimulationRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, double> parameters, List<double> u0, double tmax, double dtmax
});




}
/// @nodoc
class _$SimulationRequestCopyWithImpl<$Res>
    implements $SimulationRequestCopyWith<$Res> {
  _$SimulationRequestCopyWithImpl(this._self, this._then);

  final SimulationRequest _self;
  final $Res Function(SimulationRequest) _then;

/// Create a copy of SimulationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parameters = null,Object? u0 = null,Object? tmax = null,Object? dtmax = null,}) {
  return _then(_self.copyWith(
parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,u0: null == u0 ? _self.u0 : u0 // ignore: cast_nullable_to_non_nullable
as List<double>,tmax: null == tmax ? _self.tmax : tmax // ignore: cast_nullable_to_non_nullable
as double,dtmax: null == dtmax ? _self.dtmax : dtmax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SimulationRequest implements SimulationRequest {
  const _SimulationRequest({required final  Map<String, double> parameters, required final  List<double> u0, required this.tmax, required this.dtmax}): _parameters = parameters,_u0 = u0;
  factory _SimulationRequest.fromJson(Map<String, dynamic> json) => _$SimulationRequestFromJson(json);

 final  Map<String, double> _parameters;
@override Map<String, double> get parameters {
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parameters);
}

 final  List<double> _u0;
@override List<double> get u0 {
  if (_u0 is EqualUnmodifiableListView) return _u0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_u0);
}

@override final  double tmax;
@override final  double dtmax;

/// Create a copy of SimulationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SimulationRequestCopyWith<_SimulationRequest> get copyWith => __$SimulationRequestCopyWithImpl<_SimulationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SimulationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SimulationRequest&&const DeepCollectionEquality().equals(other._parameters, _parameters)&&const DeepCollectionEquality().equals(other._u0, _u0)&&(identical(other.tmax, tmax) || other.tmax == tmax)&&(identical(other.dtmax, dtmax) || other.dtmax == dtmax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parameters),const DeepCollectionEquality().hash(_u0),tmax,dtmax);

@override
String toString() {
  return 'SimulationRequest(parameters: $parameters, u0: $u0, tmax: $tmax, dtmax: $dtmax)';
}


}

/// @nodoc
abstract mixin class _$SimulationRequestCopyWith<$Res> implements $SimulationRequestCopyWith<$Res> {
  factory _$SimulationRequestCopyWith(_SimulationRequest value, $Res Function(_SimulationRequest) _then) = __$SimulationRequestCopyWithImpl;
@override @useResult
$Res call({
 Map<String, double> parameters, List<double> u0, double tmax, double dtmax
});




}
/// @nodoc
class __$SimulationRequestCopyWithImpl<$Res>
    implements _$SimulationRequestCopyWith<$Res> {
  __$SimulationRequestCopyWithImpl(this._self, this._then);

  final _SimulationRequest _self;
  final $Res Function(_SimulationRequest) _then;

/// Create a copy of SimulationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parameters = null,Object? u0 = null,Object? tmax = null,Object? dtmax = null,}) {
  return _then(_SimulationRequest(
parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, double>,u0: null == u0 ? _self._u0 : u0 // ignore: cast_nullable_to_non_nullable
as List<double>,tmax: null == tmax ? _self.tmax : tmax // ignore: cast_nullable_to_non_nullable
as double,dtmax: null == dtmax ? _self.dtmax : dtmax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
