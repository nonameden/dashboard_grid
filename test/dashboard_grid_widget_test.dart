import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should be able to display empty dashboard', (tester) async {
    // Arrange
    final config = DashboardGrid(maxColumns: 2);

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Dashboard(config: config))),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Dashboard), findsOneWidget);
  });

  testWidgets('should be able to display 1x1 widget on dashboard', (
    tester,
  ) async {
    // Arrange
    final config = DashboardGrid(maxColumns: 2);
    config.addWidget(
      DashboardWidget(
        id: 'id1',
        x: 0,
        y: 0,
        width: 1,
        height: 1,
        builder: (context) {
          return Container(color: Colors.red, child: Text('Widget 1'));
        },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Dashboard(config: config))),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Dashboard), findsOneWidget);
    expect(find.text('Widget 1'), findsOneWidget);
  });

  testWidgets('should be able to display 2x1 widget on dashboard', (
    tester,
  ) async {
    // Arrange
    final config = DashboardGrid(maxColumns: 2);
    config.addWidget(
      DashboardWidget(
        id: 'id1',
        x: 0,
        y: 0,
        width: 2,
        height: 1,
        builder: (context) {
          return Container(color: Colors.red, child: Text('Widget 1'));
        },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Dashboard(config: config))),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Dashboard), findsOneWidget);
    expect(find.text('Widget 1'), findsOneWidget);
  });

  testWidgets('should swallow NotEnoughSpaceException on widget move via drag and drop', (tester) async {
    final config = DashboardGrid(maxColumns: 2);
    config.addWidget(
      DashboardWidget(
        id: 'id1',
        x: 0,
        y: 0,
        width: 2,
        height: 1,
        builder: (context) {
          return Container(key: const Key('widget1'), color: Colors.red);
        },
      ),
    );
    config.addWidget(
      DashboardWidget(
        id: 'id2',
        x: 0,
        y: 1,
        width: 1,
        height: 1,
        builder: (context) {
          return Container(key: const Key('widget2'), color: Colors.blue);
        },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Dashboard(config: config, editMode: true))),
    );
    await tester.pumpAndSettle();

    // Check initial state
    expect(config.getWidgetAt(x: 0, y: 0)?.id, 'id1');
    expect(config.getWidgetAt(x: 0, y: 0)?.width, 2);

    final widget1 = find.byKey(const Key('widget1'));
    // Drag it from its center to right bottom empty space (x=1, y=1)
    await tester.drag(widget1, const Offset(80, 160));
    await tester.pumpAndSettle();

    // Verify it didn't crash and widget wasn't moved to an invalid state.
    // The widget is expected to stay exactly where it was before, or be placed somewhere valid.
    final widget1After = config.getWidgetAt(x: 0, y: 0);
    expect(widget1After?.id, 'id1');
    expect(widget1After?.x, 0);
    expect(widget1After?.y, 0);
  });
}
