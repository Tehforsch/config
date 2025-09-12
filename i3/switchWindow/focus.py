import sys
import json
import subprocess

class Node:
    def __init__(self, d):
        nodesData = d["nodes"]
        del d["nodes"]
        self.nodes = [Node(node) for node in nodesData]
        self.data = d


    def __repr__(self):
        return json.dumps(self.data, indent=4, sort_keys=True)


    def isWindow(self):
        return self.nodes == []


def getTree():
    treeString = subprocess.check_output(["i3-msg", "-t", "get_tree"])
    tree = json.loads(treeString)
    return tree


def getContainerNode(output):
    return next(node for node in output["nodes"] if node["type"] == "con")


def isFocused(workspace):
    print(workspace)
    for window in workspace["nodes"]:
        pp(window)
        if window["focused"]:
            return True


def depthFirstSearch(tree):
    for node in tree.nodes:
        yield node
        for n in depthFirstSearch(node):
            yield n


def main():
    rootNode = Node(getTree())
    windows = (node for node in depthFirstSearch(rootNode) if node.isWindow())
    focusedWindow = next(window for window in windows if window.data["focused"])
    # Welcome to the worlds slowest "parent finding" algorithm
    parentContainer = next(node for node in depthFirstSearch(rootNode) if focusedWindow in node.nodes)
    currentlyFocusedIndex = parentContainer.nodes.index(focusedWindow)
    numWindowsInContainer = len(parentContainer.nodes)
    # Dont know how to properly focus a specific window but it also doesnt
    # matter because this is hacky as fuck anyways
    toFocus = int(sys.argv[1])
    if toFocus >= numWindowsInContainer:
        toFocus = numWindowsInContainer - 1
    distance = currentlyFocusedIndex - toFocus
    while distance < 0:
        subprocess.check_output(["i3-msg", "focus", "right"])
        distance += 1
    while distance > 0:
        subprocess.check_output(["i3-msg", "focus", "left"])
        distance -= 1

main()
