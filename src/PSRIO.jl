module PSRIO

using Artifacts

import Base.run 

@static if VERSION < v"0.7"
    const Nothing = Void
end

struct Pointer
    path::String

    function Pointer(psrio_distribution_path::String)
        path = abspath(joinpath(psrio_distribution_path, Sys.iswindows() ? "PSRIO.exe" : "psrio.sh"))
        return new(path)
    end

    function Pointer()
        return new("")
    end
end

function version(;path::AbstractString = path())
    return strip(open(f->read(f, String), joinpath(path, "PSRIO.ver")))
end

function path()
    return normpath(artifact"PSRIO")
end

function create(;path::AbstractString = path())::Pointer
    return Pointer(path)
end

function set_executable_chmod(mode::Integer; path::AbstractString = path())
    # Change permission of PSRIO.exe
    if Sys.iswindows()
        path_exec = joinpath(path, "PSRIO.exe")
        chmod(path_exec, mode)
    else
        @warn("set_executable_chmod is not implemented for linux.")
    end
    return
end

run(psrio::Pointer, case::String; kwargs...) = run(psrio, [case]; kwargs...)
function run(psrio::Pointer, cases::Vector{String}; 
    recipes::Vector{String}=Vector{String}(), 
    command::AbstractString="", 
    model::AbstractString="", 
    csv::Bool=false,
    leap_years::Bool=false, 
    verbose::Integer=1, 
    output_path::String="", 
    index_path::String="", 
    selected_outputs_only::Bool=false, 
    magent::Bool=false,
    label::String="", 
    loads3::String="",
    saves3::String="",
    horizon::String="",
    log_name::String="",
    log_append::Bool=false,
    dependencies_mode::Bool=false,
    ignore_hrbmap::Bool=false,
    skip_typical_days_validation::Bool=true
)
    
    recipes_argument = length(recipes) > 0 ? `--recipes $(join(recipes, ','))` : ``
    command_argument = length(command) > 0 ? `--command $command` : ``
    verbose_argument = `--verbose $verbose`
    output_argument = length(output_path) > 0 ? `--output $output_path` : ``
    index_argument = length(index_path) > 0 ? `--index $index_path` : ``
    csv_argument = csv ? `--csv` : ``
    leap_years_argument = leap_years ? `--leap_years` : ``
    selected_argument = selected_outputs_only ? `--selected` : ``
    magent_argument = magent ? `--magent` : ``
    model_argument = length(model) > 0 ? `--model $(model)` : ``
    label_argument = length(label) > 0 ? `--label $(label)` : ``
    loads3_argument = length(loads3) > 0 ? `--loads3 $loads3` : ``
    saves3_argument = length(saves3) > 0 ? `--saves3 $saves3` : ``
    horizon_argument = length(horizon) > 0 ? `--horizon $horizon` : ``
    log_name_argument = length(log_name) > 0 ? `--log_name $log_name` : ``
    log_append_argument = log_append ? `--log_append` : ``
    dependencies_mode_argument = dependencies_mode ? `--dependencies` : ``
    ignore_hrbmap_argument = ignore_hrbmap ? `--ignore_hrbmap` : ``
    skip_typical_days_validation_argument = skip_typical_days_validation ? `--skip_typical_days_validation` : ``

    command = `$(psrio.path) $recipes_argument $command_argument $model_argument $verbose_argument $output_argument $index_argument $csv_argument $leap_years_argument $selected_argument $magent_argument $label_argument $loads3_argument $saves3_argument $horizon_argument $log_name_argument $log_append_argument $dependencies_mode_argument $ignore_hrbmap_argument $skip_typical_days_validation_argument $cases`
    return Base.run(command);
end

end
