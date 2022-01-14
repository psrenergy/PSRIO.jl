import Pkg
Pkg.instantiate()

include(joinpath("ArtifactsGenerator.jl", "src", "ArtifactsGenerator.jl"))

@assert length(ARGS) == 4
ArtifactsGenerator.generate_artifacts(ARGS...)
