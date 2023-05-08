module FiveBoxModel

export jacobian
export get_eigvals

export ParameterDynamics
export no_deterministic_param_dynamics!
export no_stochastic_param_dynamics!
export fixedParameters

export PhaseDynamics
export deterministic_salinity_dynamics!
export original_deterministic_salinity_dynamics!
export no_stochstic_salinity_dynamics!
export DeterministicPhaseDynamics
export OriginalDeterministicPhaseDynamics

export ParameterSet
export FAMOUSparams

export SinglePlot
export createSinglePlot
export combine_plots

export RunParameters
export runSystem

export System
export FAMOUS

export System
export FAMOUS

export ParameterSet
export updateParameterSet!
export FAMOUSparams

export toArray
export updateSystem!

export rhs_S_N
export rhs_S_S
export rhs_S_T
export rhs_S_IP
export rhs_S_B

export get_q

export get_index
export get_S_N
export get_S_T
export get_S_S
export get_S_IP
export get_S_B
export get_λ
export get_α
export get_β
export get_γ
export get_η
export get_μ
export get_V_N
export get_V_S
export get_V_T
export get_V_IP
export get_V_B
export get_K_N
export get_K_S
export get_K_IP
export get_F_N
export get_F_S
export get_F_T
export get_F_IP
export get_S_0
export get_T_0
export get_T_S

include("RHS_module.jl")
include("Plot.jl")
include("RunSystem.jl")
include("Linearization.jl")

end