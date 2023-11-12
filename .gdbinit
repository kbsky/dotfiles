# Taken from https://gcc.gnu.org/onlinedocs/libstdc++/manual/debug.html
set print pretty on
set print object on

# Taken from https://sourceware.org/gdb/wiki/STLSupport
python
import sys, os
sys.path.insert(0, os.getenv('HOME') + '/share/gdb_printers/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

# Custom
set print static-members off

set history expansion
set history filename ~/.gdb_history
set history save

set disassemble-next-line auto
set multiple-symbols ask

alias -a di = disassemble
alias -a set di = set disassemble-next-line
alias -a show di = show disassemble-next-line

source /usr/share/gdb-dashboard/.gdbinit
dashboard -style syntax_highlighting 'monokai'
dashboard -layout stack source assembly registers threads history expressions memory
dashboard stack -style compact True
dashboard stack -style limit 4
