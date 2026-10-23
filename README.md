# 100% Charge Guardian

A GitHub-ready starter project with:
- **Windows desktop app**: Python + Tkinter + psutil; monitors battery locally, warns below 15%, and notifies at 100%.
- **Android app source**: Kotlin Android project source; monitors battery changes and posts notifications for low battery and full charge.
- **Optional backend**: FastAPI service for health checks and battery-event logging.
- **Web dashboard**: a simple page to check the backend and view setup guidance.

## Important operating-system limitations

This project **cannot guarantee that a user is prevented from using a device** when the battery is below 15%.
- On Windows, the app can show a full-screen warning window, but users can usually dismiss it or switch desktops. It is not a secure kiosk/lock screen.
- Android does not allow an ordinary app to lock the whole device or block all other apps. The app uses notifications; a persistent full-screen overlay would need special permissions and still would not be a secure lock.
- Battery percentage and notification behavior depend on device hardware, OS version, battery drivers, power settings, and notification permissions.
- Windows XP/Vista/7 are legacy systems. Modern Python releases do not support all of them. Use the compatibility notes below rather than assuming one executable works on every Windows release.

## Windows compatibility

The Python source uses standard Tkinter plus `psutil`.
- **Windows 10/11**: recommended. Use a supported Python 3 release.
- **Windows 8.1/8**: may work with a Python release that still supports the OS; test on the target machine.
- **Windows 7**: use an older compatible Python/psutil combination and build/test on Windows 7 itself. Current dependencies may not support it.
- **Vista/XP**: best-effort only; current Python and dependency support is generally unavailable. A separate legacy build would need to be built and tested on that OS.
This repository contains source code, not a prebuilt signed installer for every Windows version.

## 1. Run the Windows app

Install Python and then, from the `windows-app` folder:

```bash
python -m pip install -r requirements.txt
python charge_guardian.py
```

If your Python command is `py`, use `py -m pip install -r requirements.txt` and `py charge_guardian.py`.

The app checks battery status every 30 seconds. Set the threshold in the app UI. To show a warning screen below the threshold, keep the app running. Closing the app stops monitoring.

### Build a Windows executable (Windows 10/11 recommended)

```bash
python -m pip install pyinstaller
pyinstaller --noconfirm --onefile --windowed --name ChargeGuardian charge_guardian.py
```

The executable will be in `windows-app/dist/ChargeGuardian.exe`. Build separately on each legacy Windows version you intend to support; do not assume a modern build runs on XP/Vista/7.

## 2. Android app

Open `android-app` in Android Studio. Let Gradle sync, then build with **Build > Build Bundle(s) / APK(s) > Build APK(s)**.

The project uses a minimal Android Gradle configuration. You may need a compatible Android Studio/JDK/Gradle version depending on your machine. The app requires notification permission on Android 13+ and asks for it at runtime. Keep battery optimization and background execution behavior in mind: Android vendors may delay background work. The receiver responds to battery-status broadcasts while the OS delivers them; it is not a guaranteed always-on service.

The app is not designed to block the phone below 15%. Android does not permit ordinary apps to prevent general device use.

## 3. Optional backend

From `backend`:

```bash
python -m pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

Check `http://127.0.0.1:8000/health` and API docs at `http://127.0.0.1:8000/docs`.

Battery event logging endpoint:
```bash
curl -X POST http://127.0.0.1:8000/api/events \
  -H "Content-Type: application/json" \
  -d '{"device":"windows-laptop","battery_percent":14,"charging":false,"event":"low_battery"}'
```

The apps work locally without the backend. The starter Windows and Android clients do not automatically upload events by default, so no personal data is sent anywhere unless you add that integration.

## 4. GitHub upload

1. Extract the ZIP.
2. Create a new empty repository on GitHub named `100-percent-charge-guardian`.
3. Open the extracted folder in VS Code.
4. In the terminal run:

```bash
git init
git add .
git commit -m "Initial Charge Guardian project"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/100-percent-charge-guardian.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username. Or use GitHub's **Add file > Upload files** for a small project. Do not upload build outputs, local virtual environments, or secrets.

## Project structure

```text
100-percent-charge-guardian/
├── windows-app/
│   ├── charge_guardian.py
│   ├── requirements.txt
│   └── README.md
├── android-app/
│   ├── settings.gradle
│   ├── build.gradle
│   └── app/
│       ├── build.gradle
│       └── src/main/
│           ├── AndroidManifest.xml
│           ├── java/com/example/chargeguardian/MainActivity.kt
│           └── res/values/styles.xml
├── backend/
│   ├── main.py
│   └── requirements.txt
├── web-dashboard/
│   └── index.html
├── .gitignore
└── README.md
```
