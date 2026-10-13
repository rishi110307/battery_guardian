# Battery Guardian (Windows + Android)

Flutter frontend for Android and Windows, with an optional Node.js/Express + MongoDB backend for battery logs.

## Important platform limitation
This starter app detects battery level and charging state and displays a full-screen warning **inside the app** when battery is below 15%. It does not reliably prevent all other apps from being used:
- Android does not let an ordinary app lock the whole phone or draw over other apps without special permissions and platform-specific implementation. Android overlay permission alone is not a secure device lock.
- Windows can show a topmost/full-screen window, but an ordinary desktop app should not be treated as a tamper-proof kiosk/lock.
- The app cannot make the battery reach 100%; it can remind the user to connect the charger and continue charging.

Use this as a starter project and test on your own devices.

## Frontend
- Flutter app: `frontend/`
- Battery status: `battery_plus`
- HTTP logging: `http`
- Android + Windows targets

## Backend
- Node.js + Express API: `backend/`
- MongoDB logging is optional. Copy `.env.example` to `.env` and set `MONGO_URI`.
- API endpoints:
  - `GET /health`
  - `POST /api/battery`
  - `GET /api/battery/latest`
  - `GET /api/battery/history`

## Run frontend
Install Flutter and enable Android/Windows desktop targets.
```bash
cd frontend
flutter pub get
flutter run -d windows
# or connect an Android phone with USB debugging enabled:
flutter run -d <device-id>
```

## Run backend (optional)
```bash
cd backend
npm install
cp .env.example .env
npm start
```
Set `API_BASE_URL` in `frontend/lib/services/api_service.dart` to your reachable backend URL. For a physical phone, `localhost` refers to the phone, not your PC; use your PC's LAN IP or a deployed HTTPS URL.

## Build
```bash
cd frontend
flutter build apk --release
flutter build windows --release
```
