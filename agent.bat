call "c:\ProgramData\miniconda3\condabin\activate.bat" base

:: Set Global Environment Variable for all child processes (VS Code + Extensions)
set AGENT_GLOBAL_ROOT=%USERPROFILE%\.agents
set PATH=%PATH%;%AGENT_GLOBAL_ROOT%\bin

:: Run the orchestrator to sync configs/overrides
python agent.py

:: Launch VS Code with the inherited environment
code .
