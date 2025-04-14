import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'dashboard_widget.dart';

class DashboardGridChangeSnapshot {
  DashboardGridChangeSnapshot({
    required this.from,
    required this.to,
  });

  final DashboardWidget from;
  final DashboardWidget to;
}

typedef DashboardGridChangeListener =
    void Function(List<DashboardGridChangeSnapshot> changes);

class DashboardGrid with ChangeNotifier {
  DashboardGrid({
    required this.maxColumns,
    this.currentHeight = 1,
    this.listener,
  });

  final int maxColumns;
  int currentHeight;
  List<DashboardWidget> _widgets = [];
  DashboardGridChangeListener? listener;

  int get size => _widgets.length;

  Iterable<DashboardWidget> get widgets => [..._widgets];

  DashboardWidget? getWidgetAt(int x, int y) {
    return _getWidgetAt(_widgets, x, y);
  }

  void moveWidget(String widgetId, int x, int y) {
    DashboardWidget? widget;
    try {
      widget = _widgets.firstWhere((element) => element.id == widgetId);
      _widgets.remove(widget);
      addWidget(widget.copyWith(x: x, y: y));
    } catch (e) {
      if (widget != null) {
        _widgets.add(widget);
      }
      rethrow;
    }
  }

  void addWidget(DashboardWidget widget) {
    final widgetToAdd = widget.copyWith(
      width: math.min(maxColumns, widget.width),
    );
    final result = _addWidget(_widgets, widgetToAdd);
    result.sort((a, b) {
      if (a.y == b.y) {
        return a.x.compareTo(b.x);
      }

      return a.y.compareTo(b.y);
    });

    _widgets = result;
    _updateHeightIfNeed();
    notifyListeners();
  }

  void removeWidget(DashboardWidget widget) {
    final result =
        _widgets.where((element) => element.id != widget.id).toList();

    _widgets = result;
    _updateHeightIfNeed();
    notifyListeners();
  }

  List<DashboardWidget> _addWidget(
    List<DashboardWidget> base,
    DashboardWidget widget,
  ) {
    if (widget.x + widget.width > maxColumns) {
      throw NotEnoughSpaceException();
    }

    final result = _freeSpaceForWidgetIfNeed(base, widget);
    result.add(widget);

    return result;
  }

  void _updateHeightIfNeed() {
    var currentMaxHeight = 0;
    for (final widget in _widgets) {
      currentMaxHeight = math.max(currentMaxHeight, widget.y + widget.height);
    }

    currentHeight = currentMaxHeight + 1;
  }

  DashboardWidget? _getWidgetAt(List<DashboardWidget> base, int x, int y) {
    for (final widget in base) {
      final minX = widget.x;
      final maxX = minX + widget.width;

      final minY = widget.y;
      final maxY = minY + widget.height;

      if (minX <= x && x < maxX && minY <= y && y < maxY) {
        return widget;
      }
    }

    return null;
  }

  List<DashboardWidget> _freeSpaceForWidgetIfNeed(
    List<DashboardWidget> base,
    DashboardWidget widget,
  ) {
    final widgetToShift = _getOverlapWidget(base, widget);
    if (widgetToShift == null) {
      _debug('Nothing to shift');
      return base;
    }

    // Recursing to free space for the widget to shift
    base.remove(widgetToShift);
    final minX = widgetToShift.x + widget.width;
    final maxX = minX + widgetToShift.width;
    final isBiggerThanAllowed = maxX > maxColumns;

    final copy = widgetToShift.copyWith(
      x: isBiggerThanAllowed ? 0 : minX,
      y: widgetToShift.y + (isBiggerThanAllowed ? 1 : 0),
    );
    _debug('Shifting: $widgetToShift to $copy');

    return _addWidget(base, copy);
  }

  DashboardWidget? _getOverlapWidget(
    List<DashboardWidget> base,
    DashboardWidget widget,
  ) {
    for (var x = widget.x; x < widget.x + widget.width; x++) {
      for (var y = widget.y; y < widget.y + widget.height; y++) {
        final widget = _getWidgetAt(base, x, y);
        if (widget != null) {
          _debug('Overlap widget: $widget');
          return widget;
        }
      }
    }

    _debug('No overlap widget for: $widget');
    return null;
  }

  void _debug(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  DashboardGrid copy() {
    return DashboardGrid(maxColumns: maxColumns, currentHeight: currentHeight)
      .._widgets = _widgets.map((e) => e.copyWith()).toList();
  }
}

class NotEnoughSpaceException implements Exception {
  NotEnoughSpaceException();
}
