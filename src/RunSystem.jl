# In this file it is specified how exactly the System is run i.e. how the trajectory is integrated and
# how the RHSs of the SODEs are updated

using DifferentialEquations

include("ParameterDynamics.jl")
include("PhaseDynamics.jl")



# Simple auxilary function to check whether there exists a natrual number n s.t. x = n*y 
isDivisible(x,y) = (x == (length(collect(0:y:x))-1)*y)


# Auxilary function which transfers the output from the SDE solver into the form of an array
function sol_to_array(sol::DiffEqArray)
    dim1 = length(sol[1])
    dim2 = length(sol)
    traj = zeros(dim1,dim2)
    for i in 1:dim1, j in 1:dim2
        traj[i,j] = sol[j][i]
    end
    return traj
end


"""
    RunParameters

struct which contains the relevant parameters for running a given system. 

# Fields

-`sys::System`: System holding the initial conditions
-`integrationMethod`: Method which the solver from DifferentialEquations will use
-`updateInterval::Number`: Time after which the update! function will periodically be applied to
    the phaseDyn and paramDyn. Running the System in not to large time intervals also increases
    the numerical stability of the result
-`t_max::Number`: Overall runtime 
-`dt::Number`: Time difference of consecutive datapoints in the trajectory (This is not the dt
    used by the DifferentialEquations package to integrate the trajectory)
-`phaseDyn::PhaseDynamics`
-`paramDyn::ParameterDynamics`
"""
struct RunParameters
    sys::System
    updateInterval::Number
    t_max::Number
    dt::Number
    phaseDyn::PhaseDynamics
    paramDyn::ParameterDynamics
    function RunParameters(sys,
                            updateInterval,
                            t_max,
                            dt,
                            phaseDyn,
                            paramDyn)
        if !(isDivisible(t_max,dt))
            error("`t_max`is not devisible by `dt`")
        end
        if !(isDivisible(updateInterval,dt))
            error("`updateInterval`is not devisible by `dt`")
        end
        if !(isDivisible(t_max,updateInterval))
            error("`t_max`is not devisible by `updateInterval`")
        end
        new(sys,updateInterval,t_max,dt,phaseDyn,paramDyn)
    end
end


"""
    function RunParameters(sys;
        updateInterval = 1.,
        t_max = 10.,
        dt = 0.001,
        phaseDyn = DeterministicPhaseDynamics,
        paramDyn = fixedParameters)

Alternative instantiation of an object of type `RunParameters`, with some default arguments.
"""
function RunParameters(sys;
                        updateInterval = 1.,
                        t_max = 10.,
                        dt = 0.001,
                        phaseDyn = DeterministicPhaseDynamics,
                        paramDyn = fixedParameters)
    RunParameters(sys,updateInterval,t_max,dt,phaseDyn,paramDyn)
end


"""
    runSystem(rp::RunParameters; update_system = true)

Runs the productspace System encoded in `rp` according to the parameters in `rp` and returns the 
full trajectory of the time evolution together with an array containing the respective times
corresponding to the datapoints. If `update_system == true` then the system `rp.sys` is
updated accordingly.
"""
function runSystem(rp::RunParameters; update_system = false)
    # The entire time Intervall is split up into subintervals each describing one period
    # between updates of the phase and parameter dynamics.

    # length of each of the subintervals (i.e. number of entries of the array describing the 
    # subinterval)
    interval_length = length(collect(0:rp.dt:rp.updateInterval)) - 1

    # number of subintervals the total time interval is split into
    numb_of_intervals = length(collect(0:rp.updateInterval:rp.t_max)) - 1

    # length of the entire time interval
    total_length = length(collect(0:rp.dt:rp.t_max)) - 1

    # In-place update of the dynamical System on the product space consisting of the parameter space
    # and the phase space
    f!(du,u,p,t) = (rp.phaseDyn.f!(du,u,p,t); rp.paramDyn.f!(du,u,p,t))
    g!(du,u,p,t) = (rp.phaseDyn.g!(du,u,p,t); rp.paramDyn.g!(du,u,p,t))

    # Setting up the SDEProblem
    # Since the problem is run in subintervals instead of running the entire time interval in one
    # pice the time t_0 at which the respective interval starts, is passed as an argument, which
    # also allows for non autonomous systems
    tspan = (0.,Float64(rp.updateInterval))
    u₀ = toArray(rp.sys)
    prob = SDEProblem(f!,g!,u₀,tspan,0,noise_rate_prototype=rp.paramDyn.noise_rate_prototype)

    # Set up array in which the trajectories are saved
    traj = zeros(26,total_length)

    # Array containing all the times according to the datapoints of the trajectory
    t = collect(0:rp.dt:rp.t_max)[1:end-1]

    println("Starting to integrate System...")
    println("the total time interval is subdivided into $numb_of_intervals subintervals")
    println("")

    for i in 0:numb_of_intervals-1
        println("Starting to integrate subinterval $(i+1) / $numb_of_intervals")
        println("")

        # solve the SDEProblem and add the new part of the trajectory to the trajectory Array
        sol = solve(prob)

        # new_traj is the trajectory recored in the current subinterval
        new_traj = sol(collect(0:rp.dt:rp.updateInterval))
        new_traj = sol_to_array(new_traj)

        # traj is filled up with the new part of the trajectory excluding the very last data point
        # as this appreas as first entry of the following subinterval
        traj[:,i*interval_length+1:(i+1)*interval_length] = new_traj[:,1:end-1]

        # Set the new initial conditions for the next subinterval
        u₀ = new_traj[:,end]
        t_0 = rp.updateInterval*(i+1)

        # Update the values of the System if this is intended
        if update_system
            updateSystem!(rp.sys, u₀)
        end

        # Update the SDEProblem
        # prob = SDEProblem(rhs["f!"],rhs["g!"],u₀,tspan,t_0,noise_rate_prototype=rp.paramDyn.noise_rate_prototype)
        prob = remake(prob, u0 = u₀, p = t_0)
    end
    return traj, t
end