# Developer Guide — Personal Finance Frontend (Flutter)

## Role Assignment
- **Senior Developer** = the agent reading this file. You review, explain, unblock, and guide architecture decisions for the **Flutter front-end**. You do not own the backend — it already exists and is documented separately.
- **Junior Developer & Product Owner** = the human interacting with you. They write the code, make product decisions, and consult you on design and snippets.

---

**This document is your (the agent's) source of truth for how to guide the junior developer through building the front-end. Every instruction, reading list, and checkpoint below is directed at them — delivered through you. It is the front-end counterpart to the backend guide; keep the two consistent.**

---

## How We Work Together

You write the code. I review, explain, and unblock you. Before you write any module, you read the sources I link here, then come back and we write it together — line by line if needed. You should be able to explain every line you commit. If you can't, ask me before pushing.

As product owner, you also make the final call on open decisions (like whether to add an offline cache in v1). I will give you my recommendation, but it's your product.

### Code Review Rules (for the Senior Developer)

- **Never write the full implementation.** Provide the class/function signature and a commented skeleton only. The junior developer writes the body.
- **Always give a comment skeleton before any coding task.** Every new file, class, or function starts with comments describing what each block needs to do — not how to do it. The junior developer figures out the how.
- **One concept at a time.** Explain the *why* before assigning the *what*. If a new concept is required (e.g. an interceptor, a value object, `AsyncNotifier`), explain it in plain English first, then give the skeleton.
- **Checkpoint questions before moving phases.** Never advance to the next layer until the junior developer can answer why the current layer works the way it does.
- **Tie every choice back to the backend contract.** The front-end exists to consume four endpoints. When in doubt, re-read the API contract section below rather than inventing behaviour.

---

## Context — What the Backend Gives Us

The backend is a private, single-user FastAPI service. The front-end is its only consumer. Re-read this until you can narrate it without looking.

### Auth — one static shared key
There is **no login, no username/password, no token refresh, no expiry.** Authentication is a single secret (`FAST_API_KEY`) sent on every request as `Authorization: Bearer <key>`. The server compares it with a constant-time check. For the client this means:
- The key is entered by the user once, into a setup screen. It is **never hard-coded** into the app (it can be extracted from an installed binary).
- It is stored in the OS secure vault (Keychain / Keystore), not plain preferences.
- A `401`/`403` can only mean *the key is missing or wrong* — there is nothing to refresh. The response is "send the user back to the setup screen."

### Money — integer cents (project decision)
**Decision made by the product owner:** the API will expose money as integer cents only. The backend's previous computed dollar field (`amount` on both response models) is being removed so the wire format is lossless. JSON has no decimal type, so a float over the wire would re-introduce floating-point error on the client. The rule for the whole front-end is therefore one-directional:

> **Cents everywhere. Convert to a display string (e.g. `$12.50`) only at the moment of display, in exactly one helper.**

> **Backend coordination note (resolved 2026-05-21):** the computed `amount` field has been removed from both `TransactionResponse` and `SummaryResponse` on the backend. Client models must not include it — `amount_cents` / `total_cents` are the only money fields on the wire.

### The API contract (four endpoints)

| Method & path | Auth | Inputs | Returns |
|---|---|---|---|
| `POST /ingest` | Bearer | none from client (inbox path is server-side config) | per-file ingest report (JSON) |
| `GET /transactions` | Bearer | `date_from`, `date_to`, `category` (all optional), `retrieve_limit` (default 50), `offset` (default 0) | array of transaction objects |
| `GET /summary` | Bearer | `period` (e.g. `"2026-05"`, optional — defaults to current month) | array of summary objects |
| `GET /summary/monthly` | Bearer | none | array of summary objects (last 12 months) |

**Transaction object fields:** `id` (int), `transaction_date` (date), `amount_cents` (int), `description` (nullable), `transaction_code` (nullable), `vendor_name` (nullable), `category` (nullable — `null` means not yet categorised), `is_settled` (bool), `is_category_manual` (bool), `source_file` (nullable).

**Summary object fields:** `period` (string `"YYYY-MM"`), `category` (string), `total_cents` (int), `tx_count` (int), `updated_at` (datetime).

The backend is **pull-only** (no websockets/SSE). The client refetches on load and on focus.

---

## The Architecture

Five layers. The single rule that holds them together: **dependencies point inward, toward the domain.** UI → State → Repository → API → (network). The domain layer depends on nothing, and everything that touches money or business meaning depends on it.

```
┌─────────────────────────────┐
│  UI layer                   │  widgets; renders; never does math
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐        ┌───────────────────────────┐
│  State (Riverpod)           │        │  Domain layer             │
│  async data + loading/error │  ◄───  │  pure Dart, no deps       │
└──────────────┬──────────────┘  used  │  entities + Money         │
               ▼                  by    │  formatter (cents→dollars)│
┌─────────────────────────────┐  all   └───────────────────────────┘
│  Repository                 │  layers
│  cache (later) + network    │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  API client (dio)           │  models + auth interceptor (bearer key)
└──────────────┬──────────────┘
               ▼  network
        FastAPI backend (external — speaks cents)
```

**The two cross-cutting decisions live in exactly two places:** the Bearer key is attached in the **API client**, and cents become dollars in the **domain layer**. Nowhere else.

---

## Build Order & Objectives

Build bottom-up, the same way the backend started with the database: the layer that everything depends on comes first. Each phase below states its **objective**, what it **receives**, and what it **outputs**. Where concrete tasks can be foreseen, they are listed; where they depend on product decisions not yet made, only the objective and the receive/output contract are given — fill in the detail with the junior developer when you reach that phase.

### Phase 0 — Project Setup & Tooling

**Objective:** a running, empty Flutter app with the dependency stack installed and a folder structure that mirrors the architecture.

**Read first**
| Topic | URL | Focus |
|---|---|---|
| Install Flutter | https://docs.flutter.dev/get-started/install | SDK, device/emulator setup |
| Dart language | https://dart.dev/language | null safety, `sealed`/`class`, async/await |
| Effective Dart | https://dart.dev/effective-dart | naming, file layout conventions |

**Foreseeable TODO**
- `flutter create` the project; confirm it runs on both an iOS simulator and an Android emulator.
- Add packages (pin versions, verify each on pub.dev first): `dio`, `flutter_riverpod`, `flutter_secure_storage`, `intl` (currency formatting), and `freezed` + `json_serializable` (immutable models / JSON). Defer `drift` until Phase 3 is reached and a cache is actually wanted.
- Create the folder skeleton — one folder per layer — and commit the empty structure with a `.gitkeep` in each:

```bash
mkdir -p lib/{domain,data/api,data/repositories,state,ui}
```

- `.gitignore` excludes build artefacts and any local secrets.

**Checkpoint:** the app launches on both platforms and the folder structure is committed.

---

### Phase 1 — Domain Layer

**Why first?** It is the core that everything else depends on, and it depends on nothing — so it can be written and unit-tested with no UI, no network, and no database in place. This is the front-end equivalent of defining the database schema first.

**Receives:** nothing external. Pure Dart only — no `dio`, no Flutter, no Riverpod imports allowed in this folder.

**Outputs:**
- Plain entity types the rest of the app speaks in: a `Transaction` entity and a `Summary` entity, holding `amountCents`/`totalCents` as integers.
- A `Money` value type (or a single formatter function) that takes integer cents and returns a display string. This is the *only* place `÷100` and currency formatting may happen.
- Any category logic that isn't tied to UI or storage.

**Read first**
| Topic | URL | Focus |
|---|---|---|
| `intl` NumberFormat | https://pub.dev/packages/intl | `NumberFormat.currency`, locale handling |
| freezed | https://pub.dev/packages/freezed | immutable value classes, `copyWith` |

**Checkpoint questions:** Why does this layer import nothing from Flutter or dio? Why must cents stay integers right up to the formatter? What does the formatter return for `1250`?

---

### Phase 2 — API Layer

**Objective:** the only layer that knows the backend exists. It holds the HTTP client, the request/response models that mirror the four endpoints, and the auth interceptor.

**Receives:** request parameters from the repository (filters, pagination, period) and the secret key from secure storage.

**Outputs:** typed model objects parsed from JSON, mapped into domain entities; and a clear, typed failure on auth errors so the layer above can route the user to re-enter the key.

**Read first**
| Topic | URL | Focus |
|---|---|---|
| dio | https://pub.dev/packages/dio | `BaseOptions`, `Interceptors`, error handling |
| flutter_secure_storage | https://pub.dev/packages/flutter_secure_storage | read/write a single key on Keychain/Keystore |
| json_serializable | https://pub.dev/packages/json_serializable | generating `fromJson` for the response models |

**Foreseeable TODO**
- A configured `dio` instance with the backend base URL.
- An **interceptor** that reads the key from secure storage and attaches `Authorization: Bearer <key>` to every outgoing request, and that converts a `401`/`403` into a typed `UnauthorizedException` (no retry — there is nothing to refresh).
- Response models for the transaction and summary objects (cents only), plus mapping functions into the Phase 1 domain entities.
- One method per endpoint, matching the contract table above (mind the default `retrieve_limit=50`, `offset=0`).

**Checkpoint questions:** What is an interceptor and why attach the key there rather than in every call? Why is a `401` here *not* something to retry? Where does the raw JSON stop and the domain entity begin?

---

### Phase 3 — Repository Layer

**Objective:** answer the question "where does this data come from?" so that no layer above ever knows or cares whether a value came from the network or a local cache.

**Receives:** intent from the state layer — which transactions (filters + page), which summary period.

**Outputs:** domain entities (lists of `Transaction`, `Summary`) ready to display. It coordinates pagination (`offset`/`limit`) and, if/when added, the cache.

**Open decision (product owner):** local cache in v1, or network-only? Recommendation — ship network-only first (a straight pass-through to the API layer), and add a Drift/SQLite cache later only when offline reads or instant-launch actually matter. The repository interface should not change when the cache is added; only its internals do. (Read https://drift.simonbinder.eu/ when/if you reach this.)

**Checkpoint questions:** If you later add a cache, which layers should need to change? (Answer: only this one.) How does the repository represent "page 3 of transactions"?

---

### Phase 4 — State Management Layer (Riverpod)

**Objective:** hold "what is the app showing right now, and is it loading or errored?" and expose it to the UI in a form widgets can render directly.

**Receives:** user intent from the UI (refresh, change filter, next page, re-enter key) and data from the repository.

**Outputs:** observable async state (`AsyncValue` / `AsyncNotifier`) carrying loading, data, and error cases — so the UI never manages raw futures itself.

**Read first**
| Topic | URL | Focus |
|---|---|---|
| Riverpod intro | https://riverpod.dev/docs/introduction/why_riverpod | providers, `ref.watch` |
| Async providers | https://riverpod.dev/docs/essentials/first_request | `AsyncNotifier`, loading/error states |

**Foreseeable TODO**
- Providers exposing the transactions list (with filter + pagination state) and the summary/monthly data.
- An auth-status provider that flips to "needs key" when the API layer throws `UnauthorizedException`, so the UI can show the setup screen.

**Checkpoint questions:** Why let Riverpod own loading/error instead of the widget? What happens, end to end, when the key is wrong — which layer detects it and which layer reacts?

---

### Phase 5 — UI Layer

**Objective:** render state and capture user actions. Widgets only. No `dio`, no SQLite, and **no `÷100`** — money is formatted by asking the domain helper.

**Receives:** providers from the state layer.

**Outputs:** rendered screens, and user actions sent back up to the providers.

**The screens (decided by the product owner — there are exactly three).** This is no longer open. The app has three pages and no others; resist the urge to add a fourth (e.g. a transaction-detail screen) — the table below intentionally absorbs that role.

1. **Key setup** — the first page on a fresh install. The user pastes the API key once; it is written to secure storage. After that it is **never seen again** in normal use — the *only* way back to it is a `401`/`403`, which the auth-status provider (Phase 4) detects and routes here. Treat it as a one-time gate, not a tab.

2. **Dashboard** — the home screen, and the screen the app opens to once a key exists. It answers the product owner's two confirmed needs, both driven by the summary endpoints:
   - **Spending over time** — the 12-month trend from `/summary/monthly`; total by default, narrowable to a single category.
   - **Category comparison for a month** — every category's total for one selected whole month, from `/summary` (period is **whole months only** — see Phase 6).
   - **Sync button, top-right.** A single control that calls `POST /ingest`. It must show three visible states — idle, working (spinner, disabled to block double-taps), done — because ingest is a server-side batch and not instant. The per-file report is surfaced as a transient toast/snackbar (e.g. "Synced — 42 new"), with the full breakdown available on tap (dialog or bottom sheet). **After a successful sync the Dashboard must refetch itself** so the numbers reflect the new data immediately; this is the same refetch path as on-focus, just triggered explicitly. A `401` here routes to Key setup like any other call — no special casing.

3. **Transactions** — a single **scrollable table** (a spreadsheet-style grid) showing the raw ledger. The user scrolls **both axes** — vertically through rows, horizontally through columns — so every field is reachable without a separate detail screen. Columns are the domain-formatted amount plus vendor, date, category (with a visible "uncategorised" state for `null` — never a blank), and the remaining fields the old detail screen would have shown. Data is paged from `/transactions` (mind `retrieve_limit`/`offset`); load the next page as the user nears the bottom.

**Checkpoint questions:** Show me where a widget formats money — does it call the domain helper or do the division itself? On launch with no stored key, what does the user see? When the user taps Sync, what are the three button states, and what happens to the Dashboard's numbers once it succeeds?

---

### Phase 6 — Decisions Log

**Resolved (treat as settled):**
- **Page count — three, full stop.** Key setup, Dashboard, Transactions. *Why:* single-user app; the table absorbs the detail view, and Sync is an action not a destination. Do not add screens without a product-owner decision recorded here.
- **Summary period — whole calendar months only.** *Why:* the `/summary` and `/summary/monthly` buckets are monthly; constraining "period" to whole months means both Dashboard needs are served by the existing endpoints with zero backend change. Arbitrary date-range breakdowns are explicitly out of scope for v1.
- **Sync is a Dashboard action (top-right button), not a screen.** Ingest report shown as a toast with full detail on tap; the Dashboard auto-refetches after a successful sync. *Why:* the action belongs on the screen whose data it refreshes.
- **Transactions is a two-axis scrollable table, not a list + detail.** *Why:* horizontal scroll exposes every field, removing the need for a fourth screen.

**Still open:**
- **Offline cache** — deferred from Phase 3; add only when felt.
- **Refetch policy** — on load and on focus is the backend's stated model; confirm it feels right.
- **Theming / light-dark** — a UI decision, not an architecture one.
- **Budget profile (future)** — comparison logic would live in the domain layer next to `Money`; the open sub-decision is whether budget targets are device-local or server-backed (the latter means new backend endpoints). Not in v1.

**Newly resolved:**
- **Charting library — `fl_chart` (2026-06-03).** *Why:* MIT license, community standard for Flutter charts. Used for the pie chart (Category Breakdown) and multi-series line chart (Monthly Trend). No commercial license concerns for a personal app.
- **Monthly Trend chart — multi-series line chart, not single-category bar (2026-06-03).** Supports up to 3 simultaneous series. "Everything else" series = overall total minus all explicitly named category series. "Everything else" is suppressed when only one category exists in the data. *Why:* gives the user comparative trend visibility without needing a separate screen.
- **Category Breakdown chart — interactive donut pie chart, not bar chart (2026-06-03).** Touch-to-expand slice with centre label. *Why:* proportional breakdown is clearer as a pie than as bars; donut centre provides a tap-to-inspect label without cluttering the chart.

Record each new decision here with a one-line rationale, the way the backend guide does.

---

## Our Working Agreement

1. **You write first, I review.** Write your best attempt, share it, and I'll tell you what to fix and why. You learn more from fixing than from copying.
2. **One layer at a time, in dependency order.** Don't build the UI before the domain and API layers exist. The phases above are ordered for a reason.
3. **Test manually at each checkpoint.** Phase 1: unit-test the formatter. Phase 2: make one real authenticated call and print the result. Phase 4: watch a provider move through loading → data. Phase 5: tap through the screen.
4. **Ask about the "why", not just the "how".** If you don't understand why a layer is shaped a certain way, stop and ask. You're also the product owner — you need to trust the architecture, not just execute it.
5. **Commit at each checkpoint.** Small, working commits.

---

## Quick Reference — Key Concepts to Know Cold

| Concept | One-line definition |
|---|---|
| Interceptor | A hook that runs before every request/after every response; where the bearer key is attached and `401`s are caught |
| Secure storage | OS-level encrypted store (Keychain/Keystore) for the one secret key — never plain preferences |
| Value object | A small immutable type (like `Money`) that wraps a primitive to keep logic in one place |
| Entity vs DTO | DTO/model = shape of the JSON on the wire; entity = the clean domain type the app actually uses |
| Repository pattern | A layer that hides *where* data comes from (network vs cache) behind a stable interface |
| Provider (Riverpod) | A unit of app state the UI can watch; rebuilds widgets when it changes |
| `AsyncValue` | Riverpod's loading / data / error wrapper, so the UI doesn't juggle raw futures |
| Dependency direction | Arrows point inward to the domain; the domain depends on nothing |

---

## Current Status

- Backend ✅ — exists, documented separately, four endpoints live. Computed `amount` field dropped; wire format is cents-only (`amount_cents` / `total_cents`).
- Front-end Phase 0 ✅ — complete (2026-05-26).
  - Flutter 3.44.0 on Ubuntu 26.04, Android emulator target.
  - Packages installed: `dio ^5.7.0`, `flutter_riverpod ^2.6.1`, `flutter_secure_storage ^9.2.2`, `intl ^0.19.0`, `freezed_annotation ^2.4.4`, `json_annotation ^4.9.0`, `fl_chart` (charting); dev: `build_runner`, `freezed`, `json_serializable`.
  - Layered folder structure committed: `lib/{domain,data/api,data/repositories,state,ui}`.
  - `.gitignore` covers build artifacts and secrets (`.env`, `secrets.dart`, etc.).
  - App confirmed running on Android device.
- Front-end Phase 1 ✅ — complete (2026-05-26).
  - `lib/domain/entities/transaction.dart` — freezed entity, all 10 API fields, `amountCents` as int.
  - `lib/domain/entities/summary.dart` — freezed entity, all 5 API fields, `totalCents` as int.
  - `lib/domain/money.dart` — `formatCents(int cents)` using `NumberFormat.currency(locale: 'en_SG', symbol: 'SGD ')`. Only place `÷100` happens. `centsToChartValue(int cents)` returns a `double` for chart Y-axis rendering — the only place chart-numeric division happens.
  - Unit tests passing: `formatCents(1250)` → `'SGD 12.50'`, `formatCents(0)` → `'SGD 0.00'`, `formatCents(99)` → `'SGD 0.99'`.
  - `main.dart` replaced with minimal placeholder (removed Dart 3.12 dot-shorthand syntax that blocked build_runner).
- Front-end Phase 2 ✅ — complete (2026-05-26).
  - `lib/data/api/exceptions.dart` — `UnauthorizedException` with default message and `toString`.
  - `lib/data/api/auth_interceptor.dart` — attaches `Authorization: Bearer <key>` on every request; converts `401`/`403` to `UnauthorizedException`; no retry logic.
  - `lib/data/api/api_client.dart` — dio configured with `baseUrl` from `--dart-define-from-file=config.json`, 10s connect / 30s receive timeouts; four endpoint methods (`ingest`, `getTransactions`, `getSummary`, `getSummaryMonthly`).
  - `lib/data/api/models/transaction_response.dart` and `summary_response.dart` — freezed + json_serializable DTOs with `fieldRename: FieldRename.snake` (annotation on factory constructor, not class — required for freezed 2.x to apply rename to impl's fromJson), `createToJson: false`, and `toDomain()` mapping to domain entities.
  - `config.json` (gitignored) holds `BASE_URL` (Tailscale IP `100.82.222.12:8000`). `.vscode/launch.json` passes `--dart-define-from-file=config.json` automatically.
  - build_runner generates clean output (version warning only — harmless, from build tools predating Dart 3.12).
  - **Known false-positive IDE warning:** `@JsonSerializable` on factory constructors triggers "can only be used on classes" from the Dart analyser — ignore it; freezed reads it there intentionally and the generated output is correct.
- Front-end Phase 3 ✅ — complete (2026-05-26).
  - `lib/data/repositories/transaction_repository.dart` — injects `ApiClient`, wraps `getTransactions`, maps DTOs via `toDomain()`, default `limit=50`/`offset=0` as Dart parameter defaults.
  - `lib/data/repositories/summary_repository.dart` — injects `ApiClient`, two methods: `getSummary({String? period})` and `getSummaryMonthly()`, both map via `toDomain()`. No DTOs cross this boundary outward.
- Front-end Phase 4 ✅ — complete (2026-05-29).
  - `lib/state/auth_status.dart` — `AuthStatus` enum (`authorized`/`unauthorized`), `authStatusProvider` (`StateProvider`, defaults to `authorized`), `handleUnauthorizedException(Ref ref)` helper that flips the provider to `unauthorized`.
  - `lib/state/providers.dart` — infrastructure providers: `secureStorageProvider`, `apiClientProvider`, `transactionRepoProvider`, `summaryRepoProvider`.
  - `lib/state/summary_notifier.dart` — `SummaryNotifier` (`AsyncNotifier<List<Summary>>`): holds `_period`, `build()` fetches via `summaryRepoProvider`, `setPeriod(String?)` updates `_period`, sets `AsyncLoading`, then re-fetches. `SummaryMonthlyNotifier` (`AsyncNotifier<List<Summary>>`): `build()` fetches `getSummaryMonthly()`. Both notifiers wrap every API call in try/catch `on UnauthorizedException` → `handleUnauthorizedException(ref)` + `rethrow`. **Note:** `ref.listenSelf` (deprecated) was replaced with direct try/catch at each call site.
  - `lib/state/transactions_notifier.dart` — `TransactionsNotifier` (`AsyncNotifier<List<Transaction>>`): pagination via `_offset`/`_hasMore`/`_limit=50`, filter fields `_dateFrom`/`_dateTo`/`_category`. Three methods: `build()` (initial load, resets all state), `setFilters()` (resets pagination, sets `AsyncLoading`, re-fetches), `fetchNextPage()` (appends next page to existing list, guards with `_hasMore`). All three wrap repo calls in try/catch `on UnauthorizedException` → `handleUnauthorizedException(ref)` + `rethrow` inside the `AsyncValue.guard` closure.
- Front-end Phase 5 ✅ — complete (2026-05-29).
  - `lib/ui/key_setup_screen.dart` — `ConsumerStatefulWidget`; `TextEditingController` for key input; writes to `secureStorageProvider` with key `'api_key'`; flips `authStatusProvider` to `authorized` on save.
  - `lib/ui/dashboard_screen.dart` — Upgraded to `ConsumerStatefulWidget`; `_selectedPeriod` local state drives the category breakdown month picker; watches `summaryMonthlyProvider` and `summaryProvider`; both rendered via `.when()` with chart widgets (no `÷100` in widgets). Period dropdown extracts unique periods from `summaryMonthlyProvider` data, sorted chronologically, shown only once loaded. `SyncButton` extracted as `ConsumerStatefulWidget`; `_isSyncing` bool drives three states (idle icon / spinner / reverts to idle); `ref.invalidate()` on both summary providers after successful sync; `UnauthorizedException` inlined as `ref.read(authStatusProvider.notifier).state = AuthStatus.unauthorized` (cannot use `handleUnauthorizedException` helper — `WidgetRef` ≠ `Ref`).
  - `lib/ui/charts/monthly_trend_chart.dart` — rewritten (2026-06-03) as an interactive multi-series line chart (`StatefulWidget`). Supports up to 3 simultaneous series selected from: `__all__` (overall total), any named category, and `__everything_else__` (all total minus named categories). Sentinel string constants (`_kAll`, `_kEverythingElse`) prevent magic string drift. Stable colour assignment via `Map<String, Color> _seriesColours` — assigns on add, removes on delete, prevents palette index drift when a middle series is removed. `_seriesData()` has a recursion guard (`continue` on `_kAll`/`_kEverythingElse`) for the Everything else path. `InputChip` legend with per-chip delete; `DropdownButton` series picker hidden when 3 series active. Y-axis labels handle negative values correctly (`-$500` not `$-500`). "Everything else" option suppressed in the picker when the data has only one category (would be a $0 flat line). All money conversion via `centsToChartValue()`/`formatCents()` — no raw `/100` in chart code.
  - `lib/ui/charts/category_breakdown_chart.dart` — rewritten (2026-06-03) as an interactive donut pie chart (`StatefulWidget`). 8-colour static palette cycles via `index % palette.length`. `_touchedIndex` state expands the touched slice (radius 80→90). Centre of donut shows category name + `formatCents()` amount while a slice is held. `_buildLegend()` lists every category with its percentage (`totalCents / total * 100`). Guards for empty list and total == 0. All money via `centsToChartValue()` for slice values, `formatCents()` for centre label.
  - `lib/ui/transactions_screen.dart` — `ConsumerStatefulWidget`; `ScrollController` listener fires `fetchNextPage()` when within 200px of bottom; nested `SingleChildScrollView` (horizontal outer, vertical inner with controller); `DataTable` with columns: Date (`DateFormat('yyyy-MM-dd')`), Amount (`formatCents`), Vendor (`?? 'Unknown'`), Category (`?? 'Uncategorised'`), Settled (icon), Source (`?? 'Direct Entry'`).
  - `lib/ui/authenticated_shell.dart` — `ConsumerStatefulWidget`; holds `_selectedIndex` int; `IndexedStack` keeps both screens mounted (preserves scroll state on tab switch); `BottomNavigationBar` with Dashboard and Transactions tabs.
  - `lib/main.dart` — `ConsumerStatefulWidget`; `initState` calls `_checkStoredKey()` (reads `'api_key'` from secure storage); `authStatusProvider` defaults to `AuthStatus.unknown`; `switch` routes: unknown → spinner, authorized → `AuthenticatedShell`, unauthorized → `KeySetupScreen`.
  - `lib/state/auth_status.dart` — `AuthStatus` enum updated to include `unknown` (default), `authorized`, `unauthorized`.
  - `lib/data/api/api_client.dart` — `ingest()` return type corrected to `List<dynamic>` (backend returns an array of per-file reports, not a map).
  - **Known lesson:** `handleUnauthorizedException(Ref ref)` cannot be called from widgets because `WidgetRef` (flutter_riverpod) and `Ref` (riverpod) are distinct types. In widgets, inline `ref.read(authStatusProvider.notifier).state = AuthStatus.unauthorized` directly.

## Next Build Step

All five phases and both dashboard charts complete. The app is functional end-to-end. Remaining open decisions from Phase 6:

- **Offline cache** — deferred; add Drift/SQLite in the repository layer only when offline reads or instant-launch matter.
- **Refetch on focus** — not yet implemented; add `WidgetsBindingObserver` to `AuthenticatedShell` to refetch on `AppLifecycleState.resumed`.
- **Theming / light-dark** — UI decision, implement when desired.
- **Filter UI** — `TransactionsNotifier.setFilters()` exists but no UI exposes it yet; add filter controls to the Transactions AppBar when needed.
