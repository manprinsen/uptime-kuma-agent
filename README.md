# uptime-kuma-agent on non-embedded system

## Project Setup and Usage

This document provides instructions for setting up and using the program.py script. The script involves pinging an ISP and sending the results to a specified base URL.

### Prerequisites

- Python 3.x
- pip (Python package installer)

### Setting Up the Virtual Environment

1. **Create a Virtual Environment**:

    ```bash
    python3 -m venv venv
    ```

2. **Activate the Virtual Environment**:

    On macOS and Linux:

    ```bash
    source venv/bin/activate
    ```

    On Windows:

    ```bash
    .\venv\Scripts\activate
    ```

### Get Source Script

Use git clone of this repository or copy program.py to your machine (non-embedded system).

### Installing Dependencies

Install the required Python packages:

```bash
pip install requests pingparsing pyinstaller
```

Or install from requirements.txt

```bash
pip install -r requirements.txt
```

### Testing the Script

To test the script, run the following command:

```bash
python3 program.py --isp "100.0.0.1" --base_url "https://monitoring.carlbomsdata.se/api/push/kNSkNgEjV4"
```

This example will ping the ISP server at `8.8.8.8` and send the results to the specified URL every 60 seconds.

```bash
python3 program.py --isp "8.8.8.8" --base_url "https://monitoring.carlbomsdata.se/api/push/kNSkNgEjV4" --interval 60
```

### Building the Executable

To build the project into a standalone executable, use PyInstaller:

```bash
pyinstaller --onedir program.py
```

To build for Windows please run:

```bash
pyinstaller --onedir .\program.py --name uptime-kuma-agent_win_x64 --distpath .\release\win_x64\dist --workpath .\release\win_x64\build --specpath .\release\win_x64\
```

To build for Ubuntu please run:

```bash
pyinstaller --onedir program.py --name uptime-kuma-agent_linux_x64 --distpath release/linux_x64/dist --workpath release/linux_x64/build --specpath release/linux_x64
```

To build for Raspberry Pi please run:

```bash
pyinstaller --onedir program.py --name uptime-kuma-agent_linux_aarch64 --distpath release/linux_aarch64/dist --workpath release/linux_aarch64/build --specpath release/linux_aarch64
```

### Deployment

Schedule executable using Windows Task Manager:

....

Schedule executable using crontab:

Use crontab to schedule the executable:

```bash
crontab -e
```

Enter the following line to run the script every minute:

```bash
* * * * * /root/program --isp "1.1.1.1" --base_url "https://monitoring.carlbomsdata.se/api/push/fUb1rTKnVW"
```

Schedule executable using Task Scheduler on Synology NAS:

...


# uptime-kuma-agent on embedded system

## Project Setup and Usage

This document provides instructions for setting up and using the program.sh. The script involves pinging an ISP and sending the results to a specified base URL.

### Prerequisites

- SSH with root access

### Get Source Script

Use git clone of this repository or copy program.sh to your machine (embedded system).

### Script Privileges

Run the following command to make the script executable privileges:

```bash
chmod +x program.sh
```

### Testing the Script

To test the script, run the following command:

```bash
./program.sh --isp "100.0.0.1" --base_url "https://monitoring.carlbomsdata.se/api/push/kNSkNgEjV4"
```

### Deployment

Use crontab to schedule the executable:

```bash
crontab -e
```

Enter the following line to run the script every minute:

```bash
* * * * * /root/uptime-kuma-agent/program.sh --isp "1.1.1.1" --base_url "https://monitoring.carlbomsdata.se/api/push/fUb1rTKnVW" >> /root/uptime-kuma-agent/debug.log 2>&1
```
