# Wallet API 🏦

A robust, production-grade RESTful Wallet API designed to handle financial transactions securely. This project was developed as part of the **CBE Backend Training Assignment**.

The API is built using **.NET 10** and **C#**, utilizing **Entity Framework Core** with **PostgreSQL** as the relational database. It is architected using the **CQRS (Command Query Responsibility Segregation)** pattern to cleanly separate read and write operations, ensuring maintainability, scalability, and strict enforcement of domain invariants.

## ✨ Key Features

*   **Core Wallet Operations:** Create wallets, fetch wallet details, and list all wallets.
*   **Financial Transactions:** Securely process `Deposit`, `Withdraw`, and `Transfer` operations.
*   **Strict Invariants:** Domain models enforce business rules (e.g., cannot withdraw more than the available balance).
*   **Idempotency Guarantee:** All mutation endpoints (`POST`) support idempotency keys. This ensures that network retries or duplicate requests never result in double-charging or duplicate transactions.
*   **Optimistic Concurrency:** Uses PostgreSQL's native `xmin` system column to prevent race conditions and lost updates when multiple transactions hit the same wallet simultaneously.
*   **Global Exception Handling:** Centralized middleware (`ExceptionMiddleware`) catches domain exceptions and translates them into structured, standardized HTTP responses (e.g., `404 Not Found`, `400 Bad Request`, `409 Conflict`, `422 Unprocessable Entity`).
*   **Resilience & Retries:** Configured with EF Core's `EnableRetryOnFailure` execution strategy to smoothly handle transient database connectivity issues.
*   **Structured Logging:** Integrated with **Serilog** for rich, context-aware console logging.
*   **API Documentation:** Built-in OpenAPI specification with **Scalar** UI for easy local testing.

---

## 🏗️ Architecture

The application adheres to clean architecture principles:
*   **Domain Models:** Rich `Wallet` and `Transaction` models encapsulate business logic and invariants.
*   **CQRS Pattern:** 
    *   **Commands:** (e.g., `DepositHandler`, `TransferHandler`) Handle state changes and database writes.
    *   **Queries:** (e.g., `GetWalletHandler`, `GetTransactionsHandler`) Handle high-performance UI reads using `AsNoTracking()`.
*   **Validation Layer:** Uses **FluentValidation** to catch bad requests before they ever reach the domain logic.

---

## 🚀 Getting Started

### Prerequisites
*   [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)
*   [PostgreSQL](https://www.postgresql.org/download/) (running locally or via Docker)

### 1. Database Configuration
Update the `ConnectionStrings:Default` in `WalletApi/appsettings.json` to point to your local PostgreSQL instance:
```json
"ConnectionStrings": {
  "Default": "Host=localhost;Port=5432;Database=wallet_db;Username=postgres;Password=yourpassword"
}
```

### 2. Running the Application
You do **not** need to run database migrations manually! The application is configured to automatically apply EF Core migrations and create the `wallet_db` database on startup.

Navigate to the project directory and run:
```bash
cd WalletApi
dotnet run
```

### 3. API Documentation (Scalar UI)
Once the application is running in the `Development` environment, you can explore and test the endpoints visually by navigating to:
👉 **`https://localhost:<port>/scalar/v1`**

---

## 🧪 Testing the API

For thorough endpoint testing, a pre-configured **Postman Collection** is included in the project repository:
📄 `WalletApi_Postman_Collection.json`

**How to use:**
1. Open Postman.
2. Click **Import** and select the `WalletApi_Postman_Collection.json` file.
3. The collection contains pre-configured requests for creating wallets, depositing, transferring, and checking balances.

### About Idempotency Keys (Important!)
When testing `Deposit`, `Withdraw`, or `Transfer` endpoints, you must provide an `IdempotencyKey` in the JSON body. 
*   In Postman, you can use the dynamic variable `"{{$guid}}"` to have Postman auto-generate a fresh, unique key for every request.
*   If you purposefully reuse the exact same key with the exact same payload, the API will safely return the cached success response.
*   If you reuse an old key with a *different* payload (e.g., different amount), the API will reject it with a `400 Bad Request` to protect the system’s integrity.

---

## 🛠️ Project Structure
```text
WalletApi/
├── Application/        # CQRS Handlers (Commands & Queries)
├── Common/             # Exceptions, Enums, Middleware (Global Error Handling)
├── Controllers/        # RESTful API Endpoints (v1)
├── Data/               # EF Core DbContext & Entity Configurations
├── DTOs/               # Data Transfer Objects & Mapping Extensions
├── Models/             # Domain Entities (Wallet, Transaction)
├── Validators/         # FluentValidation rules
└── Program.cs          # App configuration, DI Registration, and Auto-Migrations
```
