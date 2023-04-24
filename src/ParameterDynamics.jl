# In this file the struct ParameterDynamics is introduced which is a struct containing a field which
# describes how to update the parameters during a runthough of the system.


"""
    ParameterDynamics

A mutable struct which encodes the RHS of the dynamics of the parameter space

# Fields
- 'f::Function': Describes the deterministic dynamics in parameter space with 'f' of the from
    'f(du,u,p,t)' with 'length(du) = length(u) = 26' and 'u' contains all the salinities
    together with all the parameter values.
- 'g::Function': Describes the stochastic dynamics in parameter space and is of the same form
    as 'f'
- 'update::Union{Function,Nothing} = nothing': This function describes how to update 'g' and 
    'f' if 'update!' is applied to the respective object of the type 'ParameterDynamics'. 
    I.e. this function has takes argument and returns new functions 'f' and 'g' based of this 
    argument. If 'update = nothing' then 'f' and 'g' remain unchanged.

If only 'f' and 'g' are given then 'update' will be initialized to 'update = nothing'
"""
mutable struct ParameterDynamics
    f::Function
    g::Function
    update::Union{Function,Nothing}
end

ParameterDynamics(f::Function, g::Function) = ParameterDynamics(f,g,nothing)


"""
    update!(pd::ParameterDynamics, additionalInformation)

Updates the functions 'pd.g' and 'pd.f' of the ParameterDynamics object according the to update rules
specified in the function 'pd.update'. The argument 'updateInformation' must be such that it suits 
'pd.update'.
"""
function update!(pd::ParameterDynamics, updateInformation)
    if !(pd.update === nothing)
        pd.f, pd.g = pd.update(updateInformation)
    end
end


function no_deterministic_param_dynamics!(du, u, p, t)
    du[6:26] = 0
end


function no_stochastic_param_dynamics!(du, u, p, t)
    du[6:26] = 0
end


fixedParameters = ParameterDynamics(no_deterministic_param_dynamics!,
                                    no_stochastic_param_dynamics!)