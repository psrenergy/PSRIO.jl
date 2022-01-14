del /q ".\Project.toml"
del /q ".\Manifest.toml"
rmdir /S /Q ".\psrio-distribution"
rmdir /S /Q ".\ArtifactsGenerator.jl"

git clone -b develop "https://bitbucket.org/psr/psrio-distribution.git"
git clone "https://github.com/psrenergy/ArtifactsGenerator.jl.git"

copy ".\ArtifactsGenerator.jl\Project.toml" "Project.toml"

julia --project ./update_artifacts.jl  "psrio-distribution" "PSRIO" "..\Artifacts.toml" "..\Project.toml"

del /q ".\Project.toml"
del /q ".\Manifest.toml"
rmdir /S /Q ".\psrio-distribution"
rmdir /S /Q ".\ArtifactsGenerator.jl"

cd .. 
julia --project -e "import Pkg; Pkg.test()"
cd scripts