#!/bin/sh

# Set up logging
LOG_FILE="/root/uptime-kuma-agent/log.txt"
MAX_LOG_SIZE=1048576 # 1 MB

# Function to log messages
log() {
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP $1" >> "$LOG_FILE"
}

# Function to check if log file exists
check_log_exists() {
    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE"
    fi
}

# Function to check log file size and delete if exceeds limit
check_log_size() {
    FILESIZE=$(du -b "$LOG_FILE" | cut -f1)
    if [ $FILESIZE -ge $MAX_LOG_SIZE ]; then
        rm "$LOG_FILE"
        echo "Deleted $LOG_FILE due to size limit reached."
        touch "$LOG_FILE"
    fi
}

# Parse command-line arguments
while [ "$1" != "" ]; do
    case $1 in
        --isp )           shift
                          ISP=$1
                          ;;
        --base_url )      shift
                          BASE_URL=$1
                          ;;
        --interval )      shift
                          INTERVAL=$1
                          ;;
    esac
    shift
done

# Check if ISP and BASE_URL are provided
if [ -z "$ISP" ]; then
    echo "No ISP provided. Please provide an ISP to ping."
    exit 1
fi

if [ -z "$BASE_URL" ]; then
    echo "No BASE_URL provided. Please provide a BASE_URL for the HTTP request."
    exit 1
fi

# Main loop
while true; do
    check_log_exists
    check_log_size
    log "START"
    log "ISP: $ISP"
    log "BASE_URL: $BASE_URL"

    # Perform the ping test and extract the average ping time
    PING_RESULT=$(ping -c 1 "$ISP" 2>/dev/null | grep 'time=' | awk -F'time=' '{ print $2 }' | awk '{ print $1 }')
    if [ -z "$PING_RESULT" ]; then
        PING_RESULT='N/A'
    fi

    # Construct the request URL with the dynamic ping value
    URL="${BASE_URL}?status=up&msg=OK&ping=${PING_RESULT}"
    log "FULL_URL: $URL"

    # Execute the HTTP request
    RESPONSE=$(curl --max-time 5 -s -o /dev/null -w "%{http_code}" "$URL")
    if [ $? -eq 0 ]; then
        log "CURL command executed. Response status: $RESPONSE"
    else
        log "Failed to execute CURL command."
    fi

    # If no interval is provided, run only once
    if [ -z "$INTERVAL" ]; then
        break
    else
        log "Sleeping for $INTERVAL seconds"
        sleep "$INTERVAL"
    fi
done
