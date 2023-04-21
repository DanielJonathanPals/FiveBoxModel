# This file contains the deterministic part of the RHS of the differential equations driving the 5 Box
# model.

include("ParameterSet.jl")
include("System.jl")


"""
    q(sys::System) 

Returns the value of q of a given system. To this end the euqations q = λ[α(Tₛ-Tₙ)+β(Sₙ-Sₛ)] and
Tₙ = μ⋅q+T₀ where solved for q
"""
function q(sys::System) 
    λ = sys.params.λ
    μ = sys.params.μ
    α = sys.params.α
    β = sys.params.β
    T_S = sys.params.T_S
    T_0 = sys.params.T_0
    S_N = Sn(sys)
    S_S = Ss(sys)
    return (λ/(1+λ*α*μ))*(α*(T_S-T_0)+β*(S_N-S_S))
end 


# The following function return the RHS of the Differential Equations determining the dynamics of the 
# salinities.
function rhs_Sn(sys::System)
    Q = q(sys)
    V_N = sys.params.V_N
    S_0 = sys.params.S_0
    K_N = sys.params.K_N
    F_N = sys.params.F_N
    S_T = St(sys)
    S_N = Sn(sys)
    S_B = Sb(sys)
    if Q >= 0
        return (Q*(S_T-S_N)+K_N*(S_T-S_N)-F_N*S_0)/V_N
    else
        return (abs(Q)*(S_B-S_N)+K_N*(S_T-S_N)-F_N*S_0)/V_N
    end
end


function rhs_St(sys::System)
    Q = q(sys)
    γ = sys.params.γ
    V_T = sys.params.V_T
    S_0 = sys.params.S_0
    K_N = sys.params.K_N
    K_S = sys.params.K_S
    F_T = sys.params.F_N
    S_T = St(sys)
    S_N = Sn(sys)
    S_S = Ss(sys)
    S_IP = Sip(sys)
    if Q >= 0
        return (Q*(γ*S_S+(1-γ)*S_IP-S_T)+K_S*(S_S-S_T)+K_N*(S_N-S_T)-F_T*S_0)/V_T
    else
        (abs(Q)*(S_N-S_T)+K_S*(S_S-S_T)+K_N*(S_N-S_T)-F_T*S_0)/V_T
    end
end


function rhs_Ss(sys::System)
    Q = q(sys)
    γ = sys.params.γ
    η = sys.params.η
    V_S = sys.params.V_S
    S_0 = sys.params.S_0
    K_IP = sys.params.K_IP
    K_S = sys.params.K_S
    F_S = sys.params.F_S
    S_T = St(sys)
    S_B = Sb(sys)
    S_S = Ss(sys)
    S_IP = Sip(sys)
    if Q >= 0
        return (Q*γ*(S_B-S_S)+K_IP*(S_IP-S_S)+K_S*(S_T-S_S)+η*(S_B-S_S)-F_S*S_0)/V_S
    else
        return (abs(Q)*γ*(S_T-S_S)+K_IP*(S_IP-S_S)+K_S*(S_T-S_S)+η*(S_B-S_S)-F_S*S_0)/V_S
    end
end


function rhs_Sip(sys::System)
    Q = q(sys)
    γ = sys.params.γ
    V_IP = sys.params.V_IP
    S_0 = sys.params.S_0
    K_IP = sys.params.K_IP
    F_IP = sys.params.F_IP
    S_T = St(sys)
    S_B = Sb(sys)
    S_S = Ss(sys)
    S_IP = Sip(sys)
    if Q >= 0
        return (Q*(1-γ)*(S_B-S_IP)+K_IP*(S_S-S_IP)-F_IP*S_0)/V_IP
    else
        return (abs(Q)*(1-γ)*(S_T-S_IP)+K_IP*(S_S-S_IP)-F_IP*S_0)/V_IP
    end
end


function rhs_Sb(sys::System)
    Q = q(sys)
    η = sys.params.η
    γ = sys.params.γ
    V_B = sys.params.V_B
    S_N = Sn(sys)
    S_B = Sb(sys)
    S_S = Ss(sys)
    S_IP = Sip(sys)
    if Q >= 0
        return (Q*(S_N-S_B)+η*(S_S-S_B))/V_B
    else
        return (abs(Q)*γ*S_S+(1-γ)*abs(Q)*S_IP-γ*abs(Q)*S_B+η*(S_S-S_B))/V_B
    end
end