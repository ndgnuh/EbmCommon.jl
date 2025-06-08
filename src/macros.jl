# TODO: implement the following syntax
"""
@generate_model begin
    parameter_type = ModelParams
    variables = [N, P]
end
"""

"Recursively convert dictionary to named tuple"
rnamedtuple(d::AbstractDict) = (; (Symbol(k) => rnamedtuple(v) for (k, v) in d)...)
rnamedtuple(arr::AbstractArray) = map(rnamedtuple, arr)
rnamedtuple(v::Any) = v

"""
Debugging tips:

- `Meta.@dump`
- `Base.var"@macroname"`
- `@macroexpand`
"""
function _generate_model_params(name, specs::ModelSpecs)
    # Generate fields definition
    params = specs.parameters
    fields = map(params) do param
        paramdef = Expr(:(::), param.name, Float64)
        defaultval = Expr(:(=), paramdef, param.default)
        return defaultval
    end

    # Generate struct definition
    mutable = false
    structname = Expr(:(<:), name,
        Expr(:(.), @__MODULE__, QuoteNode(:AbstractEbmParams)))
    struct_expr = Expr(
        :struct, mutable, structname,
        Expr(:block, fields...)
    )

    # Call kwdef macro
    kwdef = Base.var"@kwdef"
    kwdef(LineNumberNode(@__LINE__, @__FILE__),
        @__MODULE__, struct_expr)
end

"""
Generate a model parameters from specification.

Exmaple:

```julia
@generate_model_params ModelParams model_specifications
```
"""
macro generate_model_params(name, specs)
    return _generate_model_params(name, eval(specs))
end

