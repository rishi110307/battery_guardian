# Windows app

Run `python -m pip install -r requirements.txt`, then `python charge_guardian.py`.

- Battery polling is local and happens every 30 seconds.
- A full-screen warning is shown when unplugged battery is below the selected threshold.
- A desktop notification is attempted at 100%.
- This is a reminder utility, not a device lock or parental-control enforcement tool.
