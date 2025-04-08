import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = [
    DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    ),
    DashboardWidget(
      id: 'id2',
      x: 1,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    ),
    DashboardWidget(
      id: 'id3',
      x: 2,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    ),
    DashboardWidget(
      id: 'id4',
      x: 0,
      y: 1,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    ),
  ];

  test('should be able to create the dashboard config', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    grid.addWidget(config[0]);

    expect(grid.size, equals(1));
    expect(grid.getWidgetAt(0, 0), equals(config[0]));
    expect(grid.currentHeight, equals(2));
  });

  test('should resort widgets according to x -> y', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    grid.addWidget(config[3]);
    grid.addWidget(config[1]);
    grid.addWidget(config[0]);
    grid.addWidget(config[2]);

    expect(grid.size, equals(4));
    expect(grid.widgets, equals(config));
    expect(grid.currentHeight, equals(3));
  });

  test('get widget at [x,y] should return widget if present', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    grid.addWidget(config[3]);
    grid.addWidget(config[1]);
    grid.addWidget(config[0]);
    grid.addWidget(config[2]);

    expect(grid.getWidgetAt(0, 0), equals(config[0]));
    expect(grid.getWidgetAt(2, 0), equals(config[2]));
  });

  test('get widget at [x,y] should return null if no widget', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    grid.addWidget(config[3]);
    grid.addWidget(config[1]);

    expect(grid.getWidgetAt(0, 0), isNull);
    expect(grid.getWidgetAt(2, 0), isNull);
  });

  test('get widget at [x,y] should return widget when cords of the tail', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    final widget = DashboardWidget(
      id: 'id0',
      x: 1,
      y: 0,
      width: 2,
      height: 1,
      builder: (context) => Container(),
    );

    grid.addWidget(widget);

    expect(grid.getWidgetAt(2, 0), widget);
  });

  test('should resize widget if width is bigger than dashboard', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    final widget = DashboardWidget(
      id: 'id0',
      x: 0,
      y: 0,
      width: 4,
      height: 1,
      builder: (context) => Container(),
    );

    grid.addWidget(widget);
    final resizedWidget = grid.getWidgetAt(0, 0);

    expect(resizedWidget?.id, equals(widget.id));
    expect(resizedWidget?.width, equals(grid.maxColumns));
  });

  test('should shift widget if new widget overlaps with existing', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    final widget1 = DashboardWidget(
      id: 'id0',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final widget2 = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    grid.addWidget(widget1);
    grid.addWidget(widget2);

    expect(grid.getWidgetAt(0, 0)?.id, equals('id1'));
    expect(grid.getWidgetAt(1, 0)?.id, equals('id0'));
  });

  test('should shift widget down if not enough space on the right', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    final widget1 = DashboardWidget(
      id: 'id0',
      x: 0,
      y: 0,
      width: 3,
      height: 1,
      builder: (context) => Container(),
    );

    final widget2 = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    grid.addWidget(widget1);
    grid.addWidget(widget2);

    expect(grid.getWidgetAt(0, 0)?.id, equals('id1'));
    expect(grid.getWidgetAt(1, 0)?.id, isNull);
    expect(grid.getWidgetAt(0, 1)?.id, equals('id0'));
  });

  test(
    'should shift widget and put to next available slot if not enough space',
    () {
      final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

      final widget1 = DashboardWidget(
        id: 'id0',
        x: 1,
        y: 0,
        width: 3,
        height: 1,
        builder: (context) => Container(),
      );

      expect(
        () => grid.addWidget(widget1),
        throwsA(isA<NotEnoughSpaceException>()),
      );
    },
  );

  test('Removing widget should free up space', () {
    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    final widget1 = DashboardWidget(
      id: 'id0',
      x: 1,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final widget2 = DashboardWidget(
      id: 'id1',
      x: 1,
      y: 1,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    grid.addWidget(widget1);
    grid.addWidget(widget2);
    grid.moveWidget(widget2.id, 0, 0);

    expect(grid.currentHeight, 2);
  });
}
