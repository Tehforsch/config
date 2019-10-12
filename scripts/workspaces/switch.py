import argparse
import os
from math import ceil
import i3
from config import *
import watchContext

workspaceNameFormat = "{workspaceId}:{contextName}{workspaceNumber}"
sharedWorkspaceNameFormat = "{workspaceId}:{workspaceName}"

numSharedWorkspaces = len(sharedWorkspaceNames)
offsetPerContext = (ceil(workspacesPerContext / niceNumber)) * niceNumber
minContextOffset = ceil(numSharedWorkspaces / offsetPerContext) * offsetPerContext

def getWorkspaceId(contextNumber, workspaceNumber):
    return minContextOffset + offsetPerContext * contextNumber + workspaceNumber

def getNumbersFromId(workspaceId):
    contextNumber = (workspaceId - minContextOffset) // offsetPerContext
    workspaceNumber = workspaceId - contextNumber * offsetPerContext - minContextOffset
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
    if workspaceId < numSharedWorkspaces:
        # We're on a shared workspace. We can't infer the previous context anymore so
        # read it from the file. This is ugly but I think its still better than starting a 
        # daemon
        return watchContext.getContext()
    contextNumber, workspaceNumber = getNumbersFromId(workspaceId)
    return contextNumber

def getContextName(contextNumber):
    return contextNames[contextNumber]

def getSharedWorkspaceId(sharedWorkspaceNumber):
    return sharedWorkspaceNames.index(sharedWorkspaceNumber)

def getSharedWorkspaceName(sharedWorkspaceName):
    print(sharedWorkspaceName)
    assert sharedWorkspaceName in sharedWorkspaceNames
    workspaceId = getSharedWorkspaceId(sharedWorkspaceName)
    return sharedWorkspaceNameFormat.format(workspaceId=workspaceId, workspaceName=sharedWorkspaceName)

def getWorkspaceName(contextNumber, workspaceNumber):
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
    parser.add_argument('--switchWorkspace', default=None, type=int, help="Switch to given workspace number")
    parser.add_argument('--moveToWorkspace', default=None, type=int, help="Move the focused window to the given workspace number")
    parser.add_argument('--switchSharedWorkspace', default=None, type=str, help="Switch to the given shared workspace")
    parser.add_argument('--moveToSharedWorkspace', default=None, type=str, help="Move the focused window to the given shared workspace")
    args = parser.parse_args()
    return args

def main():
    args = setupArgs()
    if args.switchContext is not None:
        switchContext(args.switchContext)
    if args.moveToContext is not None:
        moveToContext(args.moveToContext)
    if args.switchWorkspace is not None:
        switchWorkspace(getWorkspaceName(getFocusedContextNumber(), args.switchWorkspace))
    if args.moveToWorkspace is not None:
        moveToWorkspace(getWorkspaceName(getFocusedContextNumber(), args.moveToWorkspace))
    if args.switchSharedWorkspace is not None:
        watchContext.setContext(getFocusedContextNumber())
        switchWorkspace(getSharedWorkspaceName(args.switchSharedWorkspace))
    if args.moveToSharedWorkspace is not None:
        watchContext.setContext(getFocusedContextNumber())
        moveToWorkspace(getSharedWorkspaceName(args.moveToSharedWorkspace))

main()
