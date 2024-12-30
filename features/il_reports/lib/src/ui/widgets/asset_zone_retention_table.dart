import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_reports/src/models/asset_zone_retention_data.dart';

class AssetZoneRetentionTable extends StatelessWidget {
  final AssetZoneRetentionReportData data;

  const AssetZoneRetentionTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var dataTable = DataTable(
      horizontalMargin: 0,
      columnSpacing: 20,
      columns: const [
        DataColumn(
          label: Text('Zone'),
          headingRowAlignment: MainAxisAlignment.center,
        ),
        DataColumn(
          label: Text('Enter date'),
          headingRowAlignment: MainAxisAlignment.center,
        ),
        DataColumn(
          label: Text('Exit date'),
          headingRowAlignment: MainAxisAlignment.center,
        ),
        DataColumn(
          label: Text('Retention'),
          headingRowAlignment: MainAxisAlignment.center,
        ),
      ],
      rows: data.zoneHistoryData.map((e) => getDataRow(e)).toList(),
    );

    return Row(
      children: [
        Expanded(
          child: dataTable,
        ),
      ],
    );
  }

  DataRow getDataRow(AssetZoneHistory zoneHistory) {
    var enterDateTime = DateFormats.dateTime.format(zoneHistory.enterDateTime);
    var exitDateTime = DateFormats.dateTime.format(zoneHistory.exitDateTime);
    var retention = DateFormats.formatDuration(zoneHistory.retentionTime);

    return DataRow(
      cells: [
        DataCell(Text(zoneHistory.zone?.name ?? '', textAlign: TextAlign.center)),
        DataCell(Text(enterDateTime, textAlign: TextAlign.center)),
        DataCell(Text(exitDateTime, textAlign: TextAlign.center)),
        DataCell(Text(retention, textAlign: TextAlign.center)),
      ],
    );
  }
}
