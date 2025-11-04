import 'package:flutter/material.dart';

/// A widget to be displayed in the dashboard.
class DashboardWidget {
  /// A unique identifier for the widget.
  final String id;

  /// The x coordinate of the widget in the dashboard.
  final int x;

  /// The y coordinate of the widget in the dashboard.
  final int y;

  /// The width of the widget in the dashboard.
  final int width;

  /// The height of the widget in the dashboard.
  final int height;

  /// A builder for the widget.
  final WidgetBuilder builder;

  /// Creates a dashboard widget.
  DashboardWidget({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.builder,
  }) : assert(width > 0 && height > 0);

  /// Creates a copy of this dashboard widget with the given fields replaced with the new values.
  DashboardWidget copyWith({
    int? x,
    int? y,
    int? width,
    int? height,
    WidgetBuilder? builder,
  }) {
    return DashboardWidget(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      builder: builder ?? this.builder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardWidget &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode =>
      x.hashCode ^ y.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return '{id: $id, x: $x, y: $y, width: $width, height: $height}';
  }
}
