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

The solution is a single target application using a ViewModel + View architecture, with clear separation between business logic and presentation, and dependency injection used throughout for testability. The goal was to keep the codebase lean and approachable — avoiding heavy frameworks — in line with the submission's emphasis on clean, extensible design.

### Folder structure overview

+ `NQueens`
  + `Assets` - various asset catalogs (`.xcassets`) to organize colors, images, sounds, and more
  + `Extensions` - extensions to system types for conversion helpers (`Duration`) and reusable format styles (`FormatStyle`)   
  + `Logic`
    + `Chess`
      + `Elements` - representation of various Chess elements: `Board`, `Square`, `Piece`, `Color`. These types are mostly enums, or data containers with minimal logic.
      + `Game` - Defines the game abstraction, handling interactions, outcomes, and the core NQueens puzzle logic. The game takes a user interaction and a chess board, mutates and evaluates the effects, then returns structured results for consumers to react, display, and provide feedback.
  + `UI`
    + `Scenes` - Application UI organized by scenes (screens). Scenes use the `ViewModel` (business logic) + `View` (UI + presentation logic) architecture, with dependency injection for testability.
      + `Configuration` - Entry point of the application, where user can select the desired board size and start a game
      + `Game` - The main game scene which orchestrates the different features of the gameplay: displays & handles board interactions, measures & stores game time, gives audio and sensory feedback to the user.
        + `Board` - Displays a board based on it's data representation, forwards user taps to a consumer for processing
        + `WinOverlay` - A celebration screen that is displayed on successful solution.
  + `UX` - User experience related types: `SoundEffect` and `SensoryFeedback` related types, helpers, and view modifiers/extensions.
+ `NQueensTests` - Tests for covering the base (`Board`, `NQueens` engine, `PersistentStore`) & business logic (`ViewModel`s). Also provides some stubs to help testing.

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

### Disclosure

AI tools have been used during the development (mostly for unit test generation). All AI-assisted output was reviewed, understood, and integrated deliberately.

## Where to go from here

Given the scope of the submission, there were some things left on the table:

- **Accessibility** — VoiceOver support and accessibility labels for board squares and queens, ensuring the game is playable without visual feedback.
- **I18N** — All user-facing strings are currently hardcoded in English. Extracting them into `.xcstrings` or `Localizable.strings` file would make the app straightforward to translate.
- **Landscape support** — The UI is currently optimized for portrait orientation. Supporting landscape would require adapting the board and overlay layouts.
- **Dynamic board size upper bound** — The maximum board size is currently fixed, but it could be derived from reading current screen size.
- **Undo/Redo** — Persisting a history of moves is a low-effort addition that could meaningfully improve gameplay.
