read -r -p "Are you sure you want to remove? [y/N] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
    echo "Uninstall cancelled"
    exit
fi

INSTALL_DIR=~/.sk
RUNNABLE_LINK=/usr/local/bin/sk

echo "Removing $INSTALL_DIR"
if [ -d "$INSTALL_DIR" ]; then
    rm -rf $INSTALL_DIR
fi

echo "Removing $RUNNABLE_LINK"
rm -f $RUNNABLE_LINK
