@echo off

set basepath=%~dp0
set AWS_KEY=%1
set SECRET_AWS_KEY=%2

echo "Cloning psrio-distribution"
git clone --depth=1 -b develop "https://bitbucket.org/psr/psrio-distribution.git" "%basepath%psrio-distribution"

cd %basepath%psrio-distribution

copy %basepath%psrio-distribution\linux\psrio.ver %basepath%\psrio.ver

echo "Cloning ArtifactsGenerator"
git clone --depth=1 -b 0.3.0 "https://github.com/psrenergy/ArtifactsGenerator.jl.git" "%basepath%ArtifactsGenerator.jl"

copy "%basepath%\ArtifactsGenerator.jl\Project.toml" "%basepath%Project.toml"

echo "Updating artifatcs"
call %JULIA_161% --color=yes --project %basepath%update_artifacts.jl "%basepath%psrio-distribution" "psrio-distribution" "PSRIO" "%basepath%../Artifacts.toml" "%AWS_KEY%" "%SECRET_AWS_KEY%"
IF %ERRORLEVEL% NEQ 0 (
    EXIT 1
)

echo "Cleaning directory"
rmdir /S /Q "%basepath%\psrio-distribution"
rmdir /S /Q "%basepath%\ArtifactsGenerator.jl"
del /q "%basepath%\Project.toml"
del /q "%basepath%\Manifest.toml"

echo "Testing package"
%JULIA_161% --color=yes --project="%basepath%.." -e "import Pkg; Pkg.test()"
IF %ERRORLEVEL% NEQ 0 (
    EXIT 1
)