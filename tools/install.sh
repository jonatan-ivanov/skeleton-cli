main() {
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

    # Only enable exit-on-error after the non-critical colorization stuff,
    # which may fail on systems lacking tput or terminfo
    set -e

    GIT_REPO_URL='https://github.com/jonatan-ivanov/skeleton-cli.git'
    INSTALL_DIR=~/.sk
    RUNNABLE_PATH=sk.groovy
    RUNNABLE_LINK=/usr/local/bin/sk
    LAST_UPDATED_FILE=$INSTALL_DIR/.last-updated
    EPOCH_DAYS=$(( $(date +%s) / 60 / 60 / 24 ))

    if [ -d "$INSTALL_DIR" ]; then
        printf "${YELLOW}Already installed.${NORMAL}\n"
        printf "You'll need to remove $INSTALL_DIR if you want to re-install.\n"
        exit
    fi

    # Prevent the cloned repository from having insecure permissions. Failing to do
    # so causes compinit() calls to fail with "command not found: compdef" errors
    # for users with insecure umasks (e.g., "002", allowing group writability). Note
    # that this will be ignored under Cygwin by default, as Windows ACLs take
    # precedence over umasks except for filesystems mounted with option "noacl".
    umask g-w,o-w

    printf "${BLUE}Cloning...${NORMAL}\n"
    hash git >/dev/null 2>&1 || {
        echo "Error: git is not installed"
        exit 1
    }
    # The Windows (MSYS) Git is not compatible with normal use on cygwin
    if [ "$OSTYPE" = cygwin ]; then
        if git --version | grep msysgit > /dev/null; then
            echo "Error: Windows/MSYS Git is not supported on Cygwin"
            echo "Error: Make sure the Cygwin git package is installed and is first on the path"
            exit 1
        fi
    fi
    env git clone --depth=1 $GIT_REPO_URL $INSTALL_DIR || {
        printf "Error: git clone failed\n"
        exit 1
    }

    ln -s $INSTALL_DIR/$RUNNABLE_PATH $RUNNABLE_LINK
    echo "LAST_UPDATED_EPOCH_DAYS=$EPOCH_DAYS" > $LAST_UPDATED_FILE

    printf "${GREEN}"
    echo 'Installation completed.'
    echo "    Installation directory: $INSTALL_DIR"
    echo "    Runnable link: $RUNNABLE_LINK"
    echo ''
    printf "${NORMAL}"
}

main
