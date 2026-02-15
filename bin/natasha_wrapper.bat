:: Natasha Process Wrapper
:: Configure your extension's "Process Wrapper" setting to point here.
:: This ensures every command spawned by the agent inherits the Natasha environment.

:: 1. Re-assert the Global Root (in case the shell was stripped)
if not defined AGENT_GLOBAL_ROOT set AGENT_GLOBAL_ROOT=%USERPROFILE%\.agents

:: 2. Re-inject Binaries to Path (crucial for finding custom tools)
:: This ensures the agent can find things like 'python' or your 'bin' scripts
set PATH=%PATH%;%AGENT_GLOBAL_ROOT%\bin

:: 3. Execute the requested command
%*
