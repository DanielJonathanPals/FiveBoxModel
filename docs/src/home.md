```@meta
CurrentModule = FiveBoxModel
```

# FiveBoxModel

Documentation for [FiveBoxModel](https://github.com/DanielJonathanPals/FiveBoxModel.jl).

This module is an implementation of the 5 box model describing the AMOC. It is set up in such a way, that it is possible for the parameters to change dynamically where the dynamics of both the salinities and the parameters is goverend by stochastic differential equations which may be customized. Further it is possible to define updates to the RHS of the ODEs describing the dynamics in parameter space which may depend on the past trajectory.