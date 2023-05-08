# In this file the Struct ParameterSet is introduces which is a mutable stuct containing all the relevant
# parameters of the considered system. Further down some preset parameter sets are defined.

import Base.@kwdef


"""
    ParameterSet

Stuct whos fields describe all Parameters of a given System. The fields are to be given as keyword arguments.

# Fields
- `λ::Number`: [λ] = m^6 * kg^{-1} * s^{-1} * 10^7
- `α::Number`: [α] = kg * m^{-3} * K^{-1}
- `β::Number`: [β] = kg * m^{-3} * psu^{-1}
- `γ::Number`: [γ] = 1
- `η::Number`: [η] = m^3 * s^{-1} * 10^6
- `μ::Number`: [μ] = °C * m^{-3} * s * 10^{-8}
- `V_N::Number`: [V_N] = m^3 * 10^16
- `V_S::Number`: [V_S] = m^3 * 10^16
- `V_T::Number`: [V_T] = m^3 * 10^16
- `V_IP::Number`: [V_IP] = m^3 * 10^16    
- `V_B::Number`: [V_B] = m^3 * 10^16
- `K_N::Number`: [K_N] = m^3 * s^{-1} * 10^6
- `K_S::Number`: [K_S] = m^3 * s^{-1} * 10^6
- `K_IP::Number`: [K_IP] = m^3 * s^{-1} * 10^6
- `F_N::Number`: [F_N] = m^3 * s^{-1} * 10^6
- `F_S::Number`: [F_S] = m^3 * s^{-1} * 10^6
- `F_T::Number`: [F_T] = m^3 * s^{-1} * 10^6
- `F_IP::Number`: [F_IP] = m^3 * s^{-1} * 10^6
- `S_0::Number`: [S_0] = psu
- `T_0::Number`: [T_0] = °C
- `T_S::Number`: [T_S] = °C
"""
@kwdef mutable struct ParameterSet
    λ::Number           # [λ] = m^6 * kg^{-1} * s^{-1} * 10^7
    α::Number           # [α] = kg * m^{-3} * K^{-1}
    β::Number           # [β] = kg * m^{-3} * psu^{-1}
    γ::Number           # [γ] = 1
    η::Number           # [η] = m^3 * s^{-1} * 10^6
    μ::Number           # [μ] = °C * m^{-3} * s * 10^{-8}
    V_N::Number         # [V_N] = m^3 * 10^16
    V_S::Number         # [V_S] = m^3 * 10^16
    V_T::Number         # [V_T] = m^3 * 10^16
    V_IP::Number        # [V_IP] = m^3 * 10^16    
    V_B::Number         # [V_B] = m^3 * 10^16
    K_N::Number         # [K_N] = m^3 * s^{-1} * 10^6
    K_S::Number         # [K_S] = m^3 * s^{-1} * 10^6
    K_IP::Number        # [K_IP] = m^3 * s^{-1} * 10^6
    F_N::Number         # [F_N] = m^3 * s^{-1} * 10^6
    F_S::Number         # [F_S] = m^3 * s^{-1} * 10^6
    F_T::Number         # [F_T] = m^3 * s^{-1} * 10^6
    F_IP::Number        # [F_IP] = m^3 * s^{-1} * 10^6
    S_0::Number         # [S_0] = psu
    T_0::Number         # [T_0] = °C
    T_S::Number         # [T_S] = °C
end


"""
    updateParameterSet!(params::ParameterSet, arr::Array)

Updates the given `ParameterSet` with the values given in the Array.
"""
function updateParameterSet!(params::ParameterSet, arr::Array)
    if length(arr) != 21
        error("The array should have length 21")
    end
    params.λ = arr[1]
    params.α = arr[2]
    params.β = arr[3]
    params.γ = arr[4]
    params.η = arr[5]
    params.μ = arr[6]
    params.V_N = arr[7]
    params.V_S = arr[8]
    params.V_T = arr[9]
    params.V_IP = arr[10]
    params.V_B = arr[11]
    params.K_N = arr[12]
    params.K_S = arr[13]
    params.K_IP = arr[14]
    params.F_N = arr[15]
    params.F_S = arr[16]
    params.F_T = arr[17]
    params.F_IP = arr[18]
    params.S_0 = arr[19]
    params.T_0 = arr[20]
    params.T_S = arr[21]
end


# Parameter set coinciding with the FAMOUS simulation
"""
    FAMOUSparams

A `ParameterSet` containing the parameters as measured from the FAMOUS simulation.
"""
FAMOUSparams = ParameterSet(λ = 2.66,
                            α = 0.12,
                            β = 0.79,
                            γ = 0.58,
                            η = 66.061,
                            μ = 7.0,
                            V_N = 3.683,
                            V_S = 10.28,
                            V_T = 5.151,
                            V_IP = 21.29,
                            V_B = 88.12,
                            K_N = 5.439,
                            K_S = 1.880,
                            K_IP = 89.778,
                            F_N = 0.375,
                            F_S = 1.014,
                            F_T = -0.723,
                            F_IP = -0.666,
                            S_0 = 0.035,
                            T_0 = 3.26,
                            T_S = 5.571)