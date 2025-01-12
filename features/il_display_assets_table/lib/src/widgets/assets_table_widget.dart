import 'package:flutter/material.dart';
import 'package:il_display_assets_table/src/models/asset_info.dart';

class AssetsTableWidget extends StatelessWidget {
  final List<AssetInfo> assetData;

  const AssetsTableWidget({
    super.key,
    required this.assetData,
  });

  @override
  Widget build(BuildContext context) {
    var dataTable = DataTable(
        horizontalMargin: 0,
        columnSpacing: 20,
        headingRowHeight: 40,
        dataRowMinHeight: 40,
        dataRowMaxHeight: 40,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('X')),
          DataColumn(label: Text('Y')),
          DataColumn(label: Text('Zone')),
        ],
        rows: assetData.map((e) {
          return DataRow(cells: [
            DataCell(Text(e.name)),
            DataCell(Text('${e.x.round()}')),
            DataCell(Text('${e.y.round()}')),
            DataCell(Text(e.zone)),
          ]);
        }).toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assets', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: dataTable,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
