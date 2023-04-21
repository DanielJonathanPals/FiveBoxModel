include("ParameterSet.jl")


"""
    System

Mutalbe struct which carries the current sylinity values as well as the parameter values of a given 
system

# Fields

- 'salinities::Array': Array of size (5,) of the form [S_N,S_T,S_S,S_IP,S_B] where each salinity is
    given in units of psu (Any five element Array is reshaped into this form at initialization of 
    the stuct)
- 'params::ParameterSet': Contains the current parameters describing the system
"""
mutable struct System
    salinities::Array
    params::ParameterSet
    function System(salinities, params)
        if length(salinities) != 5
            error("The Array for the salinities does not have 5 entries")
        end
        salinities = convert(Array{Float64},reshape(salinities,5))
        new(salinities, params)
    end
end


"""
    System(;S_N::Number,
            S_T::Number,
            S_S::Number,
            S_IP::Number,
            S_B::Number,
            params::ParameterSet)

Returns an element of the struct System, of the form System([S_N,S_T,S_S,S_IP,S_B],params)
    (All salinities must be given in units of psu)
"""
function System(;S_N::Number,
                S_T::Number,
                S_S::Number,
                S_IP::Number,
                S_B::Number,
                params::ParameterSet)
    System([S_N,S_T,S_S,S_IP,S_B],params)
end


# Read the value of a specific silinity of a given system
Sn(sys::System) = sys.salinities[1]
St(sys::System) = sys.salinities[2]
Ss(sys::System) = sys.salinities[3]
Sip(sys::System) = sys.salinities[4]
Sb(sys::System) = sys.salinities[5]

# Change the value of a specific silinity of a given system
Sn!(sys::System, s::Number) = sys.salinities[1] = Float64(s)
St!(sys::System, s::Number) = sys.salinities[2] = Float64(s)
Ss!(sys::System, s::Number) = sys.salinities[3] = Float64(s)
Sip!(sys::System, s::Number) = sys.salinities[4] = Float64(s)
Sb!(sys::System, s::Number) = sys.salinities[5] = Float64(s)


# FAMOUS System
FAMOUS = System(S_N = 35.1,
                S_T = 35.7,
                S_S = 34.4,
                S_IP = 34.7,
                S_B = 34.6,
                params = FAMOUSparams)