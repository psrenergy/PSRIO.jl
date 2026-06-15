import Pkg
Pkg.instantiate()

include(joinpath("ArtifactsGenerator.jl", "src", "ArtifactsGenerator.jl"))

try
    # 4 args: credentials come from the environment / assumed role (default chain).
    # 6 args: explicit access key + secret are appended (legacy / local runs).
    @assert length(ARGS) == 4 || length(ARGS) == 6
    ArtifactsGenerator.generate_artifacts(ARGS...)
catch e
    throw(e)
    exit(1)
end