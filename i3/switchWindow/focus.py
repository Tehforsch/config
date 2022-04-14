import sys
import json
import subprocess

def pp(x):
    print(json.dumps(x, indent=4, sort_keys=True))

def getTree():
    treeString = subprocess.check_output(["i3-msg", "-t", "get_tree"])
    tree = json.loads(treeString)
    return tree

def getContainerNode(output):
    return next(node for node in output["nodes"] if node["type"] == "con")

def isFocused(workspace):
    assert workspace["type"] == "workspace"
    for window in workspace["nodes"]:
        if window["focused"]:
            return True

def findFocusedWorkspace(outputs):
    return next(workspace for output in outputs for workspace in getContainerNode(output)["nodes"] if isFocused(workspace))

def main():
    rootNode = getTree()
    workspace = findFocusedWorkspace(rootNode["nodes"])
    windows = workspace["nodes"]
    # Dont know how to properly focus a specific window but it also doesnt matter because this is hacky as fuck anyways
    currentlyFocusedIndex = next(i for (i, window) in enumerate(windows) if window["focused"])
    toFocus = int(sys.argv[1])
    if toFocus >= len(windows):
        toFocus = len(windows) - 1
    distance = currentlyFocusedIndex - toFocus
    while distance < 0:
        subprocess.check_output(["i3-msg", "focus", "right"])
        distance += 1
    while distance > 0:
        subprocess.check_output(["i3-msg", "focus", "left"])
        distance -= 1



main()
