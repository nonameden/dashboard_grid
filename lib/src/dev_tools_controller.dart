import 'dart:convert';
import 'dart:developer';

import '../dashboard_grid.dart';

class DevToolsController {
  final List<DashboardState> _states = [];

  DevToolsController._() {
    registerExtension('ext.dashboard_grid.getConfig', (
      method,
      parameters,
    ) async {
      final data = _getConfig();

      return ServiceExtensionResponse.result(jsonEncode(data));
    });
  }

  static final _instance = DevToolsController._();

  static void registerInDevTools(DashboardState state) {
    _instance._states.add(state);
    state.widget.config.addListener(_instance._configChangeListener);
  }

  static void unregisterInDevTools(DashboardState state) {
    _instance._states.remove(state);
    state.widget.config.removeListener(_instance._configChangeListener);
  }

  void _configChangeListener() {
    final data = _getConfig();

    try {
      postEvent('ext.dashboard_grid.configUpdate', data);
      log('Posting DashboardGrid config change');
    } catch (e) {
      log('Error posting DashboardGrid config change: $e');
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
