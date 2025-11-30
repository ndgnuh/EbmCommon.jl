using DiffEqCallbacks
using LinearAlgebra
using RequiredInterfaces

@compat public check_implementation
@compat public test_routh_hurwiz_coefficients
@compat public test_jacobian

"""Module to check if a given type implementing `AbstractEbmParams`"""
function check_implementation(T::Type)
    failures = RequiredInterfaces.check_interface_implemented(AbstractEbmParams, T)
    if failures isa Bool
        return true, nothing
    else
        return isempty(failures), failures
    end
end

function test_routh_hurwiz_coefficients(params, i::Integer; exclude_roots = Set())
    E = get_equilibria(params)[i]
    coeffs_machine = machine.get_routh_hurwiz_coefficients(params, E; exclude_roots)
    coeffs_theoretical = get_routh_hurwiz_coefficients(params, i)
    if length(coeffs_machine) != length(coeffs_theoretical)
        @error """
        Coefficients are not the same length, check your implementation
        Theoretical: $coeffs_theoretical
        Machine: $coeffs_machine
        """
    end
    ok = all(coeffs_machine .≈ coeffs_theoretical)
    if !ok
        @warn """
        Routh-Hurwitz coefficients do not match.
        Theoretical: $coeffs_theoretical
        Machine: $coeffs_machine
        """
    end
    return ok
end

"""
$TYPEDSIGNATURES

Check if the jacobian calculated using ForwardDiff
and the jacobian using derived formula at some random states
to check if the formulation is correctly calculated and implemented
"""
function test_jacobian(params::T; num_tests = 30) where {T <: AbstractEbmParams}
    n = number_of_variables(T)
    for _ in 1:num_tests
        u0 = rand(n)
        J_machine = machine.jacobian(params, u0)
        J_hand = jacobian(params, u0)
        if !all(J_machine .≈ J_hand)
            return false
        end
    end

    # Also test at the equilibria
    for u0 in get_equilibria(params)
        J_machine = machine.jacobian(params, u0)
        J_hand = jacobian(params, u0)
        if !all(J_machine .≈ J_hand)
            return false
        end
    end
    return true
end

"""
$(SIGNATURES)

Test that stable equilibria are indeed stable by simulating the system from a perturbed initial condition near each stable equilibrium and checking if the system returns to the equilibrium within a specified tolerance.

Testing multiple compositions of parameters should be done to sweep
all the possible equilibria...
"""
function test_stable_equilbrium(
        params::T;
        tspan = (0, 500_000),
        tol = 5.0e-3,
    ) where {T <: AbstractEbmParams}
    @info "Testing stable equilibria for parameter type $(T)..."
    equilibria = get_equilibria(params)
    local_stabilities = get_local_stabilities(params)
    ok = true
    iterator = enumerate(zip(equilibria, local_stabilities))
    callback = TerminateSteadyState()

    for (i, (eq, is_stable)) in iterator
        # Unstable equilibria are not tested
        if !is_stable
            continue
        end

        # Simulate from the equilibrium plus a small random perturbation
        # If it is locally stable, the system should return to it
        u0 = eq .+ 0.1 * randn(length(eq))
        sol = _simulate(params, u0, tspan; solver_options = (; callback))
        final_state = sol.u[end]

        # Check if the final state is close to the equilibrium
        if norm(final_state .- eq) > tol
            @error """
            Equilibrium $i is marked as stable but simulation did not return to it.
            Theoretical equilibrium: $eq
            Final state from simulation: $final_state
            """
            ok = false
        end
    end
    return ok
end
