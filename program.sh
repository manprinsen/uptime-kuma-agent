#!/bin/sh

# Constants
LOG_FILE="log.txt"
MAX_LOG_SIZE=$((10 * 1024 * 1024)) # 10 MB
CURL_TIMEOUT=5 # 10 seconds

# Function to set up logging
setup_logging() {
    if [ ! -f $LOG_FILE ]; then
        touch $LOG_FILE
    fi
}

# Function to rotate logs
rotate_logs() {
    log_size=$(wc -c <"$LOG_FILE")
    if [ "$log_size" -ge "$MAX_LOG_SIZE" ]; then
        for i in {4..1}; do
            if [ -f "$LOG_FILE.$i" ]; then
                mv "$LOG_FILE.$i" "$LOG_FILE.$((i + 1))"
            fi
        done
        mv "$LOG_FILE" "$LOG_FILE.1"
        touch $LOG_FILE
    fi
}

# Function to log messages
log_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO: $1" >> $LOG_FILE
    rotate_logs
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $1" >> $LOG_FILE
    rotate_logs
}

# Function to parse command-line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --isp)
                ISP="$2"
                shift 2
                ;;
            --base_url)
                BASE_URL="$2"
                shift 2
                ;;
            --interval)
                INTERVAL="$2"
                shift 2
                ;;
            *)
                log_error "Invalid option: $1"
                exit 1
                ;;
        esac
    done
}

# Function to perform ping and return average time
perform_ping() {
    ping_result=$(ping -c 1 $ISP | awk -F'/' 'END {print $5}')
    if [ -z "$ping_result" ]; then
        log_error "Ping failed"
        ping_result='N/A'
    fi
    echo $ping_result
}

# Function to perform HTTP request
perform_http_request() {
    local url=$1
    response=$(curl -s -m $CURL_TIMEOUT -w "%{http_code}" -o /dev/null $url)
    if [ $? -eq 0 ]; then
        log_info "CURL command executed. Response status: $response"
    else
        log_error "Failed to execute CURL command"
    fi
}

# Main function
main() {
    setup_logging

    log_info "START"
    log_info "ISP: $ISP"
    log_info "BASE_URL: $BASE_URL"

    while true; do
        ping_result=$(perform_ping)
        url="${BASE_URL}?status=up&msg=OK&ping=${ping_result}"

        log_info "FULL_URL: $url"

        perform_http_request $url

        if [ -z "$INTERVAL" ]; then
            break
        else
            log_info "Sleeping for $INTERVAL seconds"
            sleep $INTERVAL
        fi
    done
}

# Source environment variables (if any)
if [ -f ".env" ]; then
    source .env
fi

# Parse command-line arguments
parse_args "$@"

# Check if ISP and BASE_URL are provided
if [ -z "$ISP" ]; then
    log_error "No ISP provided. Please provide an ISP to ping."
    exit 1
fi

if [ -z "$BASE_URL" ]; then
    log_error "No BASE_URL provided. Please provide a BASE_URL for the HTTP request."
    exit 1
fi

# Run the main function
main
