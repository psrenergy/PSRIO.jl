@echo off

SET BASE_PATH=%~dp0

SET AWS_KEY=%1
SET SECRET_AWS_KEY=%2

ECHO "Cleaning directory"
RMDIR /S /Q "%BASE_PATH%\psrio-distribution"
RMDIR /S /Q "%BASE_PATH%\ArtifactsGenerator.jl"
DEL /q "%BASE_PATH%\Project.toml"
DEL /q "%BASE_PATH%\Manifest.toml"

ECHO "Cloning psrio-distribution"
git clone --depth=1 -b develop "https://bitbucket.org/psr/psrio-distribution.git" "%BASE_PATH%psrio-distribution"

CD %BASE_PATH%psrio-distribution

COPY %BASE_PATH%psrio-distribution\linux\PSRIO.ver %BASE_PATH%\PSRIO.ver

ECHO "Cloning ArtifactsGenerator"
git clone --depth=1 -b 0.3.0 "https://github.com/psrenergy/ArtifactsGenerator.jl.git" "%BASE_PATH%ArtifactsGenerator.jl"

COPY "%BASE_PATH%\ArtifactsGenerator.jl\Project.toml" "%BASE_PATH%Project.toml"

ECHO "Updating artifatcs"
CALL %JULIA_161% --color=yes --project %BASE_PATH%update_artifacts.jl "%BASE_PATH%psrio-distribution" "psrio-distribution" "PSRIO" "%BASE_PATH%../Artifacts.toml" "%AWS_KEY%" "%SECRET_AWS_KEY%"
IF %ERRORLEVEL% NEQ 0 (
    EXIT 1
)

ECHO "Cleaning directory"
RMDIR /S /Q "%BASE_PATH%\psrio-distribution"
RMDIR /S /Q "%BASE_PATH%\ArtifactsGenerator.jl"
DEL /q "%BASE_PATH%\Project.toml"
DEL /q "%BASE_PATH%\Manifest.toml"

ECHO "Testing package"
%JULIA_161% --color=yes --project="%BASE_PATH%.." -e "import Pkg; Pkg.test()"
IF %ERRORLEVEL% NEQ 0 (
    EXIT 1
)