import 'package:dashboard_grid/dashboard_grid.dart';

void main() {
  final List<DashboardWidget> from = [];
  final List<DashboardWidget> to = [];

  for (int i = 0; i < 5000; i++) {
    from.add(DashboardWidget(id: 'widget_$i', width: 1, height: 1, x: i % 10, y: i ~/ 10));
    to.add(DashboardWidget(id: 'widget_$i', width: 1, height: 1, x: (i + 1) % 10, y: (i + 1) ~/ 10));
  }

  final stopwatch = Stopwatch()..start();
  // We simulate finding the difference as in the original code.
  final movedWidgets = from.map((fromWidget) {
    // using whereOrNull logic but written inline
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

  stopwatch.stop();
  print('Baseline duration for O(N^2) list search: ${stopwatch.elapsedMilliseconds} ms');
}
