# Use colors, but only if connected to a terminal, and that terminal supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

INSTALL_DIR=~/.sk

printf "${BLUE}%s${NORMAL}\n" "Updating..."
cd "$INSTALL_DIR"
if git pull --rebase --stat origin master
then
    printf "${BLUE}%s\n" "Hooray! Update has been completed and/or is at the current version."
else
    printf "${RED}%s${NORMAL}\n" 'There was an error updating. Try again later?'
fi
