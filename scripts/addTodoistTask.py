from pytodoist import todoist
import os
import sys

# to make this work: add the token api from todoist in ~/.todoistToken

defaultProject = "Inbox"

with open(os.path.expanduser("~/.todoistToken"), "r") as f:
    token = f.readlines()[0].replace("\n", "")

user = todoist.login_with_api_token(token)

project = user.get_project(defaultProject)

taskName = " ".join(sys.argv[1:])
task = project.add_task(taskName)
