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
      columnSpacing: 10,
      columns: const [
        DataColumn(label: Text('Zone')),
        DataColumn(label: Text('Enter date')),
        DataColumn(label: Text('Exit date')),
        DataColumn(label: Text('Retention')),
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
        DataCell(Text(zoneHistory.zone?.name ?? '')),
        DataCell(Text(enterDateTime)),
        DataCell(Text(exitDateTime)),
        DataCell(Text(retention)),
      ],
    );
  }
}
