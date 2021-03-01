# MULTEM

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://chenspc.github.io/MULTEM.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://chenspc.github.io/MULTEM.jl/dev)
[![Build Status](https://github.com/chenspc/MULTEM.jl/workflows/CI/badge.svg)](https://github.com/chenspc/MULTEM.jl/actions)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/chenspc/MULTEM.jl?svg=true)](https://ci.appveyor.com/project/chenspc/MULTEM-jl)
[![Coverage](https://codecov.io/gh/chenspc/MULTEM.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/chenspc/MULTEM.jl)

This hopefully will become a Julia wrapper of the [MULTEM](https://github.com/Ivanlh20/MULTEM) simulation package for electron microsscopy. At the moment, this is used to test using TOML as an input file format. 

--- 
## Requirements
Juila: [Downloads](https://julialang.org/downloads/) and [Documentation](https://docs.julialang.org/)

## Installation
Open a Julia REPL, then press `]` to use the package mode. 
```julia
pkg> dev https://github.com/chenspc/MULTEM.jl
```
Go back to the normal mode by pressing `backspace`, then
```julia
julia> using MULTEM
```
There is a `default.toml` in the `test` folder, which can be imported as a dictionary simply with the TOML.jl package. 
```julia
julia> using TOML

julia> default_toml = TOML.parsefile("default.toml")
Dict{String,Any} with 5 entries:
  "theory"     => Dict{String,Any}("electron_phonon_interaction"=>Dict{String,Any}("mode…
  "instrument" => Dict{String,Any}("incident_wave"=>Dict{String,Any}("psi"=>0.0,"theta"=…
  "specimen"   => Dict{String,Any}("rotation"=>Dict{String,Any}("theta"=>0.0,"center_typ…
  "simulation" => Dict{String,Any}("output_region"=>Dict{String,Any}("ix_0"=>0.0,"iy_e"=…
  "system"     => Dict{String,Any}("cpu_nthreads"=>1,"cpu_ncores"=>1,"device"=>2,"gpu_de…
```
This can then be converted to a more organised struct `MULTEMInput` for ease of use.
```julia
julia> m = from_dict(MULTEMInput, default_toml)
MULTEMInput()
```
Default values are by default not printed here, but those fields and values do exist. `m` can be converted back to a dictionary with `to_dict`. Use the `include_defaults=true` keyword if needed.
```julia
julia> m_dict = to_dict(m; include_defaults=true)
OrderedCollections.OrderedDict{String,Any} with 5 entries:
  "system"     => OrderedCollections.OrderedDict{String,Any}("cpu_nthreads"=>1,"cpu_ncor…
  "theory"     => OrderedCollections.OrderedDict{String,Any}("electron_phonon_interactio…
  "simulation" => OrderedCollections.OrderedDict{String,Any}("output_region"=>OrderedCol…
  "specimen"   => OrderedCollections.OrderedDict{String,Any}("rotation"=>OrderedCollecti…
  "instrument" => OrderedCollections.OrderedDict{String,Any}("incident_wave"=>OrderedCol…
```
Or use `to_toml` to generate a TOML string. 
```julia
julia> m_toml = to_toml(m; include_defaults=true)
...
...
```
`to_toml` can also be used to directly save the TOML string to file.
```julia
julia> to_toml("/<some_path>/default_out.toml", m; include_defaults=true)
```
