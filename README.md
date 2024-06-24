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

### Testing the Script

To test the script, run the following command:

```bash
python3 program.py --isp "100.0.0.1" --base_url "https://monitoring.carlbomsdata.se/api/push/kNSkNgEjV4"
```

Replace `"100.0.0.1"` with the IP address of the ISP you want to ping, and update the base URL as needed.

### Building the Executable

To build the project into a standalone executable, use PyInstaller:

```bash
pyinstaller --onedir program.py
```

### Output

After building, the output directory will contain the executable:

```bash
dist/program
```

## Additional Information

- **Using `pip freeze`**:

    To capture the exact versions of the installed packages, you can use `pip freeze` and create a `requirements.txt` file:

    ```bash
    pip freeze > requirements.txt
    ```

    To install the packages from this file in another environment:

    ```bash
    pip install -r requirements.txt
    ```

- **Script Description**:

    The script `program.py` pings the specified ISP server and sends the results to the specified base URL. The results are logged, and if an interval is provided, the script will rerun at the specified intervals.

### Example Usage

```bash
python3 program.py --isp "8.8.8.8" --base_url "https://monitoring.carlbomsdata.se/api/push/kNSkNgEjV4" --interval 60
```

This example will ping the ISP server at `8.8.8.8` and send the results to the specified URL every 60 seconds.

## License

Include any licensing information here.

## Contributing

Include guidelines for contributing to the project.

## Authors and Acknowledgments

Include information about the authors and any acknowledgments here.
