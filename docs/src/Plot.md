```@meta
CurrentModule = FiveBoxModel
```

# Plot results

The idea to achieve organised plots is to first create single plots only containing one subplot each and then combining these to a large plot which contains all the information form the single plots.

```@docs
SinglePlot
createSinglePlot
combine_plots
```

## Example

In this example we would like to visiulalize the salinity evolution of the hosing experiment. To this end we must first combine different features of the package in order to obtain this data

```jldoctest
julia> using FiveBoxModel

julia> function hosing_experiment!(du, u, t_0, t)
                  H_1 = 5e-4
                  du[get_index["parameters"]] .= 0.
                  if t+t_0 <= 2000
                      sign = 1
                  else
                      sign = -1
                  end
                  du[get_index["F_N"]] = sign*H_1*0.194
                  du[get_index["F_S"]] = -sign*H_1*0.226
                  du[get_index["F_T"]] = sign*H_1*0.597
                  du[get_index["F_IP"]] = -sign*H_1*0.565
              end
hosing_experiment! (generic function with 1 method)

julia> hosingExperiment = ParameterDynamics(hosing_experiment!,no_stochastic_param_dynamics!)
ParameterDynamics(hosing_experiment!, FiveBoxModel.no_stochastic_param_dynamics!, nothing, nothing)

julia> rp = RunParameters(FAMOUS;t_max=5000.,updateInterval=10.,dt=1.,paramDyn=hosingExperiment,
                                       phaseDyn = DeterministicPhaseDynamics)
RunParameters(System([35.088, 35.67, 34.441, 34.689, 34.577], ParameterSet(2.66, 0.12, 0.79, 0.58, 66.061, 7.0, 3.683, 10.28, 5.151, 21.29, 88.12, 5.439, 1.88, 89.778, 0.375, 1.014, -0.723, -0.666, 0.035, 3.26, 5.571)), 
10.0, 5000.0, 1.0, PhaseDynamics(FiveBoxModel.deterministic_salinity_dynamics!, FiveBoxModel.no_stochstic_salinity_dynamics!, nothing, nothing), ParameterDynamics(hosing_experiment!, FiveBoxModel.no_stochastic_param_dynamics!, nothing, nothing))

julia> traj,t = runSystem(rp)
Starting to integrate System...
the total time interval is subdivided into 500 subintervals

Starting to integrate subinterval 1 / 500

Starting to integrate subinterval 2 / 500

...

Starting to integrate subinterval 500 / 500

([35.088 35.08799564580706 … 35.10049628385613 35.10049791895199; 35.67 35.66999639842458 … 35.539730298111856 35.53958898527882; … ; 3.26 3.26 … 3.26 3.26; 5.571 5.571 … 5.570999999999999 5.571], [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0  …  4990.0, 4991.0, 4992.0, 4993.0, 4994.0, 4995.0, 4996.0, 4997.0, 4998.0, 4999.0])

julia> function hosing_traj(t)     # This allows the computation of the time evolution of the hosing stength
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
hosing_traj (generic function with 1 method)

julia> H = hosing_traj(t)
5000-element Vector{Float64}:
  0.0
  0.0005
  ⋮
 -0.49950000000000006

julia> salinity_evol = createSinglePlot("t",["S_N","S_T","S_S","S_IP","S_B"],
                                       traj,t,title="Time evolution of the salinities",
                                       x_unit="years",y_unit="psu") # Single plot containing the salinity evolution during the hosing experiment
SinglePlot([0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0  …  4990.0, 4991.0, 4992.0, 4993.0, 4994.0, 4995.0, 4996.0, 4997.0, 4998.0, 4999.0], [[35.088, 35.08799566823129, 35.08798937952064, 35.087978976936895, 35.08796544547374, 35.087948501233626, 35.0879279150318, 35.08790355802544, 35.08787546730348, 35.08784394877551  …  35.37081445338626, 35.37104150053473, 35.37126850037978, 35.37149541020424, 35.37172225107363, 35.371949013446105, 35.372175701256204, 35.37240231401276, 35.37262884271905, 35.372855297770435], [35.67, 35.669990295304366, 35.66997712277325, 35.669956860817514, 35.66993147443261, 35.66990072062627, 35.66986448193116, 35.66982281622476, 35.669776015086576, 35.66972468241917  …  35.7211422546347, 35.72118400245413, 35.72122575503571, 35.721267516176944, 35.721309283652, 35.72135105828342, 35.72139283966156, 35.72143462778382, 35.721476423400894, 35.72151822553647], [34.441, 34.441016720917744, 34.44103362143554, 34.4410509135918, 34.44106852187264, 34.44108648912412, 34.44110485398059, 34.44112364448877, 34.44114286861502, 34.441162499385264  …  34.35562012817081, 34.355530345618284, 34.35544057238189, 34.355350816824654, 34.3552610747627, 34.355171348025216, 34.35508163580701, 34.35499193816856, 34.354902256813084, 34.354812589687384], [34.689, 34.688999790198, 34.68900058625715, 34.68900345218307, 34.68900783322418, 34.68901381849254, 34.68902146351753, 34.68903077374376, 34.6890416832962, 34.689054023766424  …  34.52670821114472, 34.52653332571092, 34.52635845642081, 34.52618361765965, 34.52600880215783, 34.52583401305979, 34.52565924897026, 34.52548450998585, 34.52530979902992, 34.52513511255984], [34.577, 34.57699884837088, 34.57699771727245, 34.576996626749526, 34.57699556361012, 34.576994527395684, 34.57699351662848, 34.576992528722975, 34.576991560071164, 34.576990606421354  …  34.61136062053668, 34.6114014173803, 34.61144221093545, 34.61148299831438, 34.61152378101121, 34.61156455840356, 34.61160533078198, 34.611646098136724, 34.61168685989498, 34.611727616774765]], "Time evolution of the salinities", "t", "", "years", "psu", ["S_N", "S_T", "S_S", "S_IP", "S_B"])

julia> hysteresis = createSinglePlot(H,"q",traj,t,title="Hysteresis plot of the hosing experiment",
                                       x_label="Hosing",x_unit="10⁶m³s⁻¹",y_unit="10⁶m³s⁻¹") # Single plot showing the hyseresis of the hosing experiment
SinglePlot([0.0, 0.0005, 0.001, 0.0015, 0.002, 0.0025, 0.003, 0.0035, 0.004, 0.0045000000000000005  …  -0.4950000000000001, -0.49550000000000005, -0.496, -0.49649999999999994, -0.4970000000000001, -0.49750000000000005, -0.498, -0.49849999999999994, -0.4990000000000001, -0.49950000000000006], [[17.14245896815534, 17.14209736386482, 17.141699061989485, 17.141223372730824, 17.140688511536013, 17.140088866204483, 17.13941983663284, 17.1386787280615, 17.137866040704427, 17.136987492224034  …  23.466623250896976, 23.472065168225818, 23.47750611304818, 23.482945208002537, 23.488382886776474, 23.493818954059513, 23.499253491261808, 23.504686488908348, 23.510117763215224, 23.51554752800076]], "Hysteresis plot of the hosing experiment", "Hosing", "q", "10⁶m³s⁻¹", "10⁶m³s⁻¹", nothing)

julia> salinity_evol()   # Check if the salinity plot look right
(Scene (1200px, 800px):
  0 Plots
  2 Child Scenes:
    ├ Scene (1200px, 800px)
    └ Scene (1200px, 800px), Axis (5 plots))

julia> fig,ax = combine_plots([salinity_evol,hysteresis],
                               [[1,1:2],[1,3]],resolution=(1200,500))
(Scene (1200px, 500px):
  0 Plots
  3 Child Scenes:
    ├ Scene (1200px, 500px)
    ├ Scene (1200px, 500px)
    └ Scene (1200px, 500px), Makie.Axis[Axis (5 plots), Axis (1 plots)])

julia> display(fig)
GLMakie.Screen(...)
```