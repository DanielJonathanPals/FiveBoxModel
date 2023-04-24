# Here the dynamics of the phase space is specified

include("RHS.jl")


"""
    PhaseDynamics

A mutable struct which encodes the RHS of the dynamics of the phase space

# Fields
- 'f::Function': Describes the deterministic dynamics in phase space with 'f' of the from
    'f(du,u,p,t)' with 'length(du) = length(u) = 26' and 'u' contains all the salinities
    together with all the parameter values.
- 'g::Function': Describes the stochastic dynamics in phase space and is of the same form
    as 'f'.
- 'update::Union{Function,Nothing} = nothing': This function describes how to update 'g' and 
    'f' if 'update!' is applied to the respective object of the type 'PhaseDynamics'. 
    I.e. this function has takes argument and returns new functions 'f' and 'g' based of this 
    argument. If 'update = nothing' then 'f' and 'g' remain unchanged.

If only 'f' and 'g' are given then 'update' will be initialized to 'update = nothing'
"""
mutable struct PhaseDynamics
    f::Function
    g::Function
    update::Union{Function,Nothing}
end

PhaseDynamics(f::Function, g::Function) = PhaseDynamics(f,g,nothing)


"""
    update!(pd::PhaseDynamics, additionalInformation)

Updates the function 'pd.g' of the PhaseDynamics object according the to update rules specified in the
function 'pd.update'. The argument 'updateInformation' must be such that it suits 'pd.update'.
"""
function update!(pd::PhaseDynamics, updateInformation)
    if !(pd.update === nothing)
        pd.g = pd.update(updateInformation)
    end
end


function deterministic_salinity_dynamics!(du, u, p, t)
    du[1:5] = [rhs_S_N(u),rhs_S_T(u),rhs_S_S(u),rhs_S_IP(u),rhs_S_B(u)]
end


function no_stochstic_salinity_dynamics!(du, u, p, t)
    du[1:5] = 0
end


DeterministicPhaseDynamics = PhaseDynamics(deterministic_salinity_dynamics!,
                                            no_stochstic_salinity_dynamics!)

