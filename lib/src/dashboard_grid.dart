import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'dashboard_widget.dart';

/// A snapshot of a change in the dashboard grid.
class DashboardGridChangeSnapshot {
  /// Creates a snapshot of a change in the dashboard grid.
  DashboardGridChangeSnapshot({required this.from, required this.to})
    : assert(from != null || to != null, 'Either from or to must be not null');

  /// The widget before the change.
  final DashboardWidget? from;

  /// The widget after the change.
  final DashboardWidget? to;

  /// The id of the widget that changed.
  String get widgetId => from?.id ?? to?.id ?? '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardGridChangeSnapshot &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() {
    return '{from: $from, to: $to}';
  }
}

/// A listener for changes in the dashboard grid.
typedef DashboardGridChangeListener =
    void Function(Iterable<DashboardGridChangeSnapshot> changes);

/// A class that manages the state of the dashboard grid.
class DashboardGrid with ChangeNotifier {
  /// Creates a dashboard grid.
  DashboardGrid({
    required this.maxColumns,
    this.currentHeight = 1,
    this.listener,
  });

  /// The maximum number of columns in the dashboard.
  final int maxColumns;

  /// The current height of the dashboard.
  int currentHeight;

  /// A listener for changes in the dashboard grid.
  DashboardGridChangeListener? listener;
  List<DashboardWidget> _widgets = [];

  /// The number of widgets in the dashboard.
  int get size => _widgets.length;

  /// The widgets in the dashboard.
  Iterable<DashboardWidget> get widgets => [..._widgets];

  /// Returns the widget at the given coordinates.
  DashboardWidget? getWidgetAt({required int x, required int y}) {
    return _getWidgetAt(_widgets, x, y);
  }

  /// Moves a widget to the given coordinates.
  void moveWidget(String widgetId, {required int x, required int y}) {
    DashboardWidget? widget;
    try {
      widget = _widgets.firstWhere((element) => element.id == widgetId);
      addWidget(widget.copyWith(x: x, y: y));
    } catch (e) {
      if (widget != null) {
        _widgets.add(widget);
      }
      rethrow;
    }
  }

  /// Adds a widget to the dashboard.
  void addWidget(DashboardWidget widget) {
    final backUp = copy();

    final widgetToAdd = widget.copyWith(
      width: math.min(maxColumns, widget.width),
    );
    final result = _addWidget(
      _widgets.whereNot((w) => w.id == widgetToAdd.id).toList(),
      widgetToAdd,
    );
    result.sort((a, b) {
      if (a.y == b.y) {
        return a.x.compareTo(b.x);
      }

      return a.y.compareTo(b.y);
    });

    _commitState(result, backUp);
  }

  /// Removes a widget from the dashboard.
  void removeWidget(DashboardWidget widget) {
    final backUp = copy();
    final result =
        _widgets.where((element) => element.id != widget.id).toList();

    _commitState(result, backUp);
  }

  void _commitState(List<DashboardWidget> newWidgets, DashboardGrid backUp) {
    _widgets = newWidgets;
    _updateHeightIfNeed();

    if (listener != null) {
      final changes = _findDifference(backUp._widgets, newWidgets);
      listener!(changes);
    }
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
    final minX = widget.x;
    final maxX = minX + widget.width;
    final minY = widget.y;
    final maxY = minY + widget.height;

    for (final baseWidget in base) {
      final baseMinX = baseWidget.x;
      final baseMaxX = baseMinX + baseWidget.width;
      final baseMinY = baseWidget.y;
      final baseMaxY = baseMinY + baseWidget.height;

      if (minX < baseMaxX &&
          maxX > baseMinX &&
          minY < baseMaxY &&
          maxY > baseMinY) {
        _debug('Overlap widget: $baseWidget');
        return baseWidget;
      }
    }

    _debug('No overlap widget for: $widget');
    return null;
  }

  Iterable<DashboardGridChangeSnapshot> _findDifference(
    List<DashboardWidget> from,
    List<DashboardWidget> to,
  ) {
    final fromMap = {for (final w in from) w.id: w};
    final toMap = {for (final w in to) w.id: w};

    final addedWidgets = to.map((toWidget) {
      final isNew = !fromMap.containsKey(toWidget.id);
      if (isNew) {
        return DashboardGridChangeSnapshot(from: null, to: toWidget);
      }

      return null;
    });

    final removedWidgets = from.map((fromWidget) {
      final isRemoved = !toMap.containsKey(fromWidget.id);
      if (isRemoved) {
        return DashboardGridChangeSnapshot(from: fromWidget, to: null);
      }

      return null;
    });

    final movedWidgets = from.map((fromWidget) {
      final toWidget = toMap[fromWidget.id];
      final hasMoved =
          toWidget != null &&
          (fromWidget.x != toWidget.x || fromWidget.y != toWidget.y);

      if (hasMoved) {
        return DashboardGridChangeSnapshot(from: fromWidget, to: toWidget);
      }

      return null;
    });

    return addedWidgets
        .followedBy(removedWidgets)
        .followedBy(movedWidgets)
        .nonNulls;
  }

  void _debug(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /// Creates a copy of this dashboard grid.
  DashboardGrid copy() {
    return DashboardGrid(maxColumns: maxColumns, currentHeight: currentHeight)
      .._widgets = _widgets.map((e) => e.copyWith()).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardGrid &&
          runtimeType == other.runtimeType &&
          maxColumns == other.maxColumns &&
          currentHeight == other.currentHeight &&
          _widgets == other._widgets;

  @override
  int get hashCode =>
      Object.hash(maxColumns, currentHeight, listener, _widgets);
}

/// An exception that is thrown when there is not enough space to add a widget to the dashboard.
class NotEnoughSpaceException implements Exception {
  /// Creates a [NotEnoughSpaceException].
  NotEnoughSpaceException();
}
