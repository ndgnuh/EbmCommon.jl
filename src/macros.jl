"""
Macro module
============

Support this kind of syntax:

```julia
@ebmspecs begin
	time_axis_name = "time"
	state_axis_name = "biomass"
	variables = [
		x::Float64 = 0.9 description = "preys" latexname = "x";
		y::Float64 = 0.2 desc = "predators";
	]
	parameters = PredatorPreyParams[
		α::Float64 = 1 description = "preys" latex = raw"\alpha";
		β::Float64 = 1 description = "predators" latexname = raw"\beta";
	]
end
```

Debugging tips
==============

- `Meta.@dump`
- `Base.var"@macroname"`
- `@macroexpand`
"""
module Macros

import ..EbmCommon
import ..EbmCommon: AbstractEbmParams
import ..EbmCommon: VariableSpecs
import ..EbmCommon: ParameterSpecs
import ..EbmCommon: ModelSpecs
import ..EbmCommon: get_model_specifications
import ..EbmCommon: number_of_variables
using MacroTools

function _variable_specs(expr)
    @capture(expr, variables = variables_info_) || throw("No variable found")
    @assert variables_info.head == :vcat "Malformed variable expressions"
    # return variables_info
    varspecs = map(variables_info.args |> enumerate) do (i, var_info)
        # Varinfo is a Expr(:row, ...), 
        # it can not becaptured by @capture macro
        @assert var_info.head == :row "Malformed variable expression"

        # Build a list of keyword arguments
        specs = Expr[Expr(:kw, :index, i)]
        for expr in var_info.args
            if @capture(expr, (desc = desc_) | (description = desc_))
                push!(specs, Expr(:kw, :description, desc))
                continue
            elseif @capture(expr, latexname = latex_)
                push!(specs, Expr(:kw, :latexname, latex))
                continue
            elseif @capture(expr, varname_::T_ = vardefault_) || @capture(expr, varname_ = vardefault_)
                push!(specs, Expr(:kw, :name, QuoteNode(varname)))
                push!(specs, Expr(:kw, :default, vardefault))
                continue
            end
        end

        # Create function call
        # The expression of function call looks something like
        # (:call, :f, (:parameters, kw1, kw2, ...))
        Expr(:call, :VariableSpecs, Expr(:parameters, specs...))
    end

    # Make an array of variable specs
    specs_expr = Expr(:vcat, varspecs...)
    num_variables = length(varspecs)
    specs_expr, num_variables
end

macro _variable_specs(expr)
    return _variable_specs(expr)[1]
end

@doc """
A macro that turns this syntax into a vector of `VariableSpecs`.

```julia
variables = [
	x::Float64 = 0.9 description = "preys" latexname = "x";
	y::Float64 = 0.2 desc = "predators";
] 
```
"""
_variable_specs, var"@_variable_specs"



"Recursively convert dictionary to named tuple"
rnamedtuple(d::AbstractDict) = (; (Symbol(k) => rnamedtuple(v) for (k, v) in d)...)
rnamedtuple(arr::AbstractArray) = map(rnamedtuple, arr)
rnamedtuple(v::Any) = v

function _parameter_specs(expr)
	@capture(expr, parameters = parameters_info_) || throw("No parameter found")
	@assert parameters_info.head == :typed_vcat "Malformed parameter expressions"
	
	struct_name = parameters_info.args[1]
	struct_rows = parameters_info.args[2:end]
	
	names = Symbol[]
	types = Symbol[]
	default_values = []
	
	# ParameterSpecs call
	specs = map(struct_rows |> enumerate) do (i, var_info)
		# Varinfo is a Expr(:row, ...), 
		# it can not becaptured by @capture macro
		@assert var_info.head == :row "Malformed parameter expression"

		# Build a list of keyword arguments
		specs = Expr[]
		for expr in var_info.args
			if @capture(expr, (desc = desc_) | (description = desc_))
				push!(specs, Expr(:kw, :description, desc))
				continue
			elseif @capture(expr, (latexname = latex_) | (latex = latex_))
				push!(specs, Expr(:kw, :latexname, latex))
				continue
			elseif @capture(expr, alias = alias_)
				push!(specs, Expr(:kw, :alias, alias))
				continue
			elseif @capture(expr, varname_::T_ = vardefault_) || @capture(expr, varname_ = vardefault_)
				push!(specs, Expr(:kw, :name, QuoteNode(varname)))
				push!(specs, Expr(:kw, :default, vardefault))
				T = something(T, Float64)

				# Store global information
				push!(names, varname)
				push!(types, T)
				push!(default_values, vardefault)
				continue
			end
		end

		# Create function call
		# The expression of function call looks something like
		# (:call, :f, (:parameters, kw1, kw2, ...))
		Expr(:call, :ParameterSpecs, Expr(:parameters, specs...))
	end

	# Make an array of parameter specs
	specs_array_expr = Expr(:vcat, specs...)

	# Make struct definition
	params = zip(names, types, default_values)
	fields_expr = map(params) do (name, T, value)
        Expr(:(::), name, T)
    end
	struct_expr = let mutable = false
	    structname = Expr(:(<:), struct_name, :(EbmCommon.AbstractEbmParams))
	    expr = Expr(:struct, mutable, structname, Expr(:block, fields_expr...))
	end	

	# Make kwdef constructur expr
	# struct_path = Expr(:(.), CurrentModule, QuoteNode(struct_name))
	struct_path = struct_name
	constructor_expr = let
		kws = map(params) do (name, T, value)
			Expr(:kw, name, value)
		end
		kwparams = Expr(:parameters, kws...)

		fn_head = Expr(:call, struct_path, kwparams)
		fn_body = Expr(:block, Expr(:call, struct_name, names...))
		Expr(:(=), esc(fn_head), esc(fn_body))
	end
	specs_array_expr, struct_expr, constructor_expr, struct_name
end

function _model_specs(expr)
    expr = Base.remove_linenums!(expr)
    variables_expr = Ref{Expr}()
    param_specs_expr = Ref{Expr}()
    param_structs_expr = Ref{Expr}()
    constructor_expr = Ref{Expr}()
    struct_name = Ref{Symbol}()
    _number_of_variables = Ref{Int}()
    time_axis_name = :("Time")
    state_axis_name = :("State")
    for expr in expr.args
        if @capture(expr, variables = variables_info_)
            (
                variables_expr[],
                _number_of_variables[]
            ) = _variable_specs(expr)
        elseif @capture(expr, time_axis_name = time_axis_name_value_)
            time_axis_name = time_axis_name_value
        elseif @capture(expr, state_axis_name = state_axis_name_value_)
            state_axis_name = state_axis_name_value
        elseif @capture(expr, parameters = parameters_expr_)
            a, b, c, d = _parameter_specs(expr)
            param_specs_expr[] = a
            param_structs_expr[] = b
            constructor_expr[] = c
            struct_name[] = d
        end
    end

    # Model specification creation
    model_specs_expr = Expr(:call, :(EbmCommon.ModelSpecs),
        Expr(:parameters,
            Expr(:kw, :variables, variables_expr[]),
            Expr(:kw, :parameters, param_specs_expr[]),
            Expr(:kw, :time_axis_name, time_axis_name),
            Expr(:kw, :state_axis_name, state_axis_name)))

    # Block of model specs + parameter type
    # struct_path = Expr(:(.), CurrentModule, QuoteNode(struct_name[]))
    struct_path = struct_name[]


    # f(::MyType)
    # f(::Type{MyType})
    type_ex_1 = Expr(:(::), esc(struct_path))
    type_ex_2 = Expr(:(::), Expr(:curly, :Type, esc(struct_path)))

    # EbmCommon.get_model_specifications
    get_model_specifications_expr = let
        fn_path = Expr(:(.), :EbmCommon,
                       QuoteNode(:get_model_specifications))
        call_ex_1 = Expr(:call, fn_path, type_ex_1)
        call_ex_2 = Expr(:call, fn_path, type_ex_2)
        fn_ex_1 = Expr(:(=), call_ex_1, model_specs_expr)
        fn_ex_2 = Expr(:(=), call_ex_2, model_specs_expr)
        fn_ex_1, fn_ex_2
    end

    # EbmCommon.number_of_variables
    number_of_variables_expr = let
        fn_path = Expr(:(.), :EbmCommon,
                       QuoteNode(:number_of_variables))
        call_ex_1 = Expr(:call, fn_path, type_ex_1)
        call_ex_2 = Expr(:call, fn_path, type_ex_2)
        fn_ex_1 = Expr(:(=), call_ex_1, _number_of_variables[])
        fn_ex_2 = Expr(:(=), call_ex_2, _number_of_variables[])
        fn_ex_1, fn_ex_2
    end

    quote
        $(param_structs_expr[])
        $(constructor_expr[])
        $(get_model_specifications_expr[1])
        $(get_model_specifications_expr[2])
        $(number_of_variables_expr[1])
        $(number_of_variables_expr[2])
    end
end


"""
Quickly create a model using the below syntax.

- Auto create the parameter type (`PredatorPreyParams` in the example)
- Auto implement `numner_of_variables` and `get_model_specifications`

```julia
@ebmspecs begin
	time_axis_name = "time"
	state_axis_name = "biomass"
	variables = [
		x::Float64 = 0.9 description = "preys" latexname = "x";
		y::Float64 = 0.2 desc = "predators";
	]
	parameters = PredatorPreyParams[
		α::Float64 = 1 description = "preys" latex = raw"\alpha";
		β::Float64 = 1 description = "predators" latexname = raw"\beta";
	]
end
```
"""
macro ebmspecs(expr)
    _model_specs(expr)
end

end
