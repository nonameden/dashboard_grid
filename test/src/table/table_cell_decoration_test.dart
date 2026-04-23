import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dashboard_grid/src/table/table_cell_decoration.dart';

class FakeCanvas extends Fake implements Canvas {}

class FakePaintingContext extends Fake implements PaintingContext {
  FakePaintingContext(this.canvas);
  @override
  final Canvas canvas;
}

class MockBoxPainter extends BoxPainter {
  int paintCallCount = 0;
  Canvas? lastCanvas;
  Offset? lastOffset;
  ImageConfiguration? lastConfiguration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    paintCallCount++;
    lastCanvas = canvas;
    lastOffset = offset;
    lastConfiguration = configuration;
  }
}

class MockDecoration extends Decoration {
  final BoxPainter painter;
  MockDecoration(this.painter);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => painter;
}

void main() {
  group('TableCellDecoration', () {
    test('default constructor provides default decoration', () {
      const decoration = TableCellDecoration();
      expect(decoration.decoration, isA<BoxDecoration>());
      final boxDecoration = decoration.decoration as BoxDecoration;
      expect(boxDecoration.color, Colors.grey);
      expect(
        boxDecoration.borderRadius,
        const BorderRadius.all(Radius.circular(10)),
      );
      expect(boxDecoration.border, const Border());
    });

    test('paint uses decoration to paint correctly', () {
      final painter = MockBoxPainter();
      final decoration = MockDecoration(painter);
      final cellDecoration = TableCellDecoration(decoration: decoration);

      final canvas = FakeCanvas();
      final context = FakePaintingContext(canvas);
      const rect = Rect.fromLTWH(10, 20, 100, 200);

      cellDecoration.paint(context, rect);

      expect(painter.paintCallCount, 1);
      expect(painter.lastCanvas, canvas);
      expect(painter.lastOffset, const Offset(10, 20));
      expect(painter.lastConfiguration?.size, const Size(100, 200));
    });

    test('equality and hashCode', () {
      const decoration1 = TableCellDecoration(
        decoration: BoxDecoration(color: Colors.red),
      );
      const decoration2 = TableCellDecoration(
        decoration: BoxDecoration(color: Colors.red),
      );
      const decoration3 = TableCellDecoration(
        decoration: BoxDecoration(color: Colors.blue),
      );

      expect(decoration1, equals(decoration2));
      expect(decoration1.hashCode, equals(decoration2.hashCode));

      expect(decoration1, isNot(equals(decoration3)));
      expect(decoration1.hashCode, isNot(equals(decoration3.hashCode)));
    });
  });
}
