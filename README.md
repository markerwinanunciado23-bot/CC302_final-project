# Blue Way

Blue Way is a Flutter bus information and ticketing app backed by a local REST
API with SQLite persistence. Bus routes and bookings are stored by the API;
the bus fleet screen supports create, read, update, and delete, and My Tickets
supports booking, viewing, editing, and deleting tickets.

## Project structure

The Flutter app is organized by responsibility under `lib/`:

```text
lib/
  models/
    blue_way_bus.dart
    booking.dart
  pages/
    booking_page.dart
    detail_page.dart
    fleet_page.dart
    home_page.dart
    main_screen.dart
    profile_page.dart
    schedule_page.dart
    tickets_page.dart
  routes/
    app_routes.dart
  services/
    blue_way_api.dart
  main.dart
```

`lib/main.dart` is the app entry point and connects these files into one Dart
library, keeping shared UI helpers and models compatible while separating the
code into readable files.

## Run the API

Install Node.js 22.13 or later and Flutter. The easiest option on Windows is
to run `run.bat` from the project folder (or `.\run.bat` in PowerShell). It
starts the API in a separate terminal, waits for its health check, fetches
Flutter packages, and runs the app. Any arguments are passed to Flutter, e.g.
`.\run.bat -d chrome`.

In VS Code, open the project folder, choose **Blue Way (Chrome)** or
**Blue Way (Android emulator)** in Run and Debug, then press **F5**. Those
launch configurations start the API automatically before launching Flutter.

To start the API manually, install Node.js 22.13 or later and run this in a
terminal:

```powershell
cd api;
npm start
```

The API listens on port 3000 and creates `api/blueway.sqlite` on first start,
seeding it with the sample Blue Way fleet. The database file is ignored by Git.
Keep the API terminal open while using the app. To change the port, set the
`PORT` environment variable before starting Node.

## Run the Flutter app

In a second terminal at the project root (only needed if you started the API
manually):

```powershell
flutter pub get
flutter run
```

The default API URL is `http://10.0.2.2:3000/api` for the Android emulator and
`http://localhost:3000/api` for web, Windows, macOS, and Linux. For a physical
device or a different API host, set the URL explicitly:

```powershell
flutter run --dart-define=BLUE_WAY_API_URL=http://YOUR_COMPUTER_LAN_IP:3000/api
```

The API currently allows unauthenticated cross-origin requests and binds to all
interfaces for local device testing. It is a development API and must not be
exposed to the public internet without adding authentication and production
security controls.

## REST endpoints

All endpoints are prefixed with `/api`.

| Method | Endpoint | Description |
| --- | --- | --- |
| GET | `/health` | Check API status |
| GET, POST | `/buses` | List buses or create one |
| GET, PATCH, DELETE | `/buses/:id` | Read, update, or delete one bus |
| GET, POST | `/bookings` | List bookings or create one |
| GET, PATCH, DELETE | `/bookings/:id` | Read, update, or delete one booking |

Booking creation accepts `busId`, `passenger`, `phone`, `date`, and `seat`.
Deleting a bus that still has bookings is rejected; delete its bookings first.
Duplicate bus numbers and duplicate seats on the same bus and date are rejected.

Run API tests from the API directory with `npm test`.
