import Pkg
Pkg.instantiate()

include(joinpath("ArtifactsGenerator.jl", "src", "ArtifactsGenerator.jl"))

@assert length(ARGS) == 7
try
    ArtifactsGenerator.generate_artifacts(ARGS...)
catch e
    throw(e)
    exit(1)
end