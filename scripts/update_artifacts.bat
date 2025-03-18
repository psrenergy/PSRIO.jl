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
git clone --depth=1 -b genesys_load_save_fix "https://bitbucket.org/psr/psrio-distribution.git" "%BASE_PATH%psrio-distribution"

CD %BASE_PATH%psrio-distribution

COPY %BASE_PATH%psrio-distribution\linux\PSRIO.ver %BASE_PATH%\PSRIO.ver

ECHO "Cloning ArtifactsGenerator"
git clone --depth=1 -b 0.5.0 "https://github.com/psrenergy/ArtifactsGenerator.jl.git" "%BASE_PATH%ArtifactsGenerator.jl"

ECHO "Updating artifatcs"
CALL %JULIA_166% --color=yes --project=%BASE_PATH%ArtifactsGenerator.jl %BASE_PATH%update_artifacts.jl "%BASE_PATH%psrio-distribution" "psrio-distribution" "PSRIO" "%BASE_PATH%../Artifacts.toml" "%AWS_KEY%" "%SECRET_AWS_KEY%"
IF %ERRORLEVEL% NEQ 0 (
    EXIT 1
)

ECHO "Cleaning directory"
RMDIR /S /Q "%BASE_PATH%\psrio-distribution"
RMDIR /S /Q "%BASE_PATH%\ArtifactsGenerator.jl"

ECHO "Testing package"
%JULIA_1107% --color=yes --project="%BASE_PATH%.." -e "import Pkg; Pkg.test()"
IF %ERRORLEVEL% NEQ 0 (
    EXIT 1
)