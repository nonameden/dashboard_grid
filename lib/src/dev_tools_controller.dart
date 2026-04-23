import 'dart:convert';
import 'dart:developer' as developer;

import 'package:meta/meta.dart';

import '../dashboard_grid.dart';

@visibleForTesting
typedef RegisterExtensionCallback =
    void Function(
      String name,
      Future<developer.ServiceExtensionResponse> Function(
        String method,
        Map<String, String> parameters,
      )
      handler,
    );

@visibleForTesting
typedef PostEventCallback =
    void Function(String eventKind, Map<String, dynamic> eventData);

class DevToolsController {
  @visibleForTesting
  static RegisterExtensionCallback registerExtension =
      developer.registerExtension;

  @visibleForTesting
  static PostEventCallback postEvent = developer.postEvent;

  final List<DashboardState> _states = [];

  DevToolsController._();

  static final _instance = DevToolsController._();

  static bool _extensionRegistered = false;

  static void _ensureExtensionRegistered() {
    if (!_extensionRegistered) {
      registerExtension('ext.dashboard_grid.getConfig', (
        method,
        parameters,
      ) async {
        final data = _instance._getConfig();

        return developer.ServiceExtensionResponse.result(jsonEncode(data));
      });
      _extensionRegistered = true;
    }
  }

  static void registerInDevTools(DashboardState state) {
    _ensureExtensionRegistered();
    _instance._states.add(state);
    state.widget.config.addListener(_instance._configChangeListener);
  }

  static void unregisterInDevTools(DashboardState state) {
    _instance._states.remove(state);
    state.widget.config.removeListener(_instance._configChangeListener);
  }

  @visibleForTesting
  static void clearStates() {
    for (final state in _instance._states) {
      state.widget.config.removeListener(_instance._configChangeListener);
    }
    _instance._states.clear();
    _extensionRegistered = false;
  }

  void _configChangeListener() {
    final data = _getConfig();

    try {
      postEvent('ext.dashboard_grid.configUpdate', data);
      developer.log('Posting DashboardGrid config change');
    } catch (e) {
      developer.log('Error posting DashboardGrid config change: $e');
    }
  }

  Map<String, dynamic> _getConfig() {
    final data =
        _states.map((s) => s.widget.config).map((config) {
          return {
            'maxColumns': config.maxColumns,
            'currentHeight': config.currentHeight,
            'widgets':
                config.widgets.map((w) {
                  return {
                    'id': w.id,
                    'x': w.x,
                    'y': w.y,
                    'width': w.width,
                    'height': w.height,
                  };
                }).toList(),
          };
        }).toList();

    return {'grids': data};
  }
}
