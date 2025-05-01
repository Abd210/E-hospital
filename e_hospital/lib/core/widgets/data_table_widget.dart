import 'package:flutter/material.dart';
import 'package:e_hospital/theme/app_theme.dart';

class DataTableWidget extends StatefulWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final Function(Map<String, dynamic>)? onRowTap;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onDelete;
  final bool isLoading;
  final String? emptyMessage;
  final List<DataColumn> Function(List<String>)? customColumns;
  final List<DataCell> Function(Map<String, dynamic>)? customCells;
  final bool showActions;
  final double maxHeight;

  const DataTableWidget({
    Key? key,
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
    this.emptyMessage,
    this.customColumns,
    this.customCells,
    this.showActions = true,
    this.maxHeight = 500,
  }) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  int _rowsPerPage = 10;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.rows.isEmpty) {
      return Center(
        child: Text(
          widget.emptyMessage ?? 'No data available',
          style: const TextStyle(
            color: AppColors.neutral,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final columns = widget.customColumns != null
        ? widget.customColumns!(widget.columns)
        : widget.columns.map((column) {
            return DataColumn(
              label: Text(
                column,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onSort: (columnIndex, ascending) {
                _sort(columnIndex, ascending, column);
              },
            );
          }).toList();

    if (widget.showActions && (widget.onEdit != null || widget.onDelete != null)) {
      columns.add(const DataColumn(
        label: Text(
          'Actions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight,
        ),
        child: SingleChildScrollView(
          child: PaginatedDataTable(
            columns: columns,
            source: _DataSource(
              context: context,
              rows: widget.rows,
              columns: widget.columns,
              onRowTap: widget.onRowTap,
              onEdit: widget.onEdit,
              onDelete: widget.onDelete,
              customCells: widget.customCells,
              showActions: widget.showActions,
            ),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: const [5, 10, 20, 50],
            onRowsPerPageChanged: (value) {
              setState(() {
                _rowsPerPage = value!;
              });
            },
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            showCheckboxColumn: false,
            horizontalMargin: 24,
            columnSpacing: 30,
          ),
        ),
      ),
    );
  }

  void _sort(int columnIndex, bool ascending, String column) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      widget.rows.sort((a, b) {
        final aValue = a[column];
        final bValue = b[column];

        if (aValue == null && bValue == null) {
          return 0;
        }

        if (aValue == null) {
          return ascending ? -1 : 1;
        }

        if (bValue == null) {
          return ascending ? 1 : -1;
        }

        if (aValue is num && bValue is num) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        if (aValue is String && bValue is String) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        if (aValue is DateTime && bValue is DateTime) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }

        return 0;
      });
    });
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> rows;
  final List<String> columns;
  final Function(Map<String, dynamic>)? onRowTap;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onDelete;
  final List<DataCell> Function(Map<String, dynamic>)? customCells;
  final bool showActions;

  _DataSource({
    required this.context,
    required this.rows,
    required this.columns,
    this.onRowTap,
    this.onEdit,
    this.onDelete,
    this.customCells,
    this.showActions = true,
  });

  @override
  DataRow getRow(int index) {
    final row = rows[index];
    
    final cells = customCells != null
        ? customCells!(row)
        : columns.map((column) {
            final value = row[column];
            String displayText = '';

            if (value == null) {
              displayText = '-';
            } else if (value is DateTime) {
              displayText = '${value.day}/${value.month}/${value.year}';
            } else {
              displayText = value.toString();
            }

            return DataCell(
              Text(displayText),
            );
          }).toList();

    if (showActions && (onEdit != null || onDelete != null)) {
      cells.add(
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEdit != null)
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  onPressed: () {
                    onEdit!(row);
                  },
                ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.error,
                    size: 20,
                  ),
                  onPressed: () {
                    onDelete!(row);
                  },
                ),
            ],
          ),
        ),
      );
    }

    return DataRow(
      cells: cells,
      onSelectChanged: onRowTap != null
          ? (_) {
              onRowTap!(row);
            }
          : null,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
} 