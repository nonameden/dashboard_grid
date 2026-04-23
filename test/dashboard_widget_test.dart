import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardWidget.copyWith', () {
    late DashboardWidget originalWidget;
    late WidgetBuilder originalBuilder;

    setUp(() {
      originalBuilder = (context) => Container();
      originalWidget = DashboardWidget(
        id: 'id1',
        x: 0,
        y: 1,
        width: 2,
        height: 3,
        builder: originalBuilder,
      );
    });

    test('should return an identical copy when called without arguments', () {
      final copy = originalWidget.copyWith();

      expect(copy.id, equals(originalWidget.id));
      expect(copy.x, equals(originalWidget.x));
      expect(copy.y, equals(originalWidget.y));
      expect(copy.width, equals(originalWidget.width));
      expect(copy.height, equals(originalWidget.height));
      expect(copy.builder, equals(originalWidget.builder));

      // Also verify equality operator and hashCode
      expect(copy, equals(originalWidget));
      expect(copy.hashCode, equals(originalWidget.hashCode));
    });

    test('should update x coordinate when specified', () {
      final copy = originalWidget.copyWith(x: 5);

      expect(copy.id, equals(originalWidget.id));
      expect(copy.x, equals(5));
      expect(copy.y, equals(originalWidget.y));
      expect(copy.width, equals(originalWidget.width));
      expect(copy.height, equals(originalWidget.height));
      expect(copy.builder, equals(originalWidget.builder));

      expect(copy, isNot(equals(originalWidget)));
    });

    test('should update y coordinate when specified', () {
      final copy = originalWidget.copyWith(y: 6);

      expect(copy.id, equals(originalWidget.id));
      expect(copy.x, equals(originalWidget.x));
      expect(copy.y, equals(6));
      expect(copy.width, equals(originalWidget.width));
      expect(copy.height, equals(originalWidget.height));
      expect(copy.builder, equals(originalWidget.builder));

      expect(copy, isNot(equals(originalWidget)));
    });

    test('should update width when specified', () {
      final copy = originalWidget.copyWith(width: 7);

      expect(copy.id, equals(originalWidget.id));
      expect(copy.x, equals(originalWidget.x));
      expect(copy.y, equals(originalWidget.y));
      expect(copy.width, equals(7));
      expect(copy.height, equals(originalWidget.height));
      expect(copy.builder, equals(originalWidget.builder));

      expect(copy, isNot(equals(originalWidget)));
    });

    test('should update height when specified', () {
      final copy = originalWidget.copyWith(height: 8);

      expect(copy.id, equals(originalWidget.id));
      expect(copy.x, equals(originalWidget.x));
      expect(copy.y, equals(originalWidget.y));
      expect(copy.width, equals(originalWidget.width));
      expect(copy.height, equals(8));
      expect(copy.builder, equals(originalWidget.builder));

      expect(copy, isNot(equals(originalWidget)));
    });

    test('should update builder when specified', () {
      final WidgetBuilder newBuilder = (context) => const SizedBox();
      final copy = originalWidget.copyWith(builder: newBuilder);

      expect(copy.id, equals(originalWidget.id));
      expect(copy.x, equals(originalWidget.x));
      expect(copy.y, equals(originalWidget.y));
      expect(copy.width, equals(originalWidget.width));
      expect(copy.height, equals(originalWidget.height));
      expect(copy.builder, equals(newBuilder));

      // Note: equality operator for DashboardWidget doesn't check builder,
      // so we use equals which relies on id, x, y, width, height.
      expect(copy, equals(originalWidget));
    });

    test('should update multiple fields when specified simultaneously', () {
      final WidgetBuilder newBuilder = (context) => const SizedBox();
      final copy = originalWidget.copyWith(
        x: 10,
        y: 11,
        width: 12,
        height: 13,
        builder: newBuilder,
      );

      expect(copy.id, equals(originalWidget.id)); // id should remain unchanged
      expect(copy.x, equals(10));
      expect(copy.y, equals(11));
      expect(copy.width, equals(12));
      expect(copy.height, equals(13));
      expect(copy.builder, equals(newBuilder));

      expect(copy, isNot(equals(originalWidget)));
    });
  });
}
