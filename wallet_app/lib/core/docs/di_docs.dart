library;
/// {@template di_root}
/// Dependency Injection (DI) system using [GetIt].
///
/// This application uses a **feature-based modular DI architecture**.
///
/// The DI system is responsible for:
/// - Wiring dependencies across all layers
/// - Enforcing Clean Architecture boundaries
/// - Providing testable and replaceable implementations
/// {@endtemplate}

/// {@template di_architecture_flow}
/// ## Architecture Flow
///
/// Dependencies are registered following Clean Architecture:
/// ```
/// External → DataSources → Repositories → Use Cases → BLoCs
/// ```
///
/// Each layer depends only on the layer directly below it,
/// ensuring:
/// - Low coupling
/// - High testability
/// - Clear separation of concerns
/// {@endtemplate}

/// {@template di_registration_types}
/// ## Registration Types
///
/// ### registerLazySingleton
/// - Created only once (on first use)
/// - Shared across entire app lifecycle
/// - Used for:
///   Dio, DataSources, Repositories, UseCases
///
/// ### registerFactory
/// - Creates a new instance every time
/// - Used for stateful objects
/// - Typically used for:
///   BLoCs (must be disposed with UI lifecycle)
/// {@endtemplate}

/// {@template di_modules}
/// ## Module-Based Architecture
///
/// Dependencies are split into feature modules:
///
/// - wallet_module
/// - transaction_module
///
/// Each module:
/// - Is self-contained
/// - Registers its own dependencies
/// - Does NOT depend on other modules directly
///
/// This keeps features:
/// - Independent
/// - Replaceable
/// - Testable
/// {@endtemplate}

/// {@template di_notes}
/// ## Notes
///
/// - This layer contains NO business logic
/// - Only dependency wiring (composition root)
/// - Acts as single source of truth for DI
/// - Cross-feature dependencies should be minimized
/// {@endtemplate}