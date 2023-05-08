```@meta
CurrentModule = FiveBoxModel
```

# Linearization

These methods allow the linearization of the model, i.e the computation of the Jacobian of the RHS of the 
ODSs describing the systems dynamics

```@docs
jacobian
get_eigvals
```

# Example

In this example we are interested in the Jacobian of the FAMOUS system with its default initial conditions as well as the eigenvalues of the resulting matrix which we compute in two alternative ways.
```jldoctest
julia> using FiveBoxModel

julia> jacob = jacobian(FAMOUS)
5×5 Matrix{Float64}:
 -0.0111047     0.0193488    -0.00856547   0.0          0.0
 -0.00850446   -0.0149863     0.0198343    0.00409944   0.0
  0.000415914   0.000577123  -0.0522628    0.0275601    0.0233984
 -0.000119763   0.0           0.0134273   -0.0142994    0.00109056
  0.00094166    0.0           0.00205146   0.0         -0.00299312
julia> get_eigvals(FAMOUS)
5-element Vector{ComplexF64}:
     -0.061132336622295 + 0.0im
  -0.012867247154163776 - 0.012842367738329028im
  -0.012867247154163776 + 0.012842367738329028im
  -0.008779464134900803 + 0.0im
 -7.349766174807036e-18 + 0.0im
julia> get_eigvals(jacob)
5-element Vector{ComplexF64}:
     -0.061132336622295 + 0.0im
  -0.012867247154163776 - 0.012842367738329028im
  -0.012867247154163776 + 0.012842367738329028im
  -0.008779464134900803 + 0.0im
 -7.349766174807036e-18 + 0.0im
```