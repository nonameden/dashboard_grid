import 'package:flutter/material.dart';

class DashboardWidget {
  final String id;
  final int x;
  final int y;
  final int width;
  final int height;
  final WidgetBuilder builder;

  DashboardWidget({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.builder,
  }) : assert(width > 0 && height > 0);

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
