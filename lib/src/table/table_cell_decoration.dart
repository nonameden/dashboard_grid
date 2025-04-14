import 'package:flutter/material.dart';

class TableCellDecoration {

  final Decoration decoration;

  const TableCellDecoration({
    this.decoration = const BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border(),
    ),
  });

  void paint(
      PaintingContext context,
      Rect rect,
  ) {
    final painter = decoration.createBoxPainter();
    painter.paint(context.canvas, rect.topLeft, ImageConfiguration(size: rect.size));
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