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
        "Home" => "index.md",
    ],
)
