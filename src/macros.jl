using MacroTools
using DocStringExtensions

@kwdef struct ParameterField{S, T}
    name::Symbol
    type::S
    is_parametric::Bool
    formulation::T
    hidden::Bool
end

"""
$TYPEDFIELDS

Speficiation for a struct
"""
@kwdef struct StructSpecs{T}
    "Struct name"
    name::Symbol
    "Supertype of the struct, can be Symbol or Expr or Nothing"
    supertype::T
    "Fields of the struct"
    fields::Vector{ParameterField}
    "Parametric types used in the struct"
    params::Vector{Symbol}
end


function is_free(pf::ParameterField)
    return isnothing(pf.formulation)
end

function make_type(
        name::Symbol,
        free_fields::Vector{Symbol},
        dependent_fields::Vector{Symbol},
    )
end

function parse_struct(root::Expr; __module__)
    if root.head != :struct
        error("Expected a struct definition")
    end

    #= is_mutable = root.args[1] =#
    name_expr = root.args[2]
    pfields = ParameterField[]

    # Parse struct name and supertype
    struct_name, super_type, parametrics::Vector{Symbol} = if @capture(name_expr, name_{P__} <: super_)
        (name, super, P)
    elseif @capture(name_expr, name_{P__})
        (name, nothing, P)
    elseif @capture(name_expr, name_ <: super_)
        (name, super, Symbol[])
    elseif name_expr isa Symbol
        (name_expr, nothing, Symbol[])
    else
        dump(name_expr)
        error("Unrecognized struct definition $name_expr")
    end

    function handle_escape(expr)
        return MacroTools.postwalk(expr) do f
            if f isa Expr && f.head == :$
                escaped = f.args[1]
                return __module__.eval(escaped)
            end
            return f
        end
    end

    # Collect field names, types and defaults/formulations
    fields = root.args[end].args
    for field in fields
        if field isa LineNumberNode
            continue
        end

        hidden = false
        if @capture(field, @hide(macroexpr_))
            hidden = true
            field = macroexpr
        end
        if @capture(field, fname_::ftype_ = fdefault_)
            pfield = ParameterField(;
                name = fname,
                type = handle_escape(ftype),
                is_parametric = false,
                formulation = handle_escape(fdefault),
                hidden = hidden,
            )
            push!(pfields, pfield)
        elseif @capture(field, fname_::ftype_)
            pfield = ParameterField(;
                name = fname,
                type = handle_escape(ftype),
                is_parametric = false,
                formulation = nothing,
                hidden = hidden,
            )
            push!(pfields, pfield)
        elseif @capture(field, fname_ = fdefault_)
            T = gensym(:T)
            pfield = ParameterField(;
                name = fname,
                type = T,
                is_parametric = true,
                formulation = handle_escape(fdefault),
                hidden = hidden,
            )
            push!(parametrics, T)
            push!(pfields, pfield)
        elseif field isa Symbol
            T = gensym(:T)
            pfield = ParameterField(;
                name = field,
                type = T,
                is_parametric = true,
                formulation = nothing,
                hidden = hidden,
            )
            push!(parametrics, T)
            push!(pfields, pfield)
        else
            error("Unrecognized field format: $field")
        end
    end

    specs = StructSpecs(;
        name = struct_name,
        supertype = super_type,
        fields = pfields,
        params = unique(parametrics),
    )

    validate_fields(specs)

    return specs
end

"""
Check struct specifications for:

- Duplicate field names
"""
function validate_fields(specs::StructSpecs)
    field_names = Set{Symbol}()
    for field in specs.fields
        if field.name in field_names
            error("Duplicate field name: $(field.name)")
        end
        push!(field_names, field.name)
    end
    return
end

function generate_struct(specs::StructSpecs)
    # Struct name expression
    name = specs.name
    params = specs.params
    supertype = specs.supertype
    structname = if isnothing(supertype)
        :($name{$(params...)})
    else
        :($name{$(params...)} <: $(esc(supertype)))
    end

    # Fields expression
    field_exprs = Expr[]
    for field in specs.fields
        field_name = field.name
        field_type = field.type
        field_expr = :($field_name::$field_type)
        push!(field_exprs, field_expr)
    end

    # Struct expression, immutable by default
    constructor_defs = generate_constructor(specs)
    return :(
        struct $(structname)
            $(field_exprs...)
            $(constructor_defs...)
        end
    )
end

"""
Expand the pseudo macro @everything to all the local variables keyword arguments
"""
function expand_local_variables(expr, local_vars::Vector{Symbol})
    return MacroTools.postwalk(expr) do f
        if f isa Expr && f.head == :parameters
            new_args = mapreduce(vcat, f.args) do arg
                if @capture(arg, @everything)
                    local_vars
                else
                    [arg]
                end
            end
            return Expr(:parameters, new_args...)
        end
        return f
    end
end

function generate_constructor(specs::StructSpecs)
    name = specs.name

    # Function arguments
    kwarg_exprs = Union{Symbol, Expr}[]
    # Depentdent parameters
    dep_exprs = Expr[]
    # Argument for the default constructor
    arg_exprs = Symbol[]
    # Type parameters
    type_params_exprs = Expr[]


    # Collect keyword arguments and dependent expressions
    for field in specs.fields
        name = field.name
        formulation = field.formulation
        if field.is_parametric
            push!(type_params_exprs, :(typeof($name)))
        end
        if formulation isa Expr || formulation isa Symbol
            # Calculation of dependent parameters
            # Expand @everything to local variables that are available at this point
            if formulation isa Expr
                formulation = expand_local_variables(formulation, arg_exprs)
            end
            push!(dep_exprs, :($name = $formulation))
        else
            # Free parameters
            default = field.formulation
            if isnothing(default)
                push!(kwarg_exprs, name)
            else
                # keyword in function arguments is
                # not the equal node, it is :kw
                push!(kwarg_exprs, Expr(:kw, name, default))
            end
        end

        # Has to be after formulation expansion
        # Otherwise the current symbol will be included in the expansion
        # of @everything
        push!(arg_exprs, name)
    end

    struct_name = specs.name

    # Keep args to make it compat to Accessors.jl
    # Do not use free_arg_exprs here, it will mess up if the order
    # of fields is changed. (e.g. free field after dependent field)
    args_constructor = :(
        function $struct_name($(arg_exprs...))
            $(dep_exprs...)
            return new{$(type_params_exprs...)}($(arg_exprs...))
        end
    )

    kwargs_constructor = :(
        function $(specs.name)(; $(kwarg_exprs...))
            $(dep_exprs...)
            return new{$(type_params_exprs...)}($(arg_exprs...))
        end
    )

    return args_constructor, kwargs_constructor
end

function generate_print_override(specs)
    struct_name = specs.name
    print_exprs = Expr[]
    obj = gensym()
    io = gensym()

    # Print struct name
    struct_name_expr = Expr(:string, "$struct_name:")
    push!(print_exprs, :(println($io, $struct_name_expr)))

    # Print the parameters
    # Breaks every i % 4 == 0
    push!(print_exprs, :(print($io, "\t")))
    fields = [field for field in specs.fields if !field.hidden]
    n = length(fields)
    for (i, field) in enumerate(fields)
        field_name = field.name
        field_value_expr = :($obj.$field_name)
        field_type_expr = :(typeof($obj.$field_name))
        string_expr = Expr(
            :string,
            "$field_name::",
            field_type_expr,
            " = ",
            field_value_expr
        )
        print_expr = :(print($io, $string_expr))
        push!(print_exprs, print_expr)
        if i != n
            push!(print_exprs, :(print($io, ",\n\t")))
        end
    end

    return :(
        function Base.show($io::IO, $obj::$(esc(struct_name)))
            $(print_exprs...)
        end
    )
end

"""
Generate a struct that holds parameters.

Each fields will be of parametric type.
"""
macro params(expr)
    println(__module__)

    specs = parse_struct(expr; __module__)
    struct_def = generate_struct(specs)
    print_def = generate_print_override(specs)
    return :($struct_def; $print_def)
end
