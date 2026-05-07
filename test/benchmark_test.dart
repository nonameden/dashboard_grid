import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dashboard_grid/dashboard_grid.dart';

void main() {
  test('Benchmark DashboardGrid.moveWidget lookup overhead', () {
    final grid = DashboardGrid(maxColumns: 10, currentHeight: 1);
    Widget dummyBuilder(BuildContext context) => const SizedBox();

    for (int i = 0; i < 2000; i++) {
      grid.addWidget(DashboardWidget(
        id: 'widget_$i',
        width: 1,
        height: 1,
        x: i % 10,
        y: i ~/ 10,
        builder: dummyBuilder,
      ));
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 2000; i++) {
      grid.moveWidget('widget_$i', x: i % 10, y: i ~/ 10);
    }
    stopwatch.stop();
    print('Duration for 2000 moveWidget calls (no-op moves): ${stopwatch.elapsedMilliseconds} ms');
  });
}
