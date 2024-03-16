@echo on

md %LIBRARY_PREFIX%\share\askbot
pushd %LIBRARY_PREFIX%\share\askbot
md node_modules
cmd /c "npm install askbot@%PKG_VERSION%"
if errorlevel 1 exit 1
popd

pushd %LIBRARY_PREFIX%\bin
for %%c in (askbot) do (
  echo @echo off >> %%c.bat
  echo "%LIBRARY_PREFIX%\share\askbot\node_modules\.bin\%%c.cmd" %%* >> %%c.bat
)
popd

@rem port yarn.lock to pnpm-lock.yaml
cmd /c "pnpm import"
if errorlevel 1 exit 1

@rem install all (prod) dependencies, this needs to be done for pnpm to properly list all dependencies later on
cmd /c "pnpm install --prod"
if errorlevel 1 exit 1

@rem list all dependencies and then call pnpm-licenses to generate the ThirdPartyLicenses.txt file
cmd /c "pnpm licenses list --prod --json | pnpm-licenses generate-disclaimer --prod --json-input --output-file=ThirdPartyLicenses.txt"
if errorlevel 1 exit 1

@rem log directory structure in order to easily verify if porting yarn.lock, installing packages and generating licenses worked
dir
