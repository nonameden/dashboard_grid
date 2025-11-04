import 'package:flutter/material.dart';

/// A decoration for a table cell.
class TableCellDecoration {
  /// The decoration to paint.
  final Decoration decoration;

  /// Creates a table cell decoration.
  const TableCellDecoration({
    this.decoration = const BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border(),
    ),
  });

  /// Paints the decoration.
  void paint(PaintingContext context, Rect rect) {
    final painter = decoration.createBoxPainter();
    painter.paint(
      context.canvas,
      rect.topLeft,
      ImageConfiguration(size: rect.size),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableCellDecoration &&
          runtimeType == other.runtimeType &&
          decoration == other.decoration;

  @override
  int get hashCode => decoration.hashCode;
}
