using FiveBoxModel
using Documenter

DocMeta.setdocmeta!(FiveBoxModel, :DocTestSetup, :(using FiveBoxModel); recursive=true)

makedocs(;
    modules=[FiveBoxModel],
    authors="Daniel Pals <Daniel.Pals@tum.de>",
    repo="https://github.com/DanielJonathanPals/FiveBoxModel.jl/blob/{commit}{path}#{line}",
    sitename="FiveBoxModel.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "home.md",
        "Index" => "index.md",
        "System" => "System.md",
        "Parameter Dynamics" => "ParamDyn.md",
        "Phase Dynamics" => "PhaseDynamics.md",
        "Run System" => "RunSystem.md",
        "Linearization" => "Linearization.md",
        "Plot" => "Plot.md",
    ],
)

deploydocs(
    repo = "github.com/DanielJonathanPals/FiveBoxModel",
)