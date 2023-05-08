```@meta
CurrentModule = FiveBoxModel
```

# Set up the Parameter Dynamics

The objects presented in this section are usefull to set up the dynamics of the parameter system and can be used
to specify how there dynamics should be updated according to the past trajectory.

```@docs
ParameterDynamics
ParameterDynamics(f!::Function, 
                    g!::Function;   
                    noise_rate_prototype::Union{Matrix{Float64},Nothing} = nothing)
```

## Presets

If either `f!` or `g!` as arguments of `ParameterDynamics` are supposed to be zero one can respectively use
the presets for these functions.

```@docs
no_deterministic_param_dynamics!
no_stochastic_param_dynamics!
```

If both are zero simultaneously there also is a preset instance of an `ParameterDynamics` object

```@docs
fixedParameters
```


## Examples

### Hosing experiment

For this example we only want deterministic parameter changes which occur as follows and there is no 
stochastic part to the parameter dynamics. We call the deterministic part `hosing_experiment!`.
This can then be used to create a respective instand of the type `ParameterDynamics`. Since we do not want
`f!` and `g!` to be updated during the integration process we instanciate the object in the following way
```jldoctest
julia> function hosing_experiment!(du, u, t_0, t)
           H_1 = 5e-4
           du[get_index["parameters"]] .= 0.
           if t+t_0 <= 2000
               sign = 1
           else
               sign = -1
           end
           du[get_index["F_N"]] = sign*H_1*0.194
           du[get_index["F_S"]] = -sign*H_1*0.226
           du[get_index["F_T"]] = sign*H_1*0.597
           du[get_index["F_IP"]] = -sign*H_1*0.565
       end
hosing_experiment! (generic function with 1 method)

julia> using FiveBoxModel

julia> hosingExperiment = ParameterDynamics(hosing_experiment!,no_stochastic_param_dynamics!)
ParameterDynamics(hosing_experiment!, FiveBoxModel.no_stochastic_param_dynamics!, nothing, nothing)
```