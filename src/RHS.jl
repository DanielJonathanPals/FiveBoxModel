# This file contains the deterministic part of the RHS of the differential equations driving the 5 Box
# model.

include("ParameterSet.jl")
include("System.jl")
include("SystemArrayConverter.jl")


"""
    q(arr::Array{Float64}) 

Returns the value of q of a given system. To this end the euqations q = λ[α(Tₛ-Tₙ)+β(Sₙ-Sₛ)] and
Tₙ = μ⋅q+T₀ where solved for q
"""
function q(arr::Array{Float64}) 
    λ = get_λ(arr)
    μ = get_μ(arr)
    α = get_α(arr)
    β = get_β(arr)
    T_S = get_T_S(arr)
    T_0 = get_T_0(arr)
    S_N = get_S_N(arr)
    S_S = get_S_S(arr)
    return (λ/(1+λ*α*μ))*(α*(T_S-T_0)+β*(S_N-S_S))
end 


q(sys::System) = q(toArray(sys))


# The following function return the RHS of the Differential Equations determining the dynamics of the 
# salinities.
function rhs_S_N(arr::Array{Float64})
    Q = q(arr)
    V_N = get_V_N(arr)
    S_0 = get_S_0(arr)
    K_N = get_K_N(arr)
    F_N = get_F_N(arr)
    S_T = get_S_T(arr)
    S_N = get_S_N(arr)
    S_B = get_S_B(arr)
    if Q >= 0
        return (Q*(S_T-S_N)+K_N*(S_T-S_N)-F_N*S_0)/V_N
    else
        return (abs(Q)*(S_B-S_N)+K_N*(S_T-S_N)-F_N*S_0)/V_N
    end
end


function rhs_S_T(arr::Array{Float64})
    Q = q(arr)
    γ = get_γ(arr)
    V_T = get_V_T(arr)
    S_0 = get_S_0(arr)
    K_N = get_K_N(arr)
    K_S = get_K_S(arr)
    F_T = get_F_N(arr)
    S_T = get_S_T(arr)
    S_N = get_S_N(arr)
    S_S = get_S_S(arr)
    S_IP = get_S_IP(arr)
    if Q >= 0
        return (Q*(γ*S_S+(1-γ)*S_IP-S_T)+K_S*(S_S-S_T)+K_N*(S_N-S_T)-F_T*S_0)/V_T
    else
        (abs(Q)*(S_N-S_T)+K_S*(S_S-S_T)+K_N*(S_N-S_T)-F_T*S_0)/V_T
    end
end


function rhs_S_S(arr::Array{Float64})
    Q = q(arr)
    γ = get_γ(arr)
    η = get_η(arr)
    V_S = get_V_S(arr)
    S_0 = get_S_0(arr)
    K_IP = get_K_IP(arr)
    K_S = get_K_S(arr)
    F_S = get_F_S(arr)
    S_T = get_S_T(arr)
    S_B = get_S_B(arr)
    S_S = get_S_S(arr)
    S_IP = get_S_IP(arr)
    if Q >= 0
        return (Q*γ*(S_B-S_S)+K_IP*(S_IP-S_S)+K_S*(S_T-S_S)+η*(S_B-S_S)-F_S*S_0)/V_S
    else
        return (abs(Q)*γ*(S_T-S_S)+K_IP*(S_IP-S_S)+K_S*(S_T-S_S)+η*(S_B-S_S)-F_S*S_0)/V_S
    end
end


function rhs_S_IP(arr::Array{Float64})
    Q = q(arr)
    γ = get_γ(arr)
    V_IP = get_V_IP(arr)
    S_0 = get_S_0(arr)
    K_IP = get_K_IP(arr)
    F_IP = get_F_IP(arr)
    S_T = get_S_T(arr)
    S_B = get_S_B(arr)
    S_S = get_S_S(arr)
    S_IP = get_S_IP(arr)
    if Q >= 0
        return (Q*(1-γ)*(S_B-S_IP)+K_IP*(S_S-S_IP)-F_IP*S_0)/V_IP
    else
        return (abs(Q)*(1-γ)*(S_T-S_IP)+K_IP*(S_S-S_IP)-F_IP*S_0)/V_IP
    end
end


function rhs_S_B(arr::Array{Float64})
    Q = q(arr)
    η = get_η(arr)
    γ = get_γ(arr)
    V_B = get_V_B(arr)
    S_N = get_S_N(arr)
    S_B = get_S_B(arr)
    S_S = get_S_S(arr)
    S_IP = get_S_IP(arr)
    if Q >= 0
        return (Q*(S_N-S_B)+η*(S_S-S_B))/V_B
    else
        return (abs(Q)*γ*S_S+(1-γ)*abs(Q)*S_IP-γ*abs(Q)*S_B+η*(S_S-S_B))/V_B
    end
end


rhs_S_N(sys::System) = rhs_S_N(toArray(sys))
rhs_S_T(sys::System) = rhs_S_T(toArray(sys))
rhs_S_S(sys::System) = rhs_S_S(toArray(sys))
rhs_S_IP(sys::System) = rhs_S_IP(toArray(sys))
rhs_S_B(sys::System) = rhs_S_B(toArray(sys))