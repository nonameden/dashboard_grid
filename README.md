[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=nonameden_dashboard_grid&metric=coverage)](https://sonarcloud.io/summary/new_code?id=nonameden_dashboard_grid)

This package allows to show users dashboard, with drag and drop support in Edit Mode.

## Features

* Can place widgets programatically by specifying X,Y of the widget
* Shifts widgets if newly placed widget overlaps with existin widgets

## Getting started

```bash
flutter pub add dashboard_grid
```

## Usage
Create config

```dart
final dashboardConfig = DashboardGrid(
    maxColumns: 4,
);
```

Dashboard Config has a listener which can notify when config has changed during edit mode by draf and drop, or when widget added programmatically

```dart
void _configListener() {
    setState(() {});
}

dashboardConfig.addListener(_configListener);
```

You can add widget to the dashboard

```dart
dashboardConfig.addWidget(
    DashboardWidget(
        id: id,     // Unique Id for the widget to easy locate it
        x: 0,       // X coordinate where you can place the widget
        y: 0,       // Y coordinate where you can place the widget
        width: 1,   // Width in column size
        height: 2,  // height in column size
        builder: (context) {
            return YourWidgetHere();
        },
    ),
),
```

Supply config during widget creation

```dart
Dashboard(
    editMode: editMode,
    config: dashboardConfig,
);
```

## Additional information

Whats next:
* Add example folder
* Allow widgets with height more than 1