using MULTEM
using Documenter

DocMeta.setdocmeta!(MULTEM, :DocTestSetup, :(using MULTEM); recursive=true)

makedocs(;
    modules=[MULTEM],
    authors="Chen Huang <chen1huang2@gmail.com> and contributors",
    repo="https://github.com/chenspc/MULTEM.jl/blob/{commit}{path}#{line}",
    sitename="MULTEM.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://chenspc.github.io/MULTEM.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/chenspc/MULTEM.jl",
)
