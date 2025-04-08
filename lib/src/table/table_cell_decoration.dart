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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableCellDecoration &&
          runtimeType == other.runtimeType &&
          decoration == other.decoration;

  @override
  int get hashCode => decoration.hashCode;
}