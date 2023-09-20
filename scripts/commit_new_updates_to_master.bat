@echo off

set basepath=%~dp0

for /f "Tokens=*" %%a in (%basepath%\PSRIO.ver) do @set psrio_version=%%a
git config --local user.name "GithubPSRIOUpdater"
git add %basepath%..\Artifacts.toml 
git add %basepath%..\Project.toml 
git commit -m "[PSRIO update] version %psrio_version%"
git push origin master