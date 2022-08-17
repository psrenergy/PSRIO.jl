@assert length(ARGS) == 1 "Script must have one argument with the version write on Project.toml"
new_version = VersionNumber("$(ARGS[1])")
project_toml_path = joinpath(dirname(@__DIR__), "Project.toml")
@assert isfile(project_toml_path)

lines = readlines(project_toml_path)
@assert occursin("version", lines[3])
lines[3] = "version = \"$new_version\""
rm(project_toml_path)
open(project_toml_path, "w") do io
    for line in lines
        println(io, line)
    end
end