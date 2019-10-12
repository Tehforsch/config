import sys
import argparse
import os
from pathlib import Path
from math import ceil
import i3

defaultContext = 0
contextNames = {
        0: "a",
        1: "b",
        2: "c",
        3: "d",
        4: "e",
}

sharedWorkspaceNames = ["music"]
contextFile = Path(os.path.expanduser("~"), ".context")
workspaceNameFormat = "{workspaceId}:{contextName}{workspaceNumber}"
sharedWorkspaceNameFormat = "{workspaceId}:{workspaceName}"

numSharedWorkspaces = len(sharedWorkspaceNames)
workspacesPerContext = 12
offsetPerContext = (ceil(workspacesPerContext / 10)) * 10
minContextOffset = ceil(numSharedWorkspaces / offsetPerContext)

def getWorkspaceId(contextNumber, workspaceNumber):
    return offsetPerContext * contextNumber + workspaceNumber

def getNumbersFromId(workspaceId):
    contextNumber = workspaceId // offsetPerContext
    workspaceNumber = workspaceId - contextNumber * offsetPerContext
    assert getWorkspaceId(contextNumber, workspaceNumber) == workspaceId
    return contextNumber, workspaceNumber

def getFocusedWorkspaceId():
    workspaces = i3.get_workspaces()
    for ws in workspaces:
        if ws['focused'] == True:
            return ws['num']

def getFocusedWorkspaceNumber():
    workspaceId = getFocusedWorkspaceId()
    contextNumber, workspaceNumber = getNumbersFromId(workspaceId)
    return workspaceNumber

def getFocusedContextNumber():
    workspaceId = getFocusedWorkspaceId()
    contextNumber, workspaceNumber = getNumbersFromId(workspaceId)
    return contextNumber

def getContextName(contextNumber):
    return contextNames[contextNumber]

def createContextFileIfItDoesNotExist():
    if not contextFile.is_file():
        with contextFile.open("w") as f:
            f.write(str(defaultContext))

def getSharedWorkspaceId(sharedWorkspaceNumber):
    return sharedWorkspaceNames.index(sharedWorkspaceNumber)

def getSharedWorkspaceName(sharedWorkspaceName):
    assert sharedWorkspaceName in sharedWorkspaceNames
    workspaceId = getSharedWorkspaceId(sharedWorkspaceName)
    return sharedWorkspaceNameFormat.format(workspaceId=workspaceId, workspaceName=sharedWorkspaceName)

def getWorkspaceName(contextNumber, workspaceIdentifier):
    if workspaceIdentifier in sharedWorkspaceNames:
        return getSharedWorkspaceName(workspaceIdentifier)
    else:
        return getNonSharedWorkspaceName(contextNumber, int(workspaceIdentifier))

def getNonSharedWorkspaceName(contextNumber, workspaceNumber):
    contextName = getContextName(contextNumber)
    workspaceId = getWorkspaceId(contextNumber, workspaceNumber)
    workspaceName = workspaceNameFormat.format(contextName=contextName, workspaceNumber=workspaceNumber, workspaceId=workspaceId)
    return workspaceName

def switchWorkspace(workspaceName):
    os.system("i3-msg workspace {}".format(workspaceName))

def moveToWorkspace(workspaceName):
    os.system("i3-msg move workspace {}".format(workspaceName))
    switchWorkspace(workspaceName)

def switchContext(contextNumber):
    focusedWorkspaceNumber = getFocusedWorkspaceNumber()
    switchWorkspace(getWorkspaceName(contextNumber, focusedWorkspaceNumber))

def moveToContext(contextNumber):
    focusedWorkspaceNumber = getFocusedWorkspaceNumber()
    workspaceName = getWorkspaceName(contextNumber, focusedWorkspaceNumber)
    moveToWorkspace(workspaceName)
    switchWorkspace(workspaceName)

def setupArgs():
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--switchContext', default=None, type=int, help="Switch to given context")
    parser.add_argument('--moveToContext', default=None, type=int, help="Move the focused window to the corresponding workspace in another context")
    parser.add_argument('--switchWorkspace', default=None, type=str, help="Switch to given workspace number")
    parser.add_argument('--moveToWorkspace', default=None, type=str, help="Move the focused window to the given workspace number")
    args = parser.parse_args()
    return args

def main():
    createContextFileIfItDoesNotExist()
    args = setupArgs()
    if args.switchContext is not None:
        switchContext(args.switchContext)
    if args.moveToContext is not None:
        moveToContext(args.moveToContext)
    if args.switchWorkspace is not None:
        switchWorkspace(getWorkspaceName(getFocusedContextNumber(), args.switchWorkspace))
    if args.moveToWorkspace is not None:
        moveToWorkspace(getWorkspaceName(getFocusedContextNumber(), args.moveToWorkspace))

main()
