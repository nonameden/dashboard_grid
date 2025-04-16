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
}
