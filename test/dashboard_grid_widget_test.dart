import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDashboardGrid extends DashboardGrid {
  MockDashboardGrid({required super.maxColumns});

  @override
  void moveWidget(String id, {required int x, required int y}) {
    throw Exception('General Exception');
  }
}

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

  testWidgets('throws general exception on widget move', (tester) async {
    final config = MockDashboardGrid(maxColumns: 2);
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
      MaterialApp(
        home: Scaffold(body: Dashboard(config: config, editMode: true)),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Widget 1')),
    );
    await tester.pump(const Duration(milliseconds: 500)); // long press for drag
    await gesture.moveTo(
      tester.getCenter(find.byType(DragTarget<DashboardWidget>).last),
    );
    await tester.pump();

    // Expecting exception
    await gesture.up();
    await tester.pump();

    expect(tester.takeException(), isA<Exception>());
  });
}