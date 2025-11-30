"""
Construct an instance of type `T` from keyword arguments, ignoring any
unexpected keywords.
"""
function construct_from_kwargs(T::Type; kwargs...)
    options = Dict(k => v for (k, v) in kwargs if k in fieldnames(T))
    return T(; options...)
end

"""
$TYPEDSIGNATURES

Get a string listing the field names of type `T` for quick documentation.
"""
function options_for(T::Type)
    return mapreduce((s...) -> join(s, ", "), fieldnames(T)) do name
        "`$name`"
    end
end


"""
$TYPEDSIGNATURES

Colect a component of the simulation output over time.
"""
get_compartment(u, i::Integer) = map(u -> u[i], u)

"""
$TYPEDSIGNATURES

Collect multiple components of the simulation output over time, the output component
is the sum of the components at each time step.
"""
get_compartment(u, indices) = map(u -> sum(u[i] for i in indices), u)

"""
$TYPEDSIGNATURES

Convenience function to get a compartment from the `ODESolution`.
"""
get_compartment(sol::ODESolution, i) = get_compartment(sol.u, i)

"""
$TYPEDSIGNATURES

Check Routh-hurwitz stability for polynomial of order 1, 2, 3 and 4.

The polynomial coefficients correspond to the order of the polynomial:

  - `a0` - coefficient of x^0
  - `a1` - coefficient of x^1
  - `a2` - coefficient of x^2
  - `a3` - coefficient of x^3
    and so on.
"""
function check_routh_hurwitz(a01234...)
    cond = all(a01234 .> 0)
    n = length(a01234)
    if n > 3
        a0, a1, a2, a3 = a01234
        cond &= a2 * a1 - a0 * a3 > 0
    end
    if n > 4
        a0, a1, a2, a3, a4 = a01234
        cond &= a3 * a2 * a1 - a4 * a1^2 - a3^2 * a0 > 0
    end
    if n > 5
        @error "Unsupported"
    end
    return cond
end
