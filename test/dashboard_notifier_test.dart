import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should notify when widget added', () {
    final widget = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);

    bool isNotified = false;
    grid.addListener(() {
      isNotified = true;
    });

    grid.addWidget(widget);

    expect(isNotified, isTrue);
  });

  test('should notify when widget moved', () {
    final widget = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);
    grid.addWidget(widget);

    bool isNotified = false;
    grid.addListener(() {
      isNotified = true;
    });

    grid.moveWidget(widget.id, x: 1, y: 1);

    expect(isNotified, isTrue);
  });

  test('should notify when widget moved overlapping itself', () {
    final widget = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 2,
      height: 2,
      builder: (context) => Container(),
    );

    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);
    grid.addWidget(widget);

    bool isNotified = false;
    grid.addListener(() {
      isNotified = true;
    });

    grid.moveWidget(widget.id, x: 1, y: 1);

    expect(isNotified, isTrue);
  });

  test('should not notify when nothing happens', () {
    final widget = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 2,
      height: 2,
      builder: (context) => Container(),
    );

    final grid = DashboardGrid(maxColumns: 3, currentHeight: 1);
    grid.addWidget(widget);

    bool isNotified = false;
    grid.addListener(() {
      isNotified = true;
    });

    expect(isNotified, isFalse);
  });
}
