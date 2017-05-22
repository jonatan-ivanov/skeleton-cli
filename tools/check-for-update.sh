INSTALL_DIR=~/.sk
LAST_UPDATED_FILE=$INSTALL_DIR/.last-updated
UPDATE_THRESHOLD_DAYS=7
EPOCH_DAYS=$(( $(date +%s) / 60 / 60 / 24 ))

function update_app() {
    $INSTALL_DIR/tools/update.sh
    exit 0
}

if [ -f "$LAST_UPDATED_FILE" ]; then
    . $LAST_UPDATED_FILE

    if [[ -z "$LAST_UPDATED_EPOCH_DAYS" ]]; then
        update_app
    fi

    epoch_diff=$(($EPOCH_DAYS - $LAST_UPDATED_EPOCH_DAYS))
    if [ $epoch_diff -ge $UPDATE_THRESHOLD_DAYS ]; then
        update_app
    fi
else
    update_app
fi
