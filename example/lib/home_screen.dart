import 'package:dashboard_grid/dashboard_grid.dart';
import 'package:flutter/material.dart';

final widgetCollection = [
  DashboardWidget(
    id: 'wid1',
    x: 0,
    y: 0,
    width: 1,
    height: 1,
    builder: (context) {
      return Container(
        color: Colors.green,
      );
    },
  ),
  DashboardWidget(
    id: 'wid2',
    x: 0,
    y: 1,
    width: 2,
    height: 1,
    builder: (context) {
      return Container(
        color: Colors.blue,
      );
    },
  ),
  DashboardWidget(
    id: 'wid3',
    x: 1,
    y: 0,
    width: 2,
    height: 1,
    builder: (context) {
      return Container(
        color: Colors.red,
      );
    },
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool editMode = false;
  final yController = ScrollController();
  final xController = ScrollController();
  final dashboardConfig = DashboardGrid(
    maxColumns: 4,
  );

  @override
  void initState() {
    super.initState();
    dashboardConfig.addListener(_configListener);
  }

  @override
  void dispose() {
    dashboardConfig.removeListener(_configListener);
    super.dispose();
  }

  void _configListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Dashboard [col: ${dashboardConfig.maxColumns}, row: ${dashboardConfig.currentHeight}]',
        ),
        actions: [
          if (editMode)
            PopupMenuButton<Offset>(
              icon: const Icon(Icons.add),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: Offset(1, 1),
                    child: Text('1x1'),
                  ),
                  const PopupMenuItem(
                    value: Offset(2, 1),
                    child: Text('2x1'),
                  ),
                  const PopupMenuItem(
                    value: Offset(3, 1),
                    child: Text('3x1'),
                  ),
                  const PopupMenuItem(
                    value: Offset(4, 1),
                    child: Text('4x1'),
                  ),
                  const PopupMenuItem(
                    value: Offset(1, 2),
                    child: Text('1x2'),
                  ),
                ];
              },
              onSelected: (value) {
                final id = 'id${dashboardConfig.size}';
                dashboardConfig.addWidget(
                  DashboardWidget(
                    id: id,
                    x: 0,
                    y: 0,
                    width: value.dx.toInt(),
                    height: value.dy.toInt(),
                    builder: (context) => Container(
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: Text('Widget $id'),
                    ),
                  ),
                );
              },
            ),
          IconButton(
            onPressed: () {
              setState(() {
                editMode = !editMode;
              });
            },
            icon: Icon(editMode ? Icons.check : Icons.edit),
          ),
        ],
      ),
      body: Dashboard(
        editMode: editMode,
        config: dashboardConfig,
        cellPreviewDecoration: TableCellDecoration(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
