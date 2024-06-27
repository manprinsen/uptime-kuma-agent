import os
import logging
import argparse
import requests
import time
import pingparsing
from logging.handlers import RotatingFileHandler

# Set up logging with RotatingFileHandler
def setup_logging():
    handler = RotatingFileHandler('log.txt', maxBytes=10*1024*1024, backupCount=5)
    logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s', handlers=[handler])

setup_logging()

def main(isp, base_url, interval):
    p = pingparsing.PingParsing()
    transmitter = pingparsing.PingTransmitter()
    transmitter.destination = isp
    transmitter.count = 1

    while True:
        # Log the environment variables
        logging.info("START")
        logging.info(f"ISP: {isp}")
        logging.info(f"BASE_URL: {base_url}")

        # Perform the ping test and extract the average ping time
        try:
            result = transmitter.ping()
            ping_result = p.parse(result).as_dict()["rtt_avg"]
        except Exception as e:
            logging.error(f"Ping failed: {e}")
            ping_result = 'N/A'

        # Construct the request URL with the dynamic ping value
        url = f"{base_url}?status=up&msg=OK&ping={ping_result}"

        logging.info(f"FULL_URL: {url}")

        # Execute the HTTP request
        try:
            response = requests.get(url)
            logging.info(f"CURL command executed. Response status: {response.status_code}, Response body: {response.text}")
        except Exception as e:
            logging.error(f"Failed to execute CURL command: {e}")

        # If no interval is provided, run only once
        if interval is None:
            break
        else:
            logging.info(f"Sleeping for {interval} seconds")
            time.sleep(interval)

# Parse command-line arguments
parser = argparse.ArgumentParser(description='Ping ISP and send results to BASE_URL')
parser.add_argument('--isp', type=str, help='ISP server to ping')
parser.add_argument('--base_url', type=str, help='Base URL for the HTTP request')
parser.add_argument('--interval', type=int, help='Interval time in seconds to rerun the script')

args = parser.parse_args()

# Source the environment variables and override with command-line arguments if provided
ISP = args.isp or os.getenv('ISP', '127.0.0.1')
BASE_URL = args.base_url or os.getenv('BASE_URL', 'https://monitoring.example.com/api/push/XXXXXX')
INTERVAL = args.interval

# Log if ISP or BASE_URL is not provided
if not ISP:
    logging.error("No ISP provided. Please provide an ISP to ping.")
if not BASE_URL:
    logging.error("No BASE_URL provided. Please provide a BASE_URL for the HTTP request.")

# Run the main function only if ISP and BASE_URL are provided
if ISP and BASE_URL:
    main(ISP, BASE_URL, INTERVAL)
else:
    logging.error("Script terminated due to missing ISP or BASE_URL.")
