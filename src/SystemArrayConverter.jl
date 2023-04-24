# Here the back and forth conversion from the information in a System to an Array is implemented

include("System.jl")
include("ParameterSet.jl")


"""
    ToArray(sys::System)

Converts the data contained in the System into an array
"""
function toArray(sys::System)
    return [get_S_N(sys),
            get_S_T(sys),
            get_S_S(sys),
            get_S_IP(sys),
            get_S_B(sys),
            sys.params.λ,
            sys.params.α,
            sys.params.β,
            sys.params.γ,
            sys.params.η,
            sys.params.μ,
            sys.params.V_N,
            sys.params.V_S,
            sys.params.V_T,
            sys.params.V_IP,
            sys.params.V_B,
            sys.params.K_N,
            sys.params.K_S,
            sys.params.K_IP,
            sys.params.F_N,
            sys.params.F_S,
            sys.params.F_T,
            sys.params.F_IP,
            sys.params.S_0,
            sys.params.T_0,
            sys.params.T_S]
end


"""
    updateSystem!(sys::System, arr::Array{Float64})

Updates the values in the System according to the values given in the array.
"""
function updateSystem!(sys::System, arr::Array{Float64})
    if length(arr) != 26
        error("The array does not have the correct length, which should be 26")
    end
    sys.salinities = arr[1:5]
    updateParameterSet!(sys.params, arr[6:26])
end


# get the respective parameter Values from array
get_S_N(arr::Array{Float64}) = arr[1]
get_S_T(arr::Array{Float64}) = arr[2]
get_S_S(arr::Array{Float64}) = arr[3]
get_S_IP(arr::Array{Float64}) = arr[4]
get_S_B(arr::Array{Float64}) = arr[5]
get_λ(arr::Array{Float64}) = arr[6]
get_α(arr::Array{Float64}) = arr[7]
get_β(arr::Array{Float64}) = arr[8]
get_γ(arr::Array{Float64}) = arr[9]
get_η(arr::Array{Float64}) = arr[10]
get_μ(arr::Array{Float64}) = arr[11]
get_V_N(arr::Array{Float64}) = arr[12]
get_V_S(arr::Array{Float64}) = arr[13]
get_V_T(arr::Array{Float64}) = arr[14]
get_V_IP(arr::Array{Float64}) = arr[15]
get_V_B(arr::Array{Float64}) = arr[16]
get_K_N(arr::Array{Float64}) = arr[17]
get_K_S(arr::Array{Float64}) = arr[18]
get_K_IP(arr::Array{Float64}) = arr[19]
get_F_N(arr::Array{Float64}) = arr[20]
get_F_S(arr::Array{Float64}) = arr[21]
get_F_T(arr::Array{Float64}) = arr[22]
get_F_IP(arr::Array{Float64}) = arr[23]
get_S_0(arr::Array{Float64}) = arr[24]
get_T_0(arr::Array{Float64}) = arr[25]
get_T_S(arr::Array{Float64}) = arr[26]