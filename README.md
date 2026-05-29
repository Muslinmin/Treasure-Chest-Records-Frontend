# Treasure Chest Records — Frontend

Flutter frontend for a private, single-user personal finance tracker. Consumes a FastAPI backend over a Tailscale network connection.

## What it does

- **Dashboard** — monthly spending trend (12 months) and category breakdown for the current month. Sync button triggers the backend ingestion pipeline and auto-refetches on success.
- **Transactions** — two-axis scrollable table of the full ledger with infinite scroll. Columns: date, amount, vendor, category, settled status, source file.
- **Key Setup** — one-time API key entry screen. The key is stored in the OS secure vault (Android Keystore) and never shown again unless a `401` is received.

## Architecture

Five layers. Dependencies point inward toward the domain — the domain layer has no external dependencies.

```
UI → State (Riverpod) → Repository → API Client → FastAPI backend
                  ↑ all layers use ↑
              Domain (entities + money formatter)
```

- **Domain** — pure Dart entities (`Transaction`, `Summary`) and `formatCents()`, the only place cents are converted to a display string.
- **API** — Dio client with a Bearer auth interceptor; four endpoints; freezed + json_serializable DTOs.
- **Repository** — network-only pass-through for now; interface is stable if a cache is added later.
- **State** — Riverpod `AsyncNotifier` providers for transactions, summary, and auth status.
- **UI** — `ConsumerWidget` / `ConsumerStatefulWidget`; `.when()` for loading/data/error; no arithmetic on money.

## Tech stack

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.6.1 | State management |
| `dio` | ^5.7.0 | HTTP client |
| `flutter_secure_storage` | ^9.2.2 | API key storage (Keystore/Keychain) |
| `intl` | ^0.19.0 | Currency and date formatting |
| `freezed_annotation` + `json_annotation` | latest | Immutable models + JSON |

## Running locally

1. Create `config.json` in the project root (gitignored):
   ```json
   { "BASE_URL": "http://<your-backend-ip>:<port>" }
   ```

2. Run with the dart-define flag:
   ```bash
   flutter run --dart-define-from-file=config.json
   ```
   Or use **F5** in VS Code — `launch.json` passes the flag automatically.

3. On first launch, enter your `FAST_API_KEY` on the Key Setup screen. It is stored securely and never needs to be re-entered unless the server rejects it.

## Project status

- Phases 0–5 complete: domain, API, repository, state, and UI layers fully implemented.
- Open: charts on Dashboard, filter UI on Transactions, refetch on app focus, light/dark theming.
