module FiveBoxModel

export linearization
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


using Reexport: @reexport

include("RHS_module.jl")
@reexport using .RHS_module

include("Plot.jl")
include("RunSystem.jl")
include("Linearization.jl")

end