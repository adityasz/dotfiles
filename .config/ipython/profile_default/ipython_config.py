import os
from pathlib import Path
 
c.HistoryManager.hist_file = (
    Path(os.environ.get("XDG_STATE_HOME", Path("~/.local/state").expanduser()))
    / "ipython"
    / "history.sqlite"
)

c.TerminalInteractiveShell.editing_mode = 'vi'
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.TerminalIPythonApp.display_banner = False
