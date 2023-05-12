# Here the dynamics of the phase space is specified

using .RHS_module


"""
    PhaseDynamics

A mutable struct which encodes the RHS of the dynamics of the phase space

# Fields
- `f!::Function`: Describes the deterministic dynamics in phase space with `f!` of the from
    `f!(du,u,t_0,t)` with `length(du) = length(u) = 26` and `u` contains all the salinities
    together with all the parameter values. Since the system in run in sub-time-intervals
    the current time is given by `t+t_0` which which is relevent it the system is non autonomous.
    Also note that all times are given in the unit of years in order to avoid very large numbers 
    for `t`.
- `g!::Function`: Describes the stochastic dynamics in phase space and is of the same form
    as `f!`.
- `noise_rate_prototype::Matrix{Float64}`: Is some Matrix with the same dimensions as the `du` 
    argument in `g!` which is later needed to set up the `SEDProblem` from the DifferentialEquations
    package. If `noise_rate_prototype === nothing` then diagonal noise is used and `du` has the
    form of a Vector. Note that `noise_rate_prototype` must be the same must have the same sizes
    for corresponding instances of the ParameterDynamics and PhaseDynamics strucs.

If only `f!` and `g!` are given then `update` will be initialized to `update = nothing`
"""
mutable struct PhaseDynamics
    f!::Function
    g!::Function
    noise_rate_prototype::Union{Matrix{Float64},Nothing}
end

"""
    PhaseDynamics(f!::Function, 
                    g!::Function;   
                    noise_rate_prototype::Union{Matrix{Float64},Nothing} = nothing)
                    
Alternative instantiation which returns an object of `ParameterDynamics`.
"""
function PhaseDynamics(f!::Function, 
                        g!::Function;   
                        noise_rate_prototype::Union{Matrix{Float64},Nothing} = nothing)
    PhaseDynamics(f!,g!,noise_rate_prototype)
end


"""
    deterministic_salinity_dynamics!(du, u, t_0, t)

This function encodes the deterministic part of the ODEs describing the dynamics of the parameters
    in the case where the deterministic evolution of the salinities in time is given by the respective
    equations of motion (the modified versions). This can be used
    as argument for `f!` when ceating an instance of the type `ParameterDynamics`.
"""
function deterministic_salinity_dynamics!(du, u, t_0, t)
    du[get_index["salinities"]] = [rhs_S_N(u),rhs_S_T(u),rhs_S_S(u),rhs_S_IP(u),rhs_S_B(u)]
end


"""
    deterministic_salinity_dynamics!(du, u, t_0, t)

This function encodes the deterministic part of the ODEs describing the dynamics of the parameters
    in the case where the deterministic evolution of the salinities in time is given by the respective
    equations of motion (the original equations as given in the paper). This can be used
    as argument for `f!` when ceating an instance of the type `ParameterDynamics`.
"""
function original_deterministic_salinity_dynamics!(du, u, t_0, t)
    du[get_index["salinities"]] = [rhs_S_N(u,original=true),
                                    rhs_S_T(u,original=true),
                                    rhs_S_S(u,original=true),
                                    rhs_S_IP(u,original=true),
                                    rhs_S_B(u,original=true)]
end


"""
    no_stochastic_salinity_dynamics!(du, u, t_0, t)

This function encodes the stochastic part of the ODEs describing the dynamics of the salinities
    in the case where this part is zero. This can be used
    as argument for `g!` when ceating an instance of the type `ParameterDynamics`.
"""
function no_stochstic_salinity_dynamics!(du, u, t_0, t)
    du[get_index["salinities"]] .= 0
end


"""
    DeterministicPhaseDynamics

This is a preset of the type `PhaseDynamics` where the salinity evolutions is fully deterministic and
    given by the modified equations.
"""
DeterministicPhaseDynamics = PhaseDynamics(deterministic_salinity_dynamics!,
                                            no_stochstic_salinity_dynamics!)

"""
    OriginalDeterministicPhaseDynamics

This is a preset of the type `PhaseDynamics` where the salinity evolutions is fully deterministic and
    given by the original equations from the paper.
"""
OriginalDeterministicPhaseDynamics = PhaseDynamics(original_deterministic_salinity_dynamics!,
                                                    no_stochstic_salinity_dynamics!)

