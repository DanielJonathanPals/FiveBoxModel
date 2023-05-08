```@meta
CurrentModule = FiveBoxModel
```

# System

An object of the type `System` contains the values of all five salinities in form of an Array and all parameter values as an Object of type `ParameterSet`, i.e. a system contains all the information of a given system at a single point in time.

```@docs
System
```

An alternative instantiation is given by 

```@docs
System(;S_N::Number,
        S_T::Number,
        S_S::Number,
        S_IP::Number,
        S_B::Number,
        params::ParameterSet)
```

An instance of `ParameterSet` which is needed to create a System is of the following form

```@docs
ParameterSet
```

Both instances of `System` and `ParameterSet` can be updated respectively via

```@docs
updateSystem!
updateParameterSet!
```

## Presets

For the FAMOUS simulation there are presets for both the initial parameter values and the salinities

```@docs
FAMOUSparams
FAMOUS
```

## To Array conversion

Often it is more convenient to work with arrays rather then with systems. The following method allows a conversion from a System into an Array

```@docs
toArray
```

To obtain certain data concerning a given variable of interest from an Array, one can use the function `get_VariableName(arr::Array)` where "VariableName" must be replaced with the name of the respective variable of interest. In case `arr` represents a full trajectory, `get_VariableName` will slice out the respective part of the trajectory describing the evolution of the variable of interest. The same function also works when applied to systems, i.e. `get_VariableName(sys::System)`. An alternative method would be to extract the index of the variable of interest via the following dictionary

```@docs
get_index
```

This is also illustrated in the following example

```jldoctest
julia> using FiveBoxModel

julia> get_S_N(FAMOUS)
35.088

julia> arr = toArray(FAMOUS)
26-element Vector{Float64}:
  35.088
   ⋮
   5.571

julia> get_S_N(arr)
35.088

julia> arr[get_index["S_N"]]
35.088
```