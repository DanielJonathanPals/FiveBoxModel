# Here the dynamics of the phase space is specified

include("RHS.jl")


"""
    PhaseDynamics

A mutable struct which encodes the RHS of the dynamics of the phase space

# Fields
- 'f!::Function': Describes the deterministic dynamics in phase space with 'f!' of the from
    'f!(du,u,t_0,t)' with 'length(du) = length(u) = 26' and 'u' contains all the salinities
    together with all the parameter values. Since the system in run in sub-time-intervals
    the current time is given by 't+t_0' which which is relevent it the system is non autonomous.
    Also note that all times are given in the unit of years in order to avoid very large numbers 
    for t.
- 'g!::Function': Describes the stochastic dynamics in phase space and is of the same form
    as 'f!'.
- 'noise_rate_prototype::Matrix{Float64}': Is some Matrix with the same dimensions as the 'du' 
    argument in 'g!' which is later needed to set up the 'SEDProblem' from the DifferentialEquations
    package. If 'noise_rate_prototype === nothing' then diagonal noise is used and 'du' has the
    form of a Vector. Note that 'noise_rate_prototype' must be the same must have the same sizes
    for corresponding instances of the ParameterDynamics and PhaseDynamics strucs.
- 'update::Union{Function,Nothing} = nothing': This function describes how to update 'g!' and 
    'f!' if 'update!' is applied to the respective object of the type 'PhaseDynamics'. 
    I.e. this function has takes argument and returns new functions 'f!' and 'g!' based of this 
    argument. If 'update = nothing' then 'f!' and 'g!' remain unchanged.

If only 'f!' and 'g!' are given then 'update' will be initialized to 'update = nothing'
"""
mutable struct PhaseDynamics
    f!::Function
    g!::Function
    noise_rate_prototype::Union{Matrix{Float64},Nothing}
    update::Union{Function,Nothing}
end

function PhaseDynamics(f!::Function, 
                        g!::Function,   
                        noise_rate_prototype::Union{Matrix{Float64},Nothing} = nothing)
    PhaseDynamics(f!,g!,noise_rate_prototype,nothing)
end


"""
    update!(pd::PhaseDynamics, additionalInformation)

Updates the function 'pd.g' of the PhaseDynamics object according the to update rules specified in the
function 'pd.update'. The argument 'pastTraj' entails the information of the so far
recorded trajectory.
"""
function update!(pd::PhaseDynamics, pastTraj)
    if !(pd.update === nothing)
        pd.g! = pd.update(pastTraj)
    end
end


function deterministic_salinity_dynamics!(du, u, t_0, t)
    du[1:5] = [rhs_S_N(u),rhs_S_T(u),rhs_S_S(u),rhs_S_IP(u),rhs_S_B(u)]
end


function no_stochstic_salinity_dynamics!(du, u, t_0, t)
    du[1:5] .= 0
end


DeterministicPhaseDynamics = PhaseDynamics(deterministic_salinity_dynamics!,
                                            no_stochstic_salinity_dynamics!)

