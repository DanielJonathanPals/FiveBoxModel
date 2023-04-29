using LinearAlgebra

include("RHS.jl")
include("SystemArrayConverter.jl")


function dq_dS_N(arr::Vector{Float64})
    λ = get_λ(arr)
    μ = get_μ(arr)
    α = get_α(arr)
    β = get_β(arr)
    return 10*β*λ/(1+1e-1*λ*α*μ)
end


function dq_dS_S(arr::Vector{Float64})
    return -dq_dS_N(arr)
end


function linearization(arr::Vector{Float64})
    Q = q(arr)
    γ = get_γ(arr)
    η = get_η(arr)
    V_N = get_V_N(arr)
    V_T = get_V_T(arr)
    V_S = get_V_S(arr)
    V_IP = get_V_IP(arr)
    V_B = get_V_B(arr)
    S_0 = get_S_0(arr)
    K_N = get_K_N(arr)
    K_S = get_K_S(arr)
    K_IP = get_K_IP(arr)
    F_N = get_F_N(arr)
    F_T = get_F_T(arr)
    F_S = get_F_S(arr)
    F_IP = get_F_IP(arr)
    S_N = get_S_N(arr)
    S_T = get_S_T(arr)
    S_S = get_S_S(arr)
    S_IP = get_S_IP(arr)
    S_B = get_S_B(arr)
    dq_N = dq_dS_N(arr)
    dq_S = dq_dS_S(arr)
    if Q >= 0
        return reshape([(-Q-K_N-F_N+dq_N*(S_T-S_N))/V_N,
                        (dq_N*(γ*S_S+(1-γ)*S_IP-S_T)+K_N)/V_T,
                        dq_N*γ*(S_B-S_S)/V_S,
                        dq_N*(1-γ)*(S_B-S_IP)/V_IP,
                        (dq_N*(S_N-S_B)+Q+F_N)/V_B,
                        (Q+K_N)/V_N,
                        (-Q-K_S-K_N)/V_T,
                        K_S/V_S,
                        0,
                        0,
                        dq_S*(S_T-S_N)/V_N,
                        (dq_S*(γ*S_S+(1-γ)*S_IP-S_T)+Q*γ+K_S+F_N*γ+F_S)/V_T,
                        (dq_S*γ*(S_B-S_S)-Q*γ-K_IP-K_S-η-γ*F_N-F_S)/V_S,
                        (dq_S*(1-γ)*(S_B-S_IP)+K_IP)/V_IP,
                        (dq_S*(S_N-S_B)+η)/V_B,
                        0,
                        (Q*(1-γ)+F_N*(1-γ)+F_IP)/V_T,
                        K_IP/V_S,
                        (-Q*(1-γ)-K_IP-(1-γ)*F_N-F_IP)/V_IP,
                        0,
                        0,
                        0,
                        (Q*γ+η+γ*F_N)/S_S,
                        (Q*(1-γ)+(1-γ)*F_N)/V_IP,
                        (-Q-η-F_N)/V_B],5,5) .* (year*1e-10)
    else
        return reshape([(-dq_N*(S_B-S_N)+Q-K_N)/V_N,
                        (-dq_N*(S_N-S_T)-Q+K_N)/V_T,
                        -dq_N*γ*(S_T-S_S)/V_S,
                        -dq_N*(1-γ)*(S_T-S_IP)/V_IP,
                        -dq_N*(γ*S_S+(1-γ)*S_IP-S_B)/V_B,
                        K_N/V_N,
                        (Q-K_S-K_N-F_T)/V_T,
                        (-Q*γ+K_S+γ*F_T)/V_S,
                        (-Q*(1-γ)+(1-γ)*F_T)/V_IP,
                        0,
                        -dq_S*(S_B-S_N)/V_N,
                        (-dq_S*(S_N-S_T)+K_S)/V_T,
                        (-dq_S*γ*(S_T-S_S)+Q*γ*S_S-K_IP-K_S-η-γ*F_T-F_S)/V_S,
                        (-dq_S*(1-γ)*(S_T-S_IP)+K_IP)/V_IP,
                        (-dq_S*(γ*S_S+(1-γ)*S_IP-S_B)-Q*γ+η+F_S+F_T*γ)/V_B,
                        0,
                        0,
                        K_IP/V_S,
                        (Q*(1-γ)-K_IP-(1-γ)*F_T-F_IP)/V_IP,
                        (-(1-γ)*Q-F_T*(1-γ)+F_IP)/V_B,
                        (-Q+F_T+F_S+F_IP)/V_N,
                        0,
                        η/V_S,
                        0,
                        (Q-η-F_S-F_T-F_IP)/V_B],5,5)
    end
end


function linearization(arr::Array{Float64})
    n = size(arr)[2]
    lin = Vector{Matrix{Float64}}(undef,n)
    for i in 1:n
        lin[i] = linearization(arr[:,i])
    end
    return lin
end


function get_eigvals(x::Union{Vector{Matrix{Float64}},Array{Float64}})
    if size(x) == (5,5)
        return eigvals(x)
    else
        if typeof(x) <: Array{Float64}
            x = linearization(x)
        end
        n = length(x)
        eigs = zeros(ComplexF64,(5,n))
        for (i,mat) in enumerate(x)
            eigs[:,i] = eigvals(mat)
        end
        return [eigs[1,:],eigs[2,:],eigs[3,:],eigs[4,:],eigs[5,:]]
    end
end