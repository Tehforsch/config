import sys
import argparse
import os
from pathlib import Path

modeFile = Path(os.path.expanduser("~"), ".mode")
workspaceNameFormat = "{}_{}"

def setWorkspace(workspaceName):
    modeName = getMode()
    os.system("i3-msg workspace {}".format(workspaceNameFormat.format(modeName, workspaceName)))

def getMode():
    with modeFile.open("r") as f:
        return f.readlines()[0].replace("\n", "")

def setMode(mode):
    with modeFile.open("w") as f:
        f.write(mode)

def setupArgs():
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--mode', default=None, type=str, help="Switch to given mode")
    parser.add_argument('--workspace', default=None, type=str, help="Switch to given workspace")
    args = parser.parse_args()
    return args

args = setupArgs()
if args.mode is not None:
    setMode(args.mode)
if args.workspace is not None:
    setWorkspace(args.workspace)
