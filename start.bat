@echo off

set PYTHON=%~dp0/venv/Scripts/python.exe
set GIT=
set VENV_DIR=./venv
set COMMANDLINE_ARGS=

%PYTHON% main.py %COMMANDLINE_ARGS%