# CBE Wallet App 📱

A production-grade Flutter mobile client for the [Wallet API](../WalletApi/README.md) backend. Developed as part of the **CBE Backend Training Assignment** — this frontend demonstrates enterprise-level mobile architecture patterns.

The app is built using **Flutter** with **Clean Architecture**, **BLoC** for state management, **GoRouter** for declarative navigation, and **Hive** for offline data persistence.

## ✨ Key Features

*   **Full Wallet Management:** Create wallets, view wallet details, and list all wallets with pull-to-refresh.
*   **Financial Operations:** Process `Deposit`, `Withdraw`, and `Transfer` operations with form validation matching backend rules.
*   **Transaction History:** Paginated, color-coded transaction list with infinite scroll support.
*   **Idempotency Support:** Auto-generates unique idempotency keys (`dep-<uuid>`, `wd-<uuid>`, `tx-<uuid>`) for every mutation to ensure safe network retries.
*   **Offline Support (Hive):** Cache-first strategy for reads — shows cached data instantly, refreshes from network in background. Financial mutations are always network-first with cache invalidation on success.
*   **Typed Error Handling:** Failure hierarchy mirrors the backend's exception types (404 → `NotFoundFailure`, 422 → `InsufficientFundsFailure`, 409 → `ConflictFailure`, etc.)
*   **CBE Branding:** Professional light theme following the 60/30/10 color rule with CBE's signature purple accent.

---

## 🏗️ Architecture

The application follows **Clean Architecture** with a **Feature-First (Vertical Slice)** folder structure — the same architectural pattern recommended in the backend, adapted for Flutter:

### Three-Layer Architecture (Per Feature)

```
┌────────────────────────────────────────────────────┐
│              PRESENTATION LAYER                    │
│  BLoC (Events/States) + Pages + Widgets            │
│  Flutter-dependent. Triggers Use Cases.             │
├────────────────────────────────────────────────────┤
│                DOMAIN LAYER                        │
│  Entities + Use Cases + Repository Contracts        │
│  Pure Dart. Zero external dependencies.             │
├────────────────────────────────────────────────────┤
│                 DATA LAYER                         │
│  Models (JSON) + Remote DataSources (Dio)          │
│  + Local DataSources (Hive) + Repository Impls      │
│  Talks to the outside world.                       │
└────────────────────────────────────────────────────┘
```

### Dependency Flow (Clean Architecture Rule)

```
Presentation → Domain ← Data
```

The Domain layer defines *contracts* (abstract repositories). The Data layer *implements* them. The Presentation layer only knows about the Domain — never about HTTP, Hive, or JSON.

### Backend CQRS → Frontend BLoC Mapping

| Backend (C#)                | Frontend (Dart)              |
|-----------------------------|------------------------------|
| `DepositCommand`            | `SubmitDeposit` event        |
| `WithdrawCommand`           | `SubmitWithdraw` event       |
| `TransferCommand`           | `SubmitTransfer` event       |
| `GetWalletQuery`            | `LoadWalletDetail` event     |
| `GetWalletsQuery`           | `LoadWallets` event          |
| `GetTransactionsQuery`      | `LoadTransactions` event     |
| `ApiEnvelope<T>`            | `ApiEnvelope<T>`             |
| `PagedResponse<T>`          | `PagedResponseModel<T>`      |
| `ExceptionMiddleware`       | `Failure` sealed hierarchy   |
| `FluentValidation`          | Form `validator` callbacks   |

---

## 📂 Project Structure

```text
lib/
├── main.dart                          # Entry point (Hive init → DI → runApp)
├── app/
│   ├── app.dart                       # MaterialApp.router (GoRouter + Theme)
│   ├── router.dart                    # GoRouter route definitions
│   └── theme.dart                     # CBE branded 60/30/10 theme system
│
├── core/                              # Shared infrastructure
│   ├── constants/
│   │   └── api_constants.dart         # Base URL + endpoint paths
│   ├── error/
│   │   ├── api_exception.dart         # HTTP exception with status code
│   │   └── failures.dart              # Typed failure sealed classes
│   ├── network/
│   │   ├── api_client.dart            # Dio HTTP client factory
│   │   └── api_envelope.dart          # Generic response deserializer
│   └── utils/
│       └── idempotency.dart           # UUID-based key generator
│
├── features/
│   ├── wallet/                        # ── Wallet Feature ──
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── wallet_remote_datasource.dart
│   │   │   │   └── wallet_local_datasource.dart   (Hive cache)
│   │   │   ├── models/
│   │   │   │   ├── wallet_model.dart
│   │   │   │   └── paged_response_model.dart
│   │   │   └── repositories/
│   │   │       └── wallet_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── wallet.dart
│   │   │   ├── repositories/
│   │   │   │   └── wallet_repository.dart         (Abstract)
│   │   │   └── usecases/
│   │   │       ├── create_wallet.dart
│   │   │       ├── get_wallet.dart
│   │   │       └── get_wallets.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── wallet_bloc.dart
│   │       │   ├── wallet_event.dart
│   │       │   └── wallet_state.dart
│   │       ├── pages/
│   │       │   ├── wallets_page.dart
│   │       │   └── wallet_detail_page.dart
│   │       └── widgets/
│   │           ├── wallet_card.dart
│   │           └── create_wallet_dialog.dart
│   │
│   └── transaction/                   # ── Transaction Feature ──
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── transaction_remote_datasource.dart
│       │   │   └── transaction_local_datasource.dart  (Hive cache)
│       │   ├── models/
│       │   │   └── transaction_model.dart
│       │   └── repositories/
│       │       └── transaction_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── transaction.dart
│       │   │   └── transaction_type.dart
│       │   ├── repositories/
│       │   │   └── transaction_repository.dart     (Abstract)
│       │   └── usecases/
│       │       └── transaction_usecases.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── transaction_bloc.dart
│           │   ├── transaction_event.dart
│           │   └── transaction_state.dart
│           ├── pages/
│           │   └── transactions_page.dart
│           └── widgets/
│               ├── amount_input_sheet.dart
│               ├── transaction_tile.dart
│               └── transfer_sheet.dart
│
└── di/
    └── injection_container.dart       # GetIt service locator
```

---

## 🚀 Getting Started

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.11+)
*   Android Studio / VS Code with Flutter plugins
*   Android Emulator or physical device
*   The [Wallet API backend](../WalletApi/README.md) running locally

### 1. Start the Backend

```bash
cd WalletApi
dotnet run
```

The API must be running on `http://localhost:5000` before launching the Flutter app.

### 2. Install Dependencies

```bash
cd wallet_app
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

> **Note:** The app is configured for Android emulator by default (`10.0.2.2:5000` → host machine's `localhost:5000`). For Chrome or physical device testing, update the base URL in `lib/core/constants/api_constants.dart`.

---

## 🎨 Design System

The UI follows the **60/30/10 color rule** with CBE branding:

| Proportion | Role               | Colors                                    |
|------------|--------------------|--------------------------------------------|
| **60%**    | Neutral (Backgrounds) | White `#FFFFFF`, Light gray `#F7F7FA`    |
| **30%**    | Complementary (Text)  | Charcoal `#1A1A2E`, Gray `#5A5A72`      |
| **10%**    | Brand Accent (CTA)    | CBE Purple `#662D91`, Gold `#D4A843`    |

### Semantic Colors
- **Deposits/Income:** Green `#2E7D51`
- **Withdrawals/Expenses:** Red `#D32F2F`
- **Transfers:** Purple `#662D91`

---

## 🧪 Offline Caching Strategy (Hive)

| Operation          | Strategy              | Rationale                                    |
|--------------------|-----------------------|----------------------------------------------|
| **Get Wallets**    | Cache-first, refresh  | Show cached data instantly, update in background |
| **Get Wallet**     | Cache-first, refresh  | Stale balance is acceptable for 1-2 seconds   |
| **Get Transactions** | Cache-first (page 1) | Only first page is cached for quick access    |
| **Deposit**        | Network-first only    | Financial mutation must hit the server        |
| **Withdraw**       | Network-first only    | Balance validation is server-side             |
| **Transfer**       | Network-first only    | Atomicity guaranteed by backend transaction   |

After any successful financial mutation, both the wallet cache and transaction cache for the affected wallet(s) are **invalidated** to ensure the next read fetches fresh data from the server.

---

## 🔗 API Integration

All API contracts match the backend's Postman collection. The `ApiEnvelope<T>` wrapper is deserialized identically to the backend's C# definition:

```dart
class ApiEnvelope<T> {
  final bool success;     // Maps to: ApiEnvelope<T>.Success
  final T? data;          // Maps to: ApiEnvelope<T>.Data
  final List<String>? errors;  // Maps to: ApiEnvelope<T>.Errors
  final String? traceId;  // Maps to: ApiEnvelope<T>.TraceId
  final DateTime? timestamp;   // Maps to: ApiEnvelope<T>.Timestamp
}
```

### Error Mapping: Backend → Frontend

| Backend Exception               | HTTP Code | Flutter Failure             |
|---------------------------------|-----------|-----------------------------|
| `NotFoundException`             | 404       | `NotFoundFailure`           |
| `DomainException`               | 400       | `ValidationFailure`         |
| `InsufficientFundsException`    | 422       | `InsufficientFundsFailure`  |
| `ConcurrencyConflictException`  | 409       | `ConflictFailure`           |
| `DuplicateOperationException`   | 409       | `ConflictFailure`           |
| `IdempotencyMismatchException`  | 400       | `ValidationFailure`         |
| Unhandled exceptions            | 500       | `ServerFailure`             |
| Network timeout / no connection | —         | `NetworkFailure`            |

---

## 📦 Dependencies

| Package           | Version  | Purpose                                    |
|-------------------|----------|--------------------------------------------|
| `flutter_bloc`    | ^9.0.0   | BLoC state management (events → states)    |
| `go_router`       | ^15.0.0  | Declarative routing with path parameters   |
| `dio`             | ^5.8.0   | HTTP client with interceptors & logging    |
| `get_it`          | ^8.0.0   | Service locator / dependency injection     |
| `equatable`       | ^2.0.7   | Value equality for BLoC states & entities  |
| `hive`            | ^2.2.3   | Lightweight NoSQL local persistence        |
| `hive_flutter`    | ^1.1.0   | Hive + Flutter integration                 |
| `uuid`            | ^4.5.1   | Idempotency key generation (UUID v4)       |
| `intl`            | ^0.20.0  | Currency & date formatting                 |
| `google_fonts`    | ^6.2.1   | Inter font family for premium typography   |
| `shimmer`         | ^3.0.0   | Skeleton loading animations                |
| `flutter_animate` | ^4.5.2   | Staggered entrance micro-animations        |
