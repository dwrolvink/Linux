# Does a grep on the output of ps (all processes), takes the first process, and kills it
# > fkill teams
function fkill { ps -eo pid,comm,cmd --no-headers | sed 's/^ *//g' | grep "$1" | head -n 1 | tee /dev/tty | cut -d ' ' -f 1 | xargs kill -9; }

# Same ps statement as above, but no killing
function fps { ps -eo pid,comm,cmd --no-headers | sed 's/^ *//g' | grep "$1" }
