import atexit
import readline
import os

default_python_history = os.path.join(os.path.expanduser('~'), 'python_history')

precursor = readline.write_history_file
readline.write_history_file = lambda f: None if f == default_python_history else precursor(f)

xdg_python_state = os.path.join(os.getenv('XDG_STATE_HOME'), 'python')
xdg_python_history = os.path.join(xdg_python_state, 'history')

try:
    readline.read_history_file(xdg_python_history)
except FileNotFoundError:
    pass

def write_history():
    try:
        readline.write_history_file(xdg_python_history)
    except FileNotFoundError:
        os.mkdir(xdg_python_state, mode=0o755)
        write_history()

atexit.register(write_history)
