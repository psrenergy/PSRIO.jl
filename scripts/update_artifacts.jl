import Pkg
Pkg.instantiate()

include(joinpath("ArtifactsGenerator.jl", "src", "ArtifactsGenerator.jl"))

try
    @assert length(ARGS) == 6
    ArtifactsGenerator.generate_artifacts(ARGS...)
catch e
    throw(e)
    exit(1)
end