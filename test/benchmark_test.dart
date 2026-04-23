import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dashboard_grid/dashboard_grid.dart';

void main() {
  test('Benchmark O(N^2) list search vs Map', () {
    final List<DashboardWidget> from = [];
    final List<DashboardWidget> to = [];

    Widget dummyBuilder(BuildContext context) => const SizedBox();

    for (int i = 0; i < 5000; i++) {
      from.add(DashboardWidget(id: 'widget_$i', width: 1, height: 1, x: i % 10, y: i ~/ 10, builder: dummyBuilder));
      to.add(DashboardWidget(id: 'widget_$i', width: 1, height: 1, x: (i + 1) % 10, y: (i + 1) ~/ 10, builder: dummyBuilder));
    }

    final stopwatch1 = Stopwatch()..start();
    // Baseline logic
    final movedWidgets1 = from.map((fromWidget) {
      DashboardWidget? toWidget;
      for (var w in to) {
        if (w.id == fromWidget.id) {
          toWidget = w;
          break;
        }
      }

      final hasMoved =
          toWidget != null &&
          (fromWidget.x != toWidget.x || fromWidget.y != toWidget.y);

      if (hasMoved) {
        return DashboardGridChangeSnapshot(from: fromWidget, to: toWidget);
      }

      return null;
    }).toList();
    stopwatch1.stop();
    print('Baseline duration for O(N^2) list search: ${stopwatch1.elapsedMilliseconds} ms');

    final stopwatch2 = Stopwatch()..start();
    // Optimized logic
    final toMap = {for (var w in to) w.id: w};
    final movedWidgets2 = from.map((fromWidget) {
      final toWidget = toMap[fromWidget.id];

      final hasMoved =
          toWidget != null &&
          (fromWidget.x != toWidget.x || fromWidget.y != toWidget.y);

      if (hasMoved) {
        return DashboardGridChangeSnapshot(from: fromWidget, to: toWidget);
      }

      return null;
    }).toList();
    stopwatch2.stop();
    print('Optimized duration with Map: ${stopwatch2.elapsedMilliseconds} ms');

    expect(movedWidgets1.length, movedWidgets2.length);
  });
}
