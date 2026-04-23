import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:dashboard_grid/src/dev_tools_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDashboardState extends State<Dashboard> implements DashboardState {
  @override
  final Dashboard widget;

  FakeDashboardState(this.widget);

  @override
  Widget build(BuildContext context) => const SizedBox();

  @override
  DashboardGrid? originalConfig;

  @override
  final ScrollController xController = ScrollController();

  @override
  final ScrollController yController = ScrollController();
}

void main() {
  group('DevToolsController', () {
    late Map<
      String,
      Future<developer.ServiceExtensionResponse> Function(
        String,
        Map<String, String>,
      )
    >
    registeredExtensions;
    late List<Map<String, dynamic>> postEvents;

    setUp(() {
      registeredExtensions = {};
      postEvents = [];

      DevToolsController.registerExtension = (name, handler) {
        registeredExtensions[name] = handler;
      };

      DevToolsController.postEvent = (eventKind, eventData) {
        postEvents.add({'kind': eventKind, 'data': eventData});
      };

      DevToolsController.clearStates();
    });

    tearDown(() {
      DevToolsController.clearStates();
      DevToolsController.registerExtension = developer.registerExtension;
      DevToolsController.postEvent = developer.postEvent;
    });

    test(
      'should register ext.dashboard_grid.getConfig extension on creation',
      () {
        final config = DashboardGrid(maxColumns: 2);
        final state = FakeDashboardState(Dashboard(config: config));
        DevToolsController.registerInDevTools(state);

        expect(
          registeredExtensions.containsKey('ext.dashboard_grid.getConfig'),
          isTrue,
        );
      },
    );

    test('getConfig extension should return current config', () async {
      final config = DashboardGrid(maxColumns: 2);
      config.addWidget(
        DashboardWidget(
          id: 'w1',
          x: 0,
          y: 0,
          width: 1,
          height: 1,
          builder: (_) => const SizedBox(),
        ),
      );

      final state = FakeDashboardState(Dashboard(config: config));
      DevToolsController.registerInDevTools(state);

      final handler = registeredExtensions['ext.dashboard_grid.getConfig'];
      expect(handler, isNotNull);
      final response = await handler!('ext.dashboard_grid.getConfig', {});

      expect(response.result, isNotNull);
      final decoded = jsonDecode(response.result!);
      expect(decoded, {
        'grids': [
          {
            'maxColumns': 2,
            'currentHeight': 2,
            'widgets': [
              {'id': 'w1', 'x': 0, 'y': 0, 'width': 1, 'height': 1},
            ],
          },
        ],
      });
    });

    test('should postEvent when config changes', () {
      final config = DashboardGrid(maxColumns: 2);
      final state = FakeDashboardState(Dashboard(config: config));

      DevToolsController.registerInDevTools(state);

      expect(postEvents, isEmpty);

      config.addWidget(
        DashboardWidget(
          id: 'w1',
          x: 0,
          y: 0,
          width: 1,
          height: 1,
          builder: (_) => const SizedBox(),
        ),
      );

      expect(postEvents.length, 1);
      final event = postEvents.first;
      expect(event['kind'], 'ext.dashboard_grid.configUpdate');

      final data = event['data'] as Map<String, dynamic>;
      expect((data['grids'] as List).length, 1);
      final gridData = (data['grids'] as List).first as Map<String, dynamic>;
      expect(gridData['maxColumns'], 2);
      expect((gridData['widgets'] as List).length, 1);
      expect((gridData['widgets'] as List).first['id'], 'w1');
    });

    test('should stop posting events when unregistered', () {
      final config = DashboardGrid(maxColumns: 2);
      final state = FakeDashboardState(Dashboard(config: config));

      DevToolsController.registerInDevTools(state);
      DevToolsController.unregisterInDevTools(state);

      config.addWidget(
        DashboardWidget(
          id: 'w1',
          x: 0,
          y: 0,
          width: 1,
          height: 1,
          builder: (_) => const SizedBox(),
        ),
      );

      expect(postEvents, isEmpty);
    });

    test('clearStates should stop all listeners', () {
      final config = DashboardGrid(maxColumns: 2);
      final state = FakeDashboardState(Dashboard(config: config));

      DevToolsController.registerInDevTools(state);
      DevToolsController.clearStates();

      config.addWidget(
        DashboardWidget(
          id: 'w1',
          x: 0,
          y: 0,
          width: 1,
          height: 1,
          builder: (_) => const SizedBox(),
        ),
      );

      expect(postEvents, isEmpty);
    });
  });
}
