@echo off

set PYTHON=./venv/Scripts/python.exe
set GIT=
set VENV_DIR=./venv
set COMMANDLINE_ARGS=

# execute the python script
%PYTHON% main.py %COMMANDLINE_ARGS%