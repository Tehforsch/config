from pytodoist import todoist
import argparse
import os
import sys

defaultProject = "Inbox"
# to make this work: add the token api from todoist in ~/.todoistToken

def addTask(taskName, projectName=None):
    if projectName is None:
        projectName = defaultProject

    with open(os.path.expanduser("~/.todoistToken"), "r") as f:
        token = f.readlines()[0].replace("\n", "")

    user = todoist.login_with_api_token(token)
    project = user.get_project(projectName)
    task = project.add_task(taskName)


parser = argparse.ArgumentParser(description='Run the given simulation by copying it to the simulation folder along with src and executable and running it.')

parser.add_argument("name", nargs="*", help="Name of the task")
parser.add_argument("-p", nargs = 1, dest="project", help="Name of the project")

args = parser.parse_args()
addTask(args.name, args.project[0])
