# Gemini Code Assistant Context

## Project Overview

This project is a Flutter package named `dashboard_grid`. It provides a configurable dashboard widget that supports adding, removing, and moving widgets with drag-and-drop functionality in an edit mode. The main components are the `Dashboard` widget and the `DashboardGrid` configuration object.

The `DashboardGrid` object allows you to define the grid's properties, such as the maximum number of columns, and to programmatically manage the widgets on the dashboard. It uses a `ChangeNotifier` to notify listeners of any changes to the dashboard layout.

The `Dashboard` widget takes a `DashboardGrid` configuration and an `editMode` flag to render the dashboard. When `editMode` is true, users can rearrange widgets by dragging and dropping them.

## Building and Running

This is a standard Flutter package. The following commands can be used for common development tasks:

*   **Get dependencies:**
    ```bash
    flutter pub get
    ```

*   **Run tests:**
    ```bash
    flutter test
    ```

*   **Run the example application:**
    ```bash
    flutter run -d chrome
    ```
    (or any other supported platform)

## Development Conventions

*   **Linting:** The project uses the standard `flutter_lints` package for code analysis. The configuration is in the `analysis_options.yaml` file.
*   **Testing:** The project has unit and widget tests in the `test` directory. New features should be accompanied by corresponding tests.
*   **Example:** The `example` directory contains a sample application demonstrating the usage of the `dashboard_grid` package. This should be updated as new features are added.
