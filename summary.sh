
SUMMARY=$1
rm -rf $SUMMARY

if [[ -f .log_update ]]; then 
    echo "## Update" >> $SUMMARY
    cat .log_update >> $SUMMARY
fi

if [[ -f .log_add ]]; then 
    echo "## Add new track" >> $SUMMARY
    cat .log_add >> $SUMMARY
fi

if [[ ! -f $SUMMARY ]]; then
    echo "Nothing changed"
    exit 1
fi

exit 0