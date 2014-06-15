import numpy as np

def readFile(fname):
    """Returns the lines contained in fname in standard list format"""
    f = open(fname, "r")
    lines = f.readlines()
    f.close()
    return lines

def writeFile(fname, content):
    """Writes the content into a file of path fname"""
    f = open(fname, "w")
    f.write(content)
    f.close()

def readDataFile(fname, sep = " "):
    """Reads the file fname and returns a list of numpy arrays 
    where each array corresponds to a line in the file
    and each entry is separated by sep (default : " ")"""
    lines = readFile(fname)
    data = []
    for l in lines:
        splitted = l.replace("\n", "").split(sep)
        data.append(list(map(float, splitted)))
    return list(map(np.array, data))

def writeDataFile(fname, data, sep = " "):
    """Writes the data to the file fname, separating each list with
    a line break and each entry with sep (default " ")"""
    strData = map(lambda x : map(str, x), data)
    s = "\n".join(map(sep.join, strData))
    writeFile(fname, s)

def charactersBetween(string, beginning, end):
    """Returns all characters in a string that are contained between two characters beginning and end"""
    collected = ""
    collect = False
    for z in string:
        if z == beginning:
            collect = True
            continue
        if z == end and collect:
            return collected
        if collect:
            collected = collected + z
    return None

# def plotData(pairs):
#     """Uses pyplot to quickly plot a list of (x, y) pairs"""
#     xs = []
#     ys = []
#     for pair in pairs:
#         xs.append(pair[0])
#         ys.append(pair[1])
#     plot.plot(xs, ys, 'ro')
#     #plot.axis([0, 6, 0, 20])
#     plot.show()

def transpose(lst):
    """Returns the transposed (rectangular) list"""
    for i in range(len(lst)-1):
        assert(len(lst[i]) == len(lst[i+1]))
    return list(map(list, zip(*lst)))
