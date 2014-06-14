import matplotlib.pyplot as plot

def readFile(fname):
    """Returns the lines contained in fname in standard list format"""
    f = open(fname, "r")
    lines = f.readlines()
    f.close()
    return lines

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

def plotData(pairs):
    """Uses pyplot to quickly plot a list of (x, y) pairs"""
    xs = []
    ys = []
    for pair in pairs:
        xs.append(pair[0])
        ys.append(pair[1])
    plot.plot(xs, ys, 'ro')
    #plot.axis([0, 6, 0, 20])
    plot.show()

def transpose(lst):
    """Returns the transposed (rectangular) list"""
    for i in range(len(lst)-1):
        assert(len(lst[i]) == len(lst[i+1]))
    return list(map(list, zip(*lst)))
