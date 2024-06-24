# uptime-kuma-agent

## Project Setup and Usage

This document provides instructions for setting up and using the Python project. The project involves pinging an ISP and sending the results to a specified base URL.

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

For other testing.

```bash
--isp "100.0.0.1" --base_url "https://monitoring.carlbomsdata.se/api/push/kNSkNgEjV4"
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
pyinstaller --onedir .\program.py --name uptime-kuma-agent_winx64 --distpath .\release\winx64\dist --workpath .\release\winx64\build --specpath .\release\winx64\
```

### Output

After building, the output directory will contain the executable:

```bash
.\release\winx64\dist\uptime-kuma-agent_winx64
```
