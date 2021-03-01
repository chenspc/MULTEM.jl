using MULTEM
using TOML 
using Test

@testset "MULTEM.jl" begin
    test_defaults = from_dict(MULTEMInput, TOML.parsefile("default.toml"))
    isfile("default_generated.toml") ? rm("default_generated.toml") : nothing
    to_toml("default_generated.toml", test_defaults; include_defaults=true)
    @test from_dict(MULTEMInput, TOML.parsefile("default_generated.toml")) == from_dict(MULTEMInput, TOML.parsefile("default.toml"))
    @test TOML.parsefile("default_generated.toml") == TOML.parsefile("default.toml")
end
