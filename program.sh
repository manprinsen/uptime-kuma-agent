#!/bin/sh

# Function to perform ping test
perform_ping() {
    ISP="$1"
    # Perform ping and capture result
    ping_result=$(ping -c 1 "$ISP" | awk -F'/| ' '/^rtt/{print $8}')
    if [ -z "$ping_result" ]; then
        ping_result="N/A"
    fi
    echo "Ping result for $ISP: $ping_result ms"
}

# Function to perform HTTP request
perform_http_request() {
    BASE_URL="$1"
    ping_result="$2"
    # Construct URL with ping result
    url="${BASE_URL}?status=up&msg=OK&ping=${ping_result}"

    timeout=10
    
    # Perform HTTP request using curl
    curl -m $timeout -s -o /dev/null "$url"
    curl_exit_code=$?

    if [ $curl_exit_code -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Failed to execute HTTP request to $BASE_URL (curl exit code: $curl_exit_code)"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') HTTP request sent to $BASE_URL"
    fi
}

# Main function
main() {
    # Parse command-line arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            --isp)
                ISP="$2"
                shift 2
                ;;
            --base_url)
                BASE_URL="$2"
                shift 2
                ;;
            *)
                echo "$(date '+%Y-%m-%d %H:%M:%S') Unknown option: $1"
                exit 1
                ;;
        esac
    done

    # Check if ISP and BASE_URL are provided
    if [ -z "$ISP" ] || [ -z "$BASE_URL" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Usage: $0 --isp <ISP_IP> --base_url <BASE_URL>"
        exit 1
    fi

    # Perform initial ping test
    perform_ping "$ISP"
    
    # Perform HTTP request with ping result
    perform_http_request "$BASE_URL" "$ping_result"
}

# Call main function with command-line arguments
main "$@"
