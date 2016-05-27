#!/usr/bin/python3.5
#TODO implement year and month cycles
from datetime import date, timedelta
from dateutil.relativedelta import relativedelta
import os

# Read the file "timed" which contains tasks that are to appear in the todo list at a certain point in time (or e.g. every monday, every january, every 13 days starting from 15-07-03)
# Update the metadata file in .meta/timed which contains the info on when the task was last added
# This prevents a task from appearing twice per day/month/week after it has been removed by the user (me)

class Task:
    def __init__(self, name, category, dueDate, cycle):
        self.name = name
        self.category = category
        self.dueDate = dueDate
        self.cycle = cycle

    def isDue(self, date):
        return (date >= self.dueDate)

    def update(self, date):
        assert self.isDue(date)
        if self.cycle == None:
            return True
        else:
            while self.dueDate <= date:
                if type(self.cycle) == str: # Monthly or yearly task
                    if "m" in self.cycle:
                        months = int(self.cycle.replace("m", ""))
                        self.dueDate += relativedelta(months=months)
                    elif "y" in self.cycle:
                        years = int(self.cycle.replace("y", ""))
                        self.dueDate += relativedelta(years=years)
                else:
                    self.dueDate += timedelta(self.cycle)

    def __str__(self):
        line = self.name + separator + str(self.dueDate)
        if self.cycle != None:
            line = line + separator + str(self.cycle)
        return line

def taskFromLine(category, line):
    # Entries are of the form "Name, starting date(, cycle length)"
    assert line.count(separator) >= 1, "Invalid line: " + line
    split = [l.strip() for l in line.split(separator)]
    name, dueDate = split[:2]
    cycle = None if len(split) <= 2 else split[2].lower()
    if cycle != None and not ("m" in cycle or "y" in cycle): # Normal cycles, i.e. no monthly or yearly tasks.
        cycle = int(cycle)
    dueDate = convertDate(dueDate)
    return Task(name, category, dueDate, cycle)

def stripComment(line):
    return "".join([line[i] for i in range(len(line)) if not "#" in line[:i+1]])

def readTimedFile(filename):
    f = open(filename, "r")
    lines = [l.replace("\n", "") for l in f.readlines()]
    f.close()
    lines = [stripComment(line) for line in lines]
    return [line for line in lines if not line == ""] # Ignore empty lines and comments

def getTasks(category, lines):
    return [taskFromLine(category, l) for l in lines]

def convertDate(dateString):
    return date(*[int(x) for x in dateString.split("-")])

def writeTodoEntries(dueTasks):
    for task in dueTasks:
        writeTodoEntry(task)

def writeTodoEntry(task):
    # Open the todo category, create directory if necessary.
    if not os.path.isdir(task.category):
        os.system("$CONFIG/scripts/newTodoFolder.sh " + task.category)
    fread = open(task.category + "/nextActions", "r")
    for line in fread.readlines():
        if task.name in line: # Already added to todo list
            return
    fread.close()
    f = open(task.category + "/nextActions", "a")
    # Append the task
    f.write(task.name + "\n")
    f.close()

def writeNewInfoFile(fname, tasks):
    f = open(fname, "w")
    f.write("\n".join([str(task) for task in tasks]) + ("" if len(tasks) == 0 else "\n"))
    f.close()

def update(d):
    for category in os.listdir():
        if os.path.isdir(category):
            fname = os.path.join(category, userEntryFileName)
            if not os.path.isfile(fname):
                continue
            tasks = getTasks(category, readTimedFile(fname))
            # Find out which tasks are due
            due = [task for task in tasks if task.isDue(d)]
            # Delete one time (cycle == None) tasks that were due 
            tasks = [task for task in tasks if not (task.cycle == None and task.isDue(d))]
            # Update the new due dates
            for task in due:
                task.update(d)
            # Add an entry in the todo list for each due task
            writeTodoEntries(due)
            # Write the new tasks with modified lastDue date to the file
            writeNewInfoFile(fname, tasks)

userEntryFileName = "timed"
separator = ";"

# d = date(2015, 12, 5)
# for i in range(200):
    # d = d + timedelta(20)
    # update(d)
update(date.today())
