import sys, os
from re import finditer, search
from pathlib import Path
import subprocess
import logging

def get_files(path: Path):
    return [path / f for f in os.listdir(path)]

def is_movie(path: Path):
    return path.suffix == ".MP4"

def is_pic(path: Path):
    return path.suffix == ".JPG"

def view_photo(path: Path) -> None:
    tmpfile = Path("/tmp/previews") / path.name
    args = ["kitty", "+kitten", "icat", "--silent", "--transfer-mode", "file", str(tmpfile)]
    logging.debug(path)
    subprocess.check_call(args)


def view_movie(path: Path):
    args = ["vlc", str(path)]
    subprocess.check_call(args)

def get_action():
    while True:
        i = input("Action: ")
        if i == "d":
            return "delete"
        elif i == "r":
            return "rename"
        elif i == "k":
            return "keep"
        else:
            print("Invalid action. Valid actions: d/r/k")

def camel_case_split(identifier):
    matches = finditer('.+?(?:(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])|$)', identifier)
    return [m.group(0) for m in matches]

def get_existing(dir_name):
    existing = []
    for f in get_files(dir_name / "sorted"):
        s = camel_case_split(f.stem)
        climber_attempt = s[-1]
        name = "".join(s[0:-1])
        g = search("([a-zA-Z]+)([0-9]+)", climber_attempt)
        climber = g.groups()[0]
        attempt = g.groups()[1]
        existing.append((name, climber, attempt))
    return existing
        
def select(prompt, existing):
    for (i, e) in enumerate(existing):
        print(f"{i}: {e}")
    inp = input(prompt)
    try:
        index = int(inp)
        return existing[index]
    except ValueError as e:
        return inp
    
    
def get_boulder_name(dir_name):
    existing = sorted(list(set(x[0] for x in get_existing(dir_name))))
    return select("Boulder:", existing)

def get_climber_name(dir_name):
    existing = sorted(list(set(x[1] for x in get_existing(dir_name))))
    climber = select("Climber:", existing)
    if climber[0].islower():
        climber = climber[0].upper() + climber[1:]
    return climber
    
def get_attempt(dir_name):
    existing = get_existing(dir_name)
    if existing == []:
        index = 1
    else:
        index = max(int(x[2]) for x in existing) + 1
    return f"{index:02}"
    
def get_new_name(dir_name, suffix):
    boulder_name = get_boulder_name(dir_name)
    climber_name = get_climber_name(dir_name)
    attempt = get_attempt(dir_name)
    return f"{boulder_name}{climber_name}{attempt}{suffix}"
    
def handle_all(paths, dir_name, view):
    dir_name.mkdir(exist_ok=True)
    (dir_name / "sorted").mkdir(exist_ok=True)
    (dir_name / "unsorted").mkdir(exist_ok=True)
    for path in paths:
        handle(path, dir_name, view)

def handle(path, dir_name, view):
    view(path)
    action = get_action()
    if action == "delete":
        print(f"deleting {path}")
        os.unlink(path)
    elif action == "rename":
        name = get_new_name(dir_name, path.suffix)
        print("renaming", path, "->", dir_name / name)
        os.rename(path, dir_name / "sorted" / name)
    elif action == "keep":
        name = path.name
        print("renaming", path, "->", dir_name / name)
        os.rename(path, dir_name / "unsorted" / name)
    
def make_preview(pics, path):
    path.mkdir(exist_ok=True)
    for pic in pics:
        width = 800
        height = 600
        tmpfile = path / Path(pic.name)
        if tmpfile.exists():
            continue
        args = ["convert", str(pic), "-scale", f"{width}x{height}", str(tmpfile)]
        subprocess.check_call(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
path = Path(sys.argv[1])

files = [f for f in get_files(path) if f.is_file()]
pics = sorted([f for f in files if is_pic(f)])
movies = sorted([f for f in files if is_movie(f)])

print("Generating previews")
make_preview(pics, Path("/tmp/previews"))
print("Sorting pictures")
handle_all(pics, Path("photos"), view_photo)
print("Sorting movies")
handle_all(movies, Path("movies"), view_movie)
