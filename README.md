# CalMD - Calendar to Markdown Export Tool

[中文](README_CN.md) | [English](README.md)

📅 **CalMD** (Calendar to Markdown) is a Shell script tool for exporting calendar events from macOS Calendar app, supporting custom date ranges and calendar filtering, outputting formatted Markdown text to clipboard.


## Features

- 📅 **Flexible Date Range**: Export events within specified date ranges
- 🚫 **Calendar Blacklist**: Exclude unwanted calendars (birthdays, holidays, etc.)
- 📝 **Markdown Format**: Beautiful Markdown output for easy documentation
- ⏰ **Time Sorting**: Automatically sort all events by time
- 📋 **Clipboard Integration**: Direct copy to clipboard for easy pasting
- 🔔 **Completion Notification**: System notification when task completes
- 📊 **Calendar Labels**: Display calendar name for each event with aligned formatting

## System Requirements

- macOS
- Calendar.app
- Bash Shell

## File Description

- `export_calendar.sh` - Main export script
- `calendar_data_output.applescript` - AppleScript version (optional)

## Usage

### Global Command (Recommended)

If you have installed CalMD via `install.sh`, you can use the `calmd` command directly:

```bash
# Export today's events
calmd

# Export 7 days starting from today
calmd 0 7

# Export yesterday's events
calmd -1 1

# Export 3 days starting from tomorrow, excluding specific calendars
calmd 1 3 "Test Calendar,Spam"
```

### Local Script Usage

If you choose local usage:

```bash
# Export today's events
./export_calendar.sh

# Export 7 days starting from today
./export_calendar.sh 0 7

# Export yesterday's events
./export_calendar.sh -1 1

# Export 3 days starting from tomorrow, excluding specific calendars
./export_calendar.sh 1 3 "Test Calendar,Spam"
```

### Parameters

1. **Relative Days** (optional): Days relative to today, default `0`
   - `0`: Today
   - `1`: Tomorrow
   - `-1`: Yesterday
   - `7`: One week later

2. **Day Range** (optional): Number of days to export, default `1`
   - `1`: 1 day
   - `7`: 7 days
   - `30`: 30 days

3. **Calendar Blacklist** (optional): Comma-separated calendar names to exclude

### Examples

```bash
# Export today's events
./export_calendar.sh

# Export tomorrow's events
./export_calendar.sh 1 1

# Export this week's events (7 days from today)
./export_calendar.sh 0 7

# Export next week's events (7 days from tomorrow)
./export_calendar.sh 1 7

# Export yesterday's events
./export_calendar.sh -1 1

# Export today's events, excluding specific calendars
./export_calendar.sh 0 1 "Work Calendar,Personal Privacy"

# Export next 3 days' events, no exclusions
./export_calendar.sh 0 3 ""
```

## Output Format

The script generates Markdown text in the following format:

```markdown
**Monday, January 15, 2024**:

-   **09:00 - 10:00** `[Work Calendar]`: Team Meeting
-   **14:00 - 15:30** `[Personal Calendar]`: Doctor Appointment
-   **19:00 - 20:00** `[Family Calendar]`: Dinner Party

**Tuesday, January 16, 2024**:

-   **10:00 - 11:00** `[Work Calendar]`: Project Review
```

## Installation

### Method 1: Global Installation (Recommended)

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd CalMD
   ```

2. Run the installation script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. After installation, you can use the `calmd` command anywhere:
   ```bash
   calmd                           # Export today's events
   calmd 0 7                       # Export 7 days from today
   calmd -1 1 'Test Calendar,Spam' # Export yesterday, exclude calendars
   ```

### Method 2: Local Usage

1. Download script files:
   ```bash
   git clone <repository-url>
   cd CalMD
   ```

2. Add execute permission:
   ```bash
   chmod +x export_calendar.sh
   ```

3. On first run, macOS may request permission to access Calendar app. Please click "Allow".

## Troubleshooting

### Common Issues

1. **Permission Issues**: If you encounter permission errors, ensure:
   - Script has execute permission (`chmod +x export_calendar.sh`)
   - Calendar app access is authorized

2. **Encoding Issues**: If you encounter character encoding problems, ensure:
   - File uses UTF-8 encoding
   - No BOM marker present

3. **AppleScript Errors**: If AppleScript execution fails:
   - Ensure Calendar app is installed and working properly
   - Check system AppleScript permission settings

### Debug Mode

For debugging, add `set -x` at the beginning of the script to see detailed execution:

```bash
#!/bin/bash
set -x  # Add this line for debugging
```

## Customization

### Modify Default Blacklist

Edit the default blacklist setting in the script:

```bash
CALENDAR_BLACKLIST=${3:-"Your Default Blacklist1,Your Default Blacklist2"}
```

### Modify Output Format

You can modify the `markdownLine` variable in the AppleScript section to customize output format.

## Contributing

Welcome to submit Issues and Pull Requests to improve this tool!

## License

MIT License

## Uninstall

If you installed CalMD via global installation, you can use the uninstall script to remove it:

```bash
./uninstall.sh
```

## Changelog

- **v1.2.0**: Added global installation feature, supports `calmd` command
- **v1.1.0**: Added command-line parameter support, customizable calendar blacklist
- **v1.0.0**: Initial version with basic calendar export functionality