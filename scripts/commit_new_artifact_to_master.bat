@echo off

set basepath=%~dp0

for /f "Tokens=*" %%a in (%basepath%\psrio.ver) do @set psrio_version=%%a
git config --local user.name "GithubPSRIOUpdater"
git add %basepath%..\Artifacts.toml 
git commit -m "[PSRIO update] version %psrio_version%"
git push origin master