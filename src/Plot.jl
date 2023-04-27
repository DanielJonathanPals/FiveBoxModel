# Here the struct SinglePlot is introduced which stores all the information to make
# a single plot. Together with the function combine_plots these can be combined
# to larger more complex organized plots

using GLMakie

include("SystemArrayConverter.jl")
include("RHS.jl")


# This function turns a strin e.g. "S_N" into the function get_S_N which can then be
# used to extract data.
function get_(str::String)
    try
        return getfield(Main, Symbol("get_"*str))
    catch
        error("The function 'get_$str' is not defined")
    end
end


struct SinglePlot
    x::Vector{Float64}
    y::Vector{Vector{Float64}}
    title::Union{String,Nothing}
    x_legend::Union{String,Nothing}
    y_legend::Union{Vector{String},Nothing}
    x_unit::Union{String,Nothing}
    y_unit::Union{String,Nothing}
    resolution::Tuple{Int64,Int64}
    function SinglePlot(x::Vector{Float64},
                        y::Vector{Vector{Float64}};
                        title::Union{String,Nothing}=nothing,
                        x_legend::Union{String,Nothing}=nothing,
                        y_legend::Union{Vector{String},Nothing}=nothing,
                        x_unit::Union{String,Nothing}=nothing,
                        y_unit::Union{String,Nothing}=nothing,
                        resolution::Tuple{Int64,Int64}=(1200, 800))
        for data in y
            if length(data) != length(x)
                error("Dimension mismatch: All vectors contained in 'y' must have the same
                    length as 'x'")
            end
        end
        if !(y_legend === nothing) && (length(y_legend) != length(y))
            error("Dimension mismatch: 'y_legend' and 'y' must have same lengths but    
                have lengths but have lengths $(length(y_legend)) and $(length(y))")
        end
        new(x,y,title,x_legend,y_legend,x_unit,y_unit,resolution)
    end
end


function SinglePlot(x::Union{Vector{Float64},String},
    y::Union{Vector,String},
    traj::Union{Array{Float64},Nothing},
    t::Union{Vector{Float64},Nothing};
    title::Union{String,Nothing}=nothing,
    x_legend::Union{String,Nothing}=nothing,
    y_legend::Union{Vector{String},Nothing}=nothing,
    x_unit::Union{String,Nothing}=nothing,
    y_unit::Union{String,Nothing}=nothing,
    resolution::Tuple{Int64,Int64}=(1200, 800))
    
    # Check if 'traj' if given has dimension of 2
    if ndims(traj) != 2
        error("'traj' must have dimension 2 but hat dimension $(ndims(traj))")
    end

    # Check whether the dimensions of 't' and 'traj' match in case they both
    # exist
    if size(traj)[2] != length(t)
        error("Dimension mismatch: The arguments 'traj' and 't' are not 
            compatible since 'traj' has size $(size(traj)) and 't' has 
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
                error("'y' can either only be a single String, a Vector
                    only containing Floats or a Vector containing
                    both Strings and Vectors containing Floats")
            end
            y = [y]
        # else convert all Vectors in y only contain Numbers and convert these
        # into elements of type Vector{Float64}    
        else
            for i in y
                if !(typeof(i) <: Union{Vector{Float64},String})
                    error("'y' can either only be a single String, a Vector
                    only containing Floats or a Vector containing
                    both Strings and Vectors containing Floats")
                end
            end
        end
    else
        y = [y]
    end

    # If y only consists of Strings and there is no y_legend then overwhite
    # y_legend with the Strings containes in y
    ((y_legend === nothing) && typeof(y) == Vector{String}) && (y_legend = y)

    # Check whether the arguments 'traj' or 't' are needed and if yes then
    # convert all Strings in 'y' into the respective dataseries of type
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
    ((x_legend === nothing) && typeof(x) == String) && (x_legend = x)

    if typeof(x) == String
        if x == "t" 
            x = t
        else
            x = get_(x)(traj)
        end
    end

    return SinglePlot(x,y_new;title=title,x_legend=x_legend,
                        y_legend=y_legend,x_unit=x_unit,y_unit=y_unit,
                        resolution=resolution)
end


function combine_plots(sp::Union{Vector{SinglePlot},SinglePlot}, 
                        positions::Union{Vector{Vector{Any}},Vector})

    # turn sp and positions into Vector if they are not in that form already
    (typeof(sp) == SinglePlot) && (sp = [sp])
    (typeof(positions) <: Vector{Vector{Any}}) && (positions = [positions])
    println(positions)

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
        error("'sp' and 'positions' must have the same length")
    end

    # set up the figure
    fig = Figure(; resolution=sp.resolution)
    axis = [Axis(fig[pos[1],pos[2]],title=sp[i].title) for (i,pos) in enumerate(positions)]
    for (idx,s) in enumerate(sp)
        # This part allows for a neater handling of the legend later on.
        if s.y_legend === nothing
            y_legend = [nothing for i in s.y]
        else
            y_legend = s.y_legend
        end

        for (i,y) in enumerate(s.y)
            lines!(axis[idx], s.x, y, label = y_legend[i])
        end
        axislegend(axis[idx])
    end
    return fig, axis
end