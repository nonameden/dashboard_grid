import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dashboard_grid/src/table/table_delegate.dart';
import 'package:dashboard_grid/src/table/table_cell.dart';
import 'package:dashboard_grid/src/table/table_cell_decoration.dart';
import 'package:dashboard_grid/src/table/table_span.dart';
import 'package:dashboard_grid/src/table/table.dart';

void main() {
  group('TableCellBuilderDelegate', () {
    late TableCellBuilderDelegate delegate;
    int buildCellCount = 0;
    int buildColumnCount = 0;
    int buildRowCount = 0;

    setUp(() {
      buildCellCount = 0;
      buildColumnCount = 0;
      buildRowCount = 0;
      delegate = TableCellBuilderDelegate(
        columnCount: 10,
        rowCount: 10,
        cellBuilder: (context, vicinity) {
          buildCellCount++;
          return TableViewCell(child: Text('cell $vicinity'));
        },
        columnBuilder: (index) {
          buildColumnCount++;
          return const TableSpan(extent: FixedTableSpanExtent(100));
        },
        rowBuilder: (index) {
          buildRowCount++;
          return const TableSpan(extent: FixedTableSpanExtent(100));
        },
        cellDecoration: const TableCellDecoration(),
        editMode: false,
      );
    });

    test('columnCount setter updates maxXIndex and respects pinnedColumnCount', () {
      delegate.columnCount = 20;
      expect(delegate.columnCount, 20);
      // maxXIndex is private in TwoDimensionalChildBuilderDelegate, but we can check columnCount

      delegate.pinnedColumnCount = 5;
      expect(() => delegate.columnCount = 4, throwsAssertionError);
      expect(() => delegate.columnCount = 5, returnsNormally);
      expect(delegate.columnCount, 5);
    });

    test('rowCount setter updates maxYIndex and respects pinnedRowCount', () {
      delegate.rowCount = 20;
      expect(delegate.rowCount, 20);

      delegate.pinnedRowCount = 5;
      expect(() => delegate.rowCount = 4, throwsAssertionError);
      expect(() => delegate.rowCount = 5, returnsNormally);
      expect(delegate.rowCount, 5);
    });

    test('columnCount and rowCount can be null', () {
      delegate.columnCount = null;
      expect(delegate.columnCount, isNull);

      delegate.rowCount = null;
      expect(delegate.rowCount, isNull);
    });

    test('pinnedColumnCount setter updates value and notifies listeners', () {
      int notifyCount = 0;
      delegate.addListener(() {
        notifyCount++;
      });

      delegate.pinnedColumnCount = 5;
      expect(delegate.pinnedColumnCount, 5);
      expect(notifyCount, 1);

      // Setting same value should not notify
      delegate.pinnedColumnCount = 5;
      expect(notifyCount, 1);

      expect(() => delegate.pinnedColumnCount = -1, throwsAssertionError);
      expect(() => delegate.pinnedColumnCount = 11, throwsAssertionError);
    });

    test('pinnedRowCount setter updates value and notifies listeners', () {
      int notifyCount = 0;
      delegate.addListener(() {
        notifyCount++;
      });

      delegate.pinnedRowCount = 5;
      expect(delegate.pinnedRowCount, 5);
      expect(notifyCount, 1);

      // Setting same value should not notify
      delegate.pinnedRowCount = 5;
      expect(notifyCount, 1);

      expect(() => delegate.pinnedRowCount = -1, throwsAssertionError);
      expect(() => delegate.pinnedRowCount = 11, throwsAssertionError);
    });
  });

  group('TableCellListDelegate', () {
    late TableCellListDelegate delegate;

    setUp(() {
      final cells = List.generate(
        3,
        (r) => List.generate(
          3,
          (c) => TableViewCell(child: Text('$r,$c')),
        ),
      );
      delegate = TableCellListDelegate(
        cells: cells,
        columnBuilder: (index) => const TableSpan(extent: FixedTableSpanExtent(100)),
        rowBuilder: (index) => const TableSpan(extent: FixedTableSpanExtent(100)),
      );
    });

    test('pinnedColumnCount setter updates value and notifies listeners', () {
      int notifyCount = 0;
      delegate.addListener(() {
        notifyCount++;
      });

      delegate.pinnedColumnCount = 2;
      expect(delegate.pinnedColumnCount, 2);
      expect(notifyCount, 1);

      // Setting same value should not notify
      delegate.pinnedColumnCount = 2;
      expect(notifyCount, 1);

      expect(() => delegate.pinnedColumnCount = -1, throwsAssertionError);
      expect(() => delegate.pinnedColumnCount = 4, throwsAssertionError);
    });

    test('pinnedRowCount setter updates value and notifies listeners', () {
      int notifyCount = 0;
      delegate.addListener(() {
        notifyCount++;
      });

      delegate.pinnedRowCount = 2;
      expect(delegate.pinnedRowCount, 2);
      expect(notifyCount, 1);

      // Setting same value should not notify
      delegate.pinnedRowCount = 2;
      expect(notifyCount, 1);

      expect(() => delegate.pinnedRowCount = -1, throwsAssertionError);
      expect(() => delegate.pinnedRowCount = 4, throwsAssertionError);
    });
  });
}
