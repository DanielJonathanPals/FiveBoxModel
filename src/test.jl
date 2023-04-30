include("FiveBoxModel.jl")


# Here an implementation of the hosing experiment is presented

# First the Dynamics in the parameter space is defined. Since the parameter dynamics is supposed to be
# deterministic we only need to define the deterministic part of the RHS of the ODE describing the parameters.
function hosing_experiment!(du, u, t_0, t)
    H_1 = 5e-4
    du[6:26] .= 0.
    if t+t_0 <= 2000
        sign = 1
    else
        sign = -1
    end
    du[20] = sign*H_1*0.194
    du[21] = -sign*H_1*0.226
    du[22] = sign*H_1*0.597
    du[23] = -sign*H_1*0.565
end

# Now we can set up the element of type ParameterDynamics describing the hosing
hosingExperiment = ParameterDynamics(hosing_experiment!,no_stochastic_param_dynamics!)

# For the phase Dynamics we want both a deterministic as well as a stochastic dynamics

# First we set up the deterministic dynamics:
DeterministicPhaseDynamics = PhaseDynamics(deterministic_salinity_dynamics!,
                                            no_stochstic_salinity_dynamics!)

# And now the stochastic dynamics. To this end we first must define the stochastic part
# of the RHS of the equations describing the phase dynamics:
function stochstic_salinity_dynamics!(du, u, t_0, t)
    du[1:5] .= 0.005
end

# Now we can set up the respective element of type PhaseDynamics:
StochasticPhaseDynamics = PhaseDynamics(deterministic_salinity_dynamics!,
                                        stochstic_salinity_dynamics!)

# Since we want to perform two runs, one with stochastic phase dynamics and one pure deterministic
# run we need to integrate the System twice i.e. need to instances of type RunParameters. In both
# cases we use the parameters from the FAMOUS experiment
deterministic_run = RunParameters(FAMOUS;t_max=5000.,updateInterval=10.,dt=1.,paramDyn=hosingExperiment,
                                phaseDyn = DeterministicPhaseDynamics)
stochastic_run = RunParameters(FAMOUS;t_max=5000.,updateInterval=10.,dt=1.,paramDyn=hosingExperiment,
                                phaseDyn = StochasticPhaseDynamics)

# Now we integrate both Systems:
det_traj, det_t = runSystem(deterministic_run, update_system = false)
stoch_traj, stoch_t = runSystem(stochastic_run, update_system = false)

# Finally we are interested in the time evolutio of the salinities and the Hysteresis in both the 
# deterministic and the stochastic case. To this end we must set up 4 instances of the struct
# SinglePlot. To this end since there is no function 'get_H' we must first extract the Hosing strength
# from the data
function hosing_traj(t)
    H_1 = 5e-4
    H = zeros(length(t))
    for (i,val) in enumerate(t)
        if val <= 2000
            H[i] = H_1*val
        else
            H[i] = 1-H_1*(val-2000)
        end
    end
    return H
end

H_det = hosing_traj(det_t)
H_stoch = hosing_traj(stoch_t)

# Now we are ready to instantiate the SinglePlot elements we need
det_sal_plot = createSinglePlot("t",["S_N","S_T","S_S","S_IP","S_B"],
                                det_traj,det_t,title="Deterministic time evolution of the salinities",
                                x_unit="years",y_unit="psu")
stoch_sal_plot = createSinglePlot("t",["S_N","S_T","S_S","S_IP","S_B"],
                                stoch_traj,stoch_t,title="Stochastic time evolution of the salinities",
                                x_unit="years",y_unit="psu")
det_hyst_plot = createSinglePlot(H_det,"q",det_traj,det_t,title="Hysteresis in the deterministic case",
                                x_label="Hosing",x_unit="10⁶m³s⁻¹",y_unit="10⁶m³s⁻¹")
stoch_hyst_plot = createSinglePlot(H_stoch,"q",stoch_traj,stoch_t,title="Hysteresis in the stochastic case",
                                    x_label="Hosing",x_unit="10⁶m³s⁻¹",y_unit="10⁶m³s⁻¹")

# To check wether the plots look good on their own we could use e.g. 'det_sal_plot()'

# In order to combine all plots into one we unse the 'combine_plots' function
fig1,axis1 = combine_plots([det_sal_plot,stoch_sal_plot,det_hyst_plot,stoch_hyst_plot],
                        [[1,1:2],[2,1:2],[1,3],[2,3]],resolution=(1200,800))






eigenvals_plot = createSinglePlot("t",real.(get_eigvals(det_traj)),det_traj,det_t,
                                    title="Time evolution of the eigenvalues",
                                    y_label="eigenvalues",x_unit="s",y_unit="psu/s")

fig2,axis2 = combine_plots([det_sal_plot,eigenvals_plot],
                            [[1,1:2],[2,1:2]],resolution=(600,800))