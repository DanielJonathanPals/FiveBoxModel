# Here the struct SinglePlot is introduced which stores all the information to make
# a single plot. Together with the function combine_plots these can be combined
# to larger more complex organized plots

using GLMakie
using .RHS_module


# This function turns a strin e.g. "S_N" into the function get_S_N which can then be
# used to extract data.
function get_(str::String)
    try
        return getfield(Main, Symbol("get_"*str))
    catch
        error("The function `get_$str` is not defined")
    end
end


"""
    SinglePlot

Stuct containing all the information needed to create a subplot. The idea is that for more
complex plots including multiple subplots it might be more convenient to first generate 
the subplots one by one and then only at the end combine these to a full plot using the 
`combine_plots` function.

# Fields

- `x::Vector{Float64}`: Vector containing the data for the x axis
- `y::Vector{Vector{Float64}}`: A vector of vectors where each vector contains the y data 
    of a certain quantity. Each vector in `y` must have the same length as the vector `x`.
- `title::String`: Title of the subplot
- `x_label::String`: x label of the subplot. For no label use `""`.
- `y_label::String`: y label of the subplot. For no label use `""`.
- `x_unit::String`: Unit of the x data. For no unit use `""`.
- `y_unit::String`: Unit of the y data. For no unit use `""`.
- `y_legend::Union{Vector{String},Nothing}`: Contains the names of each dataseries to be
    plotted. For no legend use `y_legend = nothing`. Otherwise the length of `y_legend`
    must equal the length of the vector `y`.

To immediately show a given subplot of an element of type SinglePlot use

    (sp::SinglePlot)(;resolution::Tuple{Int64,Int64} = (1200,800),show = true)

This will return the Figure and Axis of the respective plot and the plot is immediately
shown if `show = true`
"""
struct SinglePlot
    x::Vector{Float64}
    y::Vector{Vector{Float64}}
    title::String
    x_label::String
    y_label::String
    x_unit::String
    y_unit::String
    y_legend::Union{Vector{String},Nothing}
    function SinglePlot(x::Vector{Float64},
                        y::Vector{Vector{Float64}},
                        title::String,
                        x_label::String,
                        y_label::String,
                        x_unit::String,
                        y_unit::String,
                        y_legend::Union{Vector{String},Nothing})
        for data in y
            if length(data) != length(x)
                error("Dimension mismatch: All vectors contained in `y` must have the same
                    length as `x`")
            end
        end
        if !(y_legend === nothing) && (length(y_legend) != length(y))
            error("Dimension mismatch: `y_legend` and `y` must have same lengths but    
                have lengths but have lengths $(length(y_legend)) and $(length(y))")
        end
        new(x,y,title,x_label,y_label,x_unit,y_unit,y_legend)
    end
end


"""
    createSinglePlot(x::Union{Vector{Float64},String},
        y::Union{Vector,String},
        traj::Array{Float64},
        t::Vector{Float64};
        title::String="",
        x_label::String="",
        y_label::String="",
        x_unit::String="",
        y_unit::String="",
        y_legend::Union{Vector{String},String,Nothing}=nothing)
        
Allows for a more confortable initialisation of an object of the type SinglePlot.

# Arguments

- `x::Union{Vector{Float64},String}`: This can either be a vector containing the data
    to be plotted on the x axis or one can simply give a String containing the name
    of the data which is to be plotted on the x axis as long as a function of the form
    `get_x(traj)` is defined or if `x = "t"`.
- `y::Union{Vector,String}`: If the subplot should only contain one dataseries then `y`
    works in the same way as the `x` argument. In case multiple dataseries are to be
    plotted y must be given as an vector which may contain a mixture of Strings and 
    Vectors, where each element describes a dataseries to be plotted. The lengths of
    the dataseries must all be the same and also have the same length as the series used
    for `x`.
- `traj::Array{Float64}`: The integrated trajectory of the System as e.g. returned by the
    function `runSystem`.
- `t::Vector{Float64}`: The time series of a run of the System as e.g. returned by the
    function `runSystem`.
- `title::String=""`: Title of the subplot.
- `x_label::String=""`: x label of the subplot.
- `y_label::String=""`: y label of the subplot.
- `x_unit::String=""`: Unit of the x data.
- `y_unit::String=""`: Unit of the y data.
- `y_legend::Union{Vector{String},String,Nothing}=nothing`: Vector containing the names
    of the dataseries which are displayed in the final plot. If given the length of
    `y_legend` must be the same as the length of the argument `y`.

# Returns

The function returns an element of the type `SinglePlot` where all Strings in the
    arguments `x` and `y` have been converted into the respective Vectors. Further if
    `x` is given as a String and no `x_label` is given then the String in `x` is passed
    as the `x_label` argument and the same holds for y if only one dataseries is to be 
    plotted. In the case of mulityple dataseries the names contained in `y` are passed
    as the `y_legend` if `y` only contains Strings and no `y_legend` was given.
"""
function createSinglePlot(x::Union{Vector{Float64},String},
    y::Union{Vector,String},
    traj::Array{Float64},
    t::Vector{Float64};
    title::String="",
    x_label::String="",
    y_label::String="",
    x_unit::String="",
    y_unit::String="",
    y_legend::Union{Vector{String},String,Nothing}=nothing)
    
    # Check if `traj` if given has dimension of 2
    if ndims(traj) != 2
        error("`traj` must have dimension 2 but hat dimension $(ndims(traj))")
    end

    # Check whether the dimensions of `t` and `traj` match in case they both
    # exist
    if size(traj)[2] != length(t)
        error("Dimension mismatch: The arguments `traj` and `t` are not 
            compatible since `traj` has size $(size(traj)) and `t` has 
            length $(length(t))")
    end

    # Analyse what kind of input is given for y and transform it into the form
    # y = [data1,data2,...] where data is of type Vector{Float64} or String
    if typeof(y) <: Vector
        # First check for the case where y is a simple vector containing only
        # Numbers and in this case convert y into the form y = [data] with
        # data of type Vector{Float64}
        if typeof(y[1]) <: Float64
            if !(typeof(y) == Vector{Float64})
                error("`y` can either only be a single String, a Vector
                    only containing Floats or a Vector containing
                    both Strings and Vectors containing Floats")
            end
            y = [y]
        # else convert all Vectors in y only contain Numbers and convert these
        # into elements of type Vector{Float64}    
        else
            for i in y
                if !(typeof(i) <: Union{Vector{Float64},String})
                    error("`y` can either only be a single String, a Vector
                    only containing Floats or a Vector containing
                    both Strings and Vectors containing Floats")
                end
            end
        end
    else
        y = [y]
    end

    # Tf there is no y_legend given and all entries of y are Strings then depending on how many 
    # elements y contains either the y_legend or the y_label is filled with the respective names
    # of the variables
    if (y_legend === nothing) && (all(isa.(y, String)))
        if (length(y) == 1) && (y_label == "")
            y_label = y[1]
        end
        if length(y) != 1
            y_legend = y
        end
    end

    # Convert all Strings in `y` into the respective dataseries of type
    # Vector{Float64} and create y_new <: Vector{Vector{Float64}} containing
    # the information of all trajectories
    y_new = Vector{Vector{Float64}}(undef, length(y))
    for (idx,i) in enumerate(y)
        if typeof(i) == String
            if i == "t" 
                y_new[idx] = t
            else
                y_new[idx] = get_(i)(traj)
            end
        else
            y_new[idx] = i
        end
    end

    # Repeat similar procedure for x
    if (x_label === "") && (typeof(x) == String)
        x_label = x
    end

    if typeof(x) == String
        if x == "t" 
            x = t
        else
            x = get_(x)(traj)
        end
    end

    return SinglePlot(x,y_new,title,x_label,y_label,x_unit,y_unit,y_legend)
end


# Auxilary function to create the labels for the axis from the Stings describing the legend and the unit
function axis_label(;label::String="",unit::String="")
    if (label != "") && (unit != "")
        return "$label in $unit"
    else
        return label*unit
    end
end


"""
    combine_plots(sp::Union{Vector{SinglePlot},SinglePlot}, 
                    positions::Vector;
                    resolution::Tuple{Int64,Int64} = (1200,800))

Combines the SinglePlot elements given in the argument `sp` to a large plot. The length of 
the Vector `positions` must agree with the length of `sp`.

# Arguments

- `sp::Union{Vector{SinglePlot},SinglePlot}`: Vector containing elements of the type
    SinglePlot which are to be united in the final plot
- `positions::Union{Vector{Vector{Any}},Vector}`: Determines the arrangement of the plots
    in the final plot, i.e. if `sp = [a,b]` and `positions = [[1,1:2],[1,3]]` then `a` 
    will be located at `[1,1:2]` and `b` at `[1,3]` in the final plot.
- `resolution::Tuple{Int64,Int64} = (1200,800)`: Determines the resolution of the full plot.

# Returns

The function returns the figure and a Vector containing all the axis of the final plot.
"""
function combine_plots(sp::Union{Vector{SinglePlot},SinglePlot}, 
                        positions::Vector;
                        resolution::Tuple{Int64,Int64} = (1200,800))

    # turn sp and positions into Vector if they are not in that form already
    (typeof(sp) == SinglePlot) && (sp = [sp])
    (typeof(positions[1]) <: Union{UnitRange{Int64},Int64}) && (positions = [positions])

    # Check that the Vector in positions are all of length 2 and only contain elements of
    # the types Int64 and UnitRange{Int64}
    for pos in positions
        if length(pos) != 2
            error("Each Vector in the positions argument may only have exactly
            2 entries")
        end
        for i in pos
            if !(typeof(i) <: Union{UnitRange{Int64},Int64})
                error("Each Vector in the positions argument may only contain elements of
                the types UnitRange{Int64} and Int64")
            end
        end
    end

    # Ensure that positions and sp have the same length
    if length(positions) != length(sp)
        error("`sp` and `positions` must have the same length")
    end

    # set up the figure
    fig = Figure(; resolution=resolution)
    ttl = [s.title for s in sp]
    xlbl = [axis_label(label=s.x_label,unit=s.x_unit) for s in sp]
    ylbl = [axis_label(label=s.y_label,unit=s.y_unit) for s in sp]
    axis = [Axis(fig[pos[1],pos[2]],title=ttl[i],xlabel=xlbl[i],ylabel=ylbl[i]) 
            for (i,pos) in enumerate(positions)]
    for (idx,s) in enumerate(sp)

        for (i,y) in enumerate(s.y)
            if s.y_legend === nothing
                lines!(axis[idx], s.x, y)
            else
                lines!(axis[idx], s.x, y, label=s.y_legend[i])
            end
        end
        (s.y_legend === nothing) || axislegend(axis[idx])
    end
    return fig, axis
end


function (sp::SinglePlot)(;resolution::Tuple{Int64,Int64} = (1200,800),show = true)
    fig,axis = combine_plots(sp,[1,1],resolution=resolution)
    if show
        display(fig)
    end
    return fig,axis[1]
end
    