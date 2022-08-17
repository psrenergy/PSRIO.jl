@echo off

set basepath=%~dp0
set VERSION_PROJECT_TOML=%1

%JULIA_161% --color=yes --project %basepath%update_project_toml.jl %VERSION_PROJECT_TOML%
IF %ERRORLEVEL% NEQ 0 (
    EXIT 1
)