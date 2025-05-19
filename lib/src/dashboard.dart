import 'package:dashboard_grid/src/table/table_span.dart';
import 'package:flutter/material.dart';

import 'common/constants.dart';
import 'common/span.dart';
import 'dashboard_grid.dart';
import 'dashboard_widget.dart';
import 'dev_tools_controller.dart';
import 'table/table.dart';
import 'table/table_cell.dart';
import 'table/table_cell_decoration.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
    this.editMode = false,
    this.widgetWidth = kWidgetWidth,
    this.widgetHeight = kWidgetHeight,
    this.widgetSpacing = kWidgetSpacing,
    required this.config,
    this.cellPreviewDecoration = const TableCellDecoration(),
  });

  final bool editMode;
  final DashboardGrid config;
  final double widgetWidth;
  final double widgetHeight;
  final double widgetSpacing;
  final TableCellDecoration cellPreviewDecoration;

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final yController = ScrollController();
  final xController = ScrollController();

  DashboardGrid? originalConfig;

  @override
  void initState() {
    widget.config.addListener(_configListener);
    DevToolsController.registerInDevTools(this);

    super.initState();
  }

  @override
  void dispose() {
    DevToolsController.unregisterInDevTools(this);
    widget.config.removeListener(_configListener);
    yController.dispose();
    xController.dispose();

    super.dispose();
  }

  void _configListener() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant Dashboard oldWidget) {
    if (oldWidget.config != widget.config) {
      oldWidget.config.removeListener(_configListener);
      widget.config.addListener(_configListener);
    }

    if (oldWidget.editMode != widget.editMode) {
      setState(() {
        if (widget.editMode) {
          // Do. copy of original config
          originalConfig = widget.config.copy();
        } else {
          // Do. restore original config
          if (originalConfig != null) {
            originalConfig = null;
          }
        }
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.right,
      controller: yController,
      child: Scrollbar(
        trackVisibility: true,
        thumbVisibility: true,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        controller: xController,
        child: TableView.builder(
          columnCount: widget.config.maxColumns,
          rowCount: widget.config.currentHeight,
          verticalDetails: ScrollableDetails.vertical(controller: yController),
          horizontalDetails: ScrollableDetails.horizontal(
            controller: xController,
          ),
          cellBuilder: (BuildContext context, TableVicinity vicinity) {
            final cell = _findBestCellMatch(vicinity);
            if (cell != null) {
              return cell;
            } else {
              // Empty space
              if (widget.editMode) {
                return TableViewCell(
                  child: DragTarget<DashboardWidget>(
                    builder: (context, accepted, rejected) {
                      return Container();
                    },
                    onAcceptWithDetails: (details) {
                      try {
                        widget.config.moveWidget(
                          details.data.id,
                          x: vicinity.xIndex,
                          y: vicinity.yIndex,
                        );
                      } on NotEnoughSpaceException {
                        // Oops
                      } catch (e) {
                        rethrow;
                      }

                      setState(() {});
                    },
                  ),
                );
              } else {
                return const TableViewCell(child: SizedBox.shrink());
              }
            }
          },
          columnBuilder: _buildColumnSpan,
          rowBuilder: _buildRowSpan,
          cellDecoration: widget.cellPreviewDecoration,
          editMode: widget.editMode,
        ),
      ),
    );
  }

  TableViewCell? _findBestCellMatch(TableVicinity vicinity) {
    final config = widget.config.getWidgetAt(
      x: vicinity.xIndex,
      y: vicinity.yIndex,
    );
    if (config == null) return null;

    BoxConstraints constraints = BoxConstraints.expand(
      width:
          widget.widgetWidth * config.width +
          widget.widgetSpacing * (config.width - 1),
      height:
          widget.widgetHeight * config.height +
          widget.widgetSpacing * (config.height - 1),
    );

    final child =
        widget.editMode
            ? Draggable(
              data: config,
              feedback: Builder(
                builder: (context) {
                  return ConstrainedBox(
                    constraints: constraints,
                    child: config.builder(context),
                  );
                },
              ),
              childWhenDragging: Builder(
                builder: (context) {
                  return DragTarget<DashboardWidget>(
                    builder: (context, candidate, rejected) {
                      return Opacity(
                        opacity: 0.5,
                        child: ConstrainedBox(
                          constraints: constraints,
                          child: config.builder(context),
                        ),
                      );
                    },
                    onAcceptWithDetails: (details) {
                      // Move inside the same widget
                      final offset = details.offset;
                      // Translate to indexes
                      final ix =
                          offset.dx /
                          (widget.widgetWidth +
                              widget.widgetSpacing / (config.width - 1));
                      final iy =
                          offset.dy /
                          (widget.widgetHeight +
                              widget.widgetSpacing / (config.height - 1));

                      try {
                        widget.config.moveWidget(
                          details.data.id,
                          x: vicinity.xIndex + ix.floor(),
                          y: vicinity.yIndex + iy.floor(),
                        );

                        setState(() {});
                      } on NotEnoughSpaceException {
                        // Oops
                      } catch (e) {
                        rethrow;
                      }
                    },
                  );
                },
              ),
              child: DragTarget<DashboardWidget>(
                builder: (context, candidate, rejected) {
                  return config.builder(context);
                },
                onAcceptWithDetails: (details) {
                  try {
                    widget.config.moveWidget(
                      details.data.id,
                      x: vicinity.xIndex,
                      y: vicinity.yIndex,
                    );

                    setState(() {});
                  } on NotEnoughSpaceException {
                    // Oops
                  } catch (e) {
                    rethrow;
                  }
                },
              ),
              onDragUpdate: (details) {
                // Update details
              },
            )
            : config.builder(context);

    return TableViewCell(
      columnMergeStart: config.x,
      columnMergeSpan: config.width,
      rowMergeStart: config.y,
      rowMergeSpan: config.height,
      child: child,
    );
  }

  TableSpan _buildColumnSpan(int index) {
    return TableSpan(
      padding: SpanPadding(
        leading: widget.widgetSpacing,
        trailing: widget.config.maxColumns - 1 == index ? kWidgetSpacing : 0.0,
      ),
      extent: FixedTableSpanExtent(widget.widgetWidth),
    );
  }

  TableSpan _buildRowSpan(int index) {
    return TableSpan(
      padding: SpanPadding(
        leading: widget.widgetSpacing,
        trailing:
            widget.config.currentHeight - 1 == index ? kWidgetSpacing : 0.0,
      ),
      extent: FixedTableSpanExtent(widget.widgetHeight),
    );
  }
}
