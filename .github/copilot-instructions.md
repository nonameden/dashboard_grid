# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

`dashboard_grid` is a Flutter package providing a configurable dashboard widget with drag-and-drop support. It enables programmatic widget placement on a grid with automatic shifting of overlapping widgets.

## Commands

### Dependencies
```bash
flutter pub get
```

### Testing
```bash
# Run all tests with coverage
flutter test --coverage

# Run all tests with machine output (CI format)
flutter test --machine --coverage > tests.output

# Run specific test file
flutter test test/dashboard_grid_test.dart
```

### Linting
```bash
# Analyze code for issues
flutter analyze
```

### Example App
```bash
# Run the example app (from example directory)
cd example
flutter run

# Or run from root
flutter run -d <device> example/lib/main.dart
```

## Architecture

### Core Components

**DashboardGrid** (`lib/src/dashboard_grid.dart`)
- Central data model managing the grid state
- Extends `ChangeNotifier` for reactive updates
- Handles widget positioning logic with automatic overflow resolution
- Key algorithm: when a widget is placed and overlaps with existing widgets, overlapping widgets are automatically shifted right; if not enough space exists on the right, they shift down to the next row
- Maintains a sorted list of widgets (by y-coordinate, then x-coordinate)
- Enforces `maxColumns` constraint and dynamically calculates `currentHeight`

**DashboardWidget** (`lib/src/dashboard_widget.dart`)
- Represents an individual widget on the grid
- Defined by: `id`, `x`, `y`, `width`, `height`, and `builder`
- Width and height are measured in grid units (columns)
- Immutable with `copyWith` support

**Dashboard** (`lib/src/dashboard.dart`)
- Main UI widget implementing the visual dashboard
- Two modes: `editMode` (drag-and-drop enabled) and view mode
- Uses a custom `TableView` implementation for grid rendering
- Manages drag-and-drop interactions through Flutter's `Draggable` and `DragTarget`
- In edit mode, creates a backup of the config state

**TableView** (`lib/src/table/table.dart`)
- Custom 2D scrollable table implementation
- Supports merged cells (widgets spanning multiple rows/columns)
- Lazy rendering: only visible cells are instantiated
- Based on Flutter's `TwoDimensionalScrollView`

### Key Patterns

**Widget Placement Algorithm:**
1. New widget placement removes any existing widget with the same ID
2. Checks if new widget fits within `maxColumns` (throws `NotEnoughSpaceException` if not)
3. Detects overlapping widgets using `_getOverlapWidget`
4. Recursively shifts overlapping widgets to make space
5. Sorts all widgets by position (y first, then x)
6. Updates `currentHeight` based on the bottommost widget

**Change Tracking:**
- `DashboardGridChangeSnapshot` captures before/after states
- `DashboardGridChangeListener` callback notifies of added, removed, or moved widgets
- Changes are computed by comparing widget lists before and after operations

**DevTools Integration:**
- `DevToolsController` registers dashboard instances for debugging
- Exposes `ext.dashboard_grid.getConfig` service extension
- Posts config updates via `ext.dashboard_grid.configUpdate` events
- Useful for the optional DevTools extension in `dashboard_grid_devtools_extension/`

### File Structure
```
lib/
├── dashboard_grid.dart              # Public API exports
├── src/
    ├── dashboard_grid.dart          # Grid logic & state management
    ├── dashboard_widget.dart        # Widget model
    ├── dashboard.dart               # Main dashboard UI widget
    ├── dev_tools_controller.dart    # DevTools integration
    ├── common/
    │   ├── constants.dart           # Default sizing constants
    │   └── span.dart                # Table span utilities
    └── table/                       # Custom table implementation
        ├── table.dart
        ├── table_cell.dart
        ├── table_cell_decoration.dart
        ├── table_delegate.dart
        └── table_span.dart
```

### Testing Strategy
- Unit tests focus on `DashboardGrid` logic (placement, shifting, overlap detection)
- Widget tests verify UI behavior and drag-and-drop interactions
- Listener tests ensure change notifications work correctly
- Coverage is tracked via SonarQube (see `.github/workflows/build.yml`)
