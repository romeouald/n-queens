# N Queens

## About

A SwiftUI puzzle game based on the [N-Queens problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle). Place *n* queens on an *n×n* chessboard so that no two queens share a row, column, or diagonal.

## Video

https://github.com/user-attachments/assets/fe6d01e2-1e2d-401e-9df5-177142b5d51e

## System requirements

- Xcode 16+
- iOS 17.0+
- Swift 6+

### How to Build/Run/Test

1. Open the `NQueens.xcodeproj` in Xcode 16 or newer version
2. Select iOS destination (iOS 17.0+)
   - iOS Simulator *or*
   - Real device (confirm Development Team / Provisioning settings)
3. Build / Run / Test:
   - **Build:** press `Cmd+B` or use the `Product` > `Build` menu item
   - **Run:** press `Cmd+R` or use the `Product` > `Run` menu item
   - **Test:** press `Cmd+U` or use the `Product` > `Test` menu item

## Architecture

The app uses a ViewModel + View architecture with a clean boundary between domain logic, persistence, and UI. Dependency injection is used throughout - every external dependency (clock, storage, game engine) is injected via protocol, making the codebase straightforward to test and extend.

### Domain layer

The core puzzle logic lives in `NQueens`, a struct conforming to `Chess.Game.Engine`. It takes a board and a tap index, mutates the board, and returns a structured `MoveResult` - a typed value containing the move kind, game status, and current progress. The engine never holds state itself; the board is passed in by reference and mutated in place.

Conflict detection runs a single O(n) pass over the board using four dictionaries keyed by row, column, positive diagonal (`row + col`), and negative diagonal (`row - col`). Any queen sharing a key with a prior queen is added to a conflict set. This runs comfortably within a single frame budget even on large boards - a 64×64 board with 64 queens evaluates in under 2ms on an iPhone 15 Pro Max (verified by an inline `ContinuousClock` benchmark in the test suite).

The `Chess.Game.Engine` protocol means the game engine is fully swappable - the ViewModel never imports the `NQueens` type directly, only the protocol. This made it straightforward to write a `GameEngineSpy` for tests that stubs return values without running any puzzle logic.

### ViewModel layer

`GameViewModel` is generic over `Clock` (`GameViewModel<GameClock: Clock>`), which means the timer is a proper injected dependency rather than a `Date()` call buried in business logic. Tests use a custom `TestClock` that advances time manually, making timing-dependent assertions (elapsed time, best-time comparisons, new-record detection) fully deterministic without `sleep` or `expectation` hacks.

The ViewModel distinguishes three win states - first solve, new personal best, and subsequent solve - and reflects each with a different overlay style. The back button and reset button both check whether a game is in progress and prompt for confirmation before discarding it, preventing accidental loss of progress.

All state is exposed via `@Observable`, avoiding the overhead of `ObservableObject` and keeping the reactive surface minimal.

### Persistence

Best times are stored via `BestTimeStoring`, a protocol over a `SwiftData`-backed implementation. The protocol boundary means tests and previews use a `BestTimeStoreSpy` that records calls without touching disk. The store is keyed by board size and only updates when a new time genuinely beats the existing record - verified by a negative test asserting `saveBestTimeCallCount == 0` when the time doesn't improve.

### UX layer

Sound and haptic feedback are driven by the `MoveResult` the engine returns. Each `Move` case (`.place(conflicting:)`, `.remove`, `.invalid`, `.reset`) carries its own `Feedback` value via an extension, so the ViewModel never contains a switch statement mapping moves to sounds - the mapping lives with the type it describes.

### Folder structure

```
NQueens/
├── Extensions/          # Duration and FormatStyle helpers
├── Logic/
│   ├── Chess/
│   │   ├── Elements/    # Board, Square, Piece, Color - pure data
│   │   └── Games/       # Chess.Game.Engine protocol, NQueens implementation
│   └── Persistence/     # BestTimeStoring protocol + SwiftData implementation
├── UI/
│   └── Scenes/
│       ├── Configuration/   # Board size picker
│       └── Game/            # GameView, GameViewModel, BoardView, WinOverlay
└── UX/                  # SoundEffect, Feedback, environment injection
```

## Testing Strategy

Tests are written using Swift Testing (`@Suite`, `@Test`, `#expect`) and organised into nested suites by behaviour, making it easy to locate coverage for any specific interaction.

**Domain tests** (`NQueensTests`) cover every engine behaviour in isolation: placing, removing, progress tracking, game status transitions, conflict detection across all four axes (row, column, positive diagonal, negative diagonal), and reset. A dedicated performance suite measures conflict evaluation on a fully-populated 64×64 board over 100 passes, asserting the total stays under 0.5 seconds.

**ViewModel tests** (`GameViewModelTests`) test business logic in complete isolation from the puzzle engine. The `GameEngineSpy` stubs `toggleSquare` return values, so tests assert ViewModel behaviour - timer management, alert presentation, best-time persistence decisions, win overlay selection - without running any N-Queens logic. The `TestClock` makes all timing assertions deterministic. Negative assertions (e.g. verifying the store is *not* written when a time doesn't improve) are explicitly covered.

**Persistence tests** (`BestTimeStoreTests`) verify best-time replacement rules and board-size isolation.

**Extension tests** cover `Duration` and `FormatStyle` helpers.

## Submission checklist

- ♟️ Gameplay
  - [x] Let the player select a board size (n ≥ 4, since below that there are no solutions).
  - [x] Render an interactive n×n chessboard.
  - [x] User can tap to place/remove queens.
  - [x] Provide real-time validation of queen placement and highlight conflicts.
  - [x] Display a win screen when the user successfully solves it.
- 🎨 UI
  - [x] Dynamic chessboard that can be of different sizes.
  - [x] Queens should be visually clear (♛, image or icon).
  - [x] Conflicting placements should be clearly marked.
  - [x] Simple, extensible and clean design.
- 💡 Nice-to-haves
  - [x] Show a counter of queens left.
  - [x] Let user restart/reset the game.
  - [x] Store and display best times.
  - [x] Decorate via sfx and animations the queen placement or victory celebration.
- 📐 Testing & Architecture
  - [x] Focus on lean but strong architecture (your choice).
  - [x] Have a clear testing strategy and strong coverage.
  - [x] Maintain clear separation of UI and logic.
  - [x] During the follow up interview you will walk us through the code and we will build an extension together so feel comfortable with presenting and working on the codebase.
- 📦 Submission
Send the url of a github repo with your solution to your recruiter together with:

  - [x] A README including:
    - [x] How to test/build/run
    - [x] Architecture decisions
  - [x] A short video of your app, feel free to edit it or add a voice over in case you want to improve its presentation.
  - [x] Use Swift and SwitfUI.

## AI Disclosure

AI tools were used during development, primarily for boilerplate and unit test generation. All AI-assisted output was reviewed, understood, and integrated deliberately.

## Known Limitations & Future Work

Given the scope of the submission, there were some things left on the table:

- **Modularity** - Domain logic, persistence, and UI all live within a single target. Extracting them into separate Swift packages (e.g. a standalone `Chess` or `NQueens` logic module) would strengthen build isolation and testability at scale, but was intentionally skipped to keep the project structure approachable for a take-home submission.
- **Accessibility** - VoiceOver labels and accessibility actions for board squares are not yet implemented.
- **Localisation** - All strings are hardcoded in English. Extracting to `.xcstrings` is straightforward given the small string surface.
- **Landscape** - The layout is portrait-only; landscape would require adapting the board sizing logic.
- **Dynamic board size upper bound** - The maximum is currently hardcoded rather than derived from screen geometry.
- **Undo/Redo** - The architecture would support this with minimal changes: `Chess.Board` is a value type, and the ViewModel could maintain a history stack of board snapshots.
