```@meta
CurrentModule = FiveBoxModel
```

# Integrate a System

In order to integrate a given System an instance of type `RunParameters` must be created which encodes all relevant information needed for the integration of the system.

```@docs
RunParameters
RunParameters(sys;
                updateInterval = 1.,
                t_max = 10.,
                dt = 0.001,
                phaseDyn = DeterministicPhaseDynamics,
                paramDyn = fixedParameters)
```

Then the system can simply be integrated using

```@docs
runSystem
```

## Example

```jldoctest
julia> using FiveBoxModel

julia> rp = RunParameters(FAMOUS)
RunParameters(System([35.088, 35.67, 34.441, 34.689, 34.577], ParameterSet(2.66, 0.12, 0.79, 0.58, 66.061, 7.0, 3.683, 10.28, 5.151, 21.29, 88.12, 5.439, 1.88, 89.778, 0.375, 1.014, -0.723, -0.666, 0.035, 3.26, 5.571)), 1.0, 10.0, 0.001, PhaseDynamics(FiveBoxModel.deterministic_salinity_dynamics!, FiveBoxModel.no_stochstic_salinity_dynamics!, nothing, nothing), ParameterDynamics(FiveBoxModel.no_deterministic_param_dynamics!, FiveBoxModel.no_stochastic_param_dynamics!, nothing, nothing))

julia> traj,t = runSystem(rp)
Starting to integrate System...
the total time interval is subdivided into 10 subintervals

Starting to integrate subinterval 1 / 10

Starting to integrate subinterval 2 / 10

Starting to integrate subinterval 3 / 10

Starting to integrate subinterval 4 / 10

Starting to integrate subinterval 5 / 10

Starting to integrate subinterval 6 / 10

Starting to integrate subinterval 7 / 10

Starting to integrate subinterval 8 / 10

Starting to integrate subinterval 9 / 10

Starting to integrate subinterval 10 / 10

([35.088 35.087999997887 … 35.08797027422441 35.08797027062664; 35.67 35.66999999441803 … 35.669962166212436 35.66996216393875; … ; 3.26 3.26 … 3.26 3.26; 5.571 5.571 … 5.571 5.571], [0.0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009  …  9.99, 9.991, 9.992, 9.993, 9.994, 9.995, 9.996, 9.997, 9.998, 9.999])

julia> size(traj)
(26, 10000)

julia> size(t)
(10000,)
```
