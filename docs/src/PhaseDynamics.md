```@meta
CurrentModule = FiveBoxModel
```

# Set up the Phase Dynamics

The objects presented in this section are usefull to set up the dynamics of the phase system and can be used
to specify how these dynamics should be updated according to the past trajectory.

```@docs
PhaseDynamics
PhaseDynamics(f!::Function, 
                g!::Function;   
                noise_rate_prototype::Union{Matrix{Float64},Nothing} = nothing)
```

## Presets

If `f!` is supposed to be given by the RHS of the deterministic salinity evolution as described in the paper or `g!` as argument of `PhaseDynamics` is supposed to be zero, one can respectively use the presets for these functions.

```@docs
deterministic_salinity_dynamics!
original_deterministic_salinity_dynamics!
no_stochstic_salinity_dynamics!
```

For certain combinations of the above cases in a situation where no updates of `f!` and `g!` are intended. The following presets might be usefull

```@docs
DeterministicPhaseDynamics
OriginalDeterministicPhaseDynamics
```

## RHS of the ODEs describing the salinity evolution

For a more detailed access to the RHSs of the ODEs describing the salinity evolution the following methods might be usefull

```@docs
rhs_S_N
rhs_S_T
rhs_S_S
rhs_S_IP
rhs_S_B
get_q
```