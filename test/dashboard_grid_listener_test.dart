import 'dart:async';

import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should notify when widget placed', () {
    final widget = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final controller =
        StreamController<Iterable<DashboardGridChangeSnapshot>>();
    expectLater(
      controller.stream,
      emits([DashboardGridChangeSnapshot(from: null, to: widget)]),
    );

    final grid = DashboardGrid(
      maxColumns: 3,
      currentHeight: 1,
      listener: controller.sink.add,
    );

    grid.addWidget(widget);
  });

  test('should notify when widget removed', () {
    final widget = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final controller =
        StreamController<Iterable<DashboardGridChangeSnapshot>>();
    expectLater(
      controller.stream,
      emitsInOrder([
        [DashboardGridChangeSnapshot(from: null, to: widget)],
        [DashboardGridChangeSnapshot(from: widget, to: null)],
      ]),
    );

    final grid = DashboardGrid(
      maxColumns: 3,
      currentHeight: 1,
      listener: controller.sink.add,
    );

    grid.addWidget(widget);
    grid.removeWidget(widget);
  });

  test('should notify when widget moved', () {
    final widget1 = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );
    final widget2 = DashboardWidget(
      id: 'id1',
      x: 1,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final controller =
        StreamController<Iterable<DashboardGridChangeSnapshot>>();
    expectLater(
      controller.stream,
      emitsInOrder([
        [DashboardGridChangeSnapshot(from: null, to: widget1)],
        [DashboardGridChangeSnapshot(from: widget1, to: widget2)],
      ]),
    );

    final grid = DashboardGrid(
      maxColumns: 3,
      currentHeight: 1,
      listener: controller.sink.add,
    );

    grid.addWidget(widget1);
    grid.moveWidget(widget1.id, widget2.x, widget2.y);
  });

  test('should notify when one widget move another widget', () {
    final widget1 = DashboardWidget(
      id: 'id1',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );
    final widget2 = DashboardWidget(
      id: 'id2',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      builder: (context) => Container(),
    );

    final controller =
        StreamController<Iterable<DashboardGridChangeSnapshot>>();
    expectLater(
      controller.stream,
      emitsInOrder([
        [DashboardGridChangeSnapshot(from: null, to: widget1)],
        [
          DashboardGridChangeSnapshot(from: null, to: widget2),
          DashboardGridChangeSnapshot(from: widget1, to: widget1.copyWith(x: 1)),
        ],
      ]),
    );

    final grid = DashboardGrid(
      maxColumns: 3,
      currentHeight: 1,
      listener: controller.sink.add,
    );

    grid.addWidget(widget1);
    grid.addWidget(widget2);
  });
}
