import 'dart:async';

import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

void main() {
  runApp(const DevToolsExtension(child: DashboardGridDevToolsExtension()));
}

class DashboardGridDevToolsExtension extends StatefulWidget {
  const DashboardGridDevToolsExtension({super.key});

  @override
  State<DashboardGridDevToolsExtension> createState() =>
      _DashboardGridDevToolsExtensionState();
}

class _DashboardGridDevToolsExtensionState
    extends State<DashboardGridDevToolsExtension> {
  Map<String, dynamic>? message;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());

    serviceManager.onServiceAvailable.then((service) {
      subscription = service.onExtensionEvent.listen((event) {
        if (event.extensionKind == 'ext.dashboard_grid.configUpdate') {
          setState(() {
            message = event.extensionData?.data;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Grid DevTools Extension'),
        actions: [
          IconButton(
            onPressed: () {
              _refresh();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: denseSpacing),
        child: JsonView.map(message ?? {'message': 'No message received yet'}),
      ),
    );
  }

  Future<void> _refresh() async {
    serviceManager.onServiceAvailable.then((service) async {
      try {
        final response = await service.callServiceExtension(
          'ext.dashboard_grid.getConfig',
        );

        setState(() {
          message = response.json;
        });
      } catch (e, stackTrace) {
        setState(() {
          message = {
            'message:': 'Error fetching data',
            'error': e.toString(),
            'stackTrace': stackTrace.toString(),
          };
        });
      }
    });
  }
}
