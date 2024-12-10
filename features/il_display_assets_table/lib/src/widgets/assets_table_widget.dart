import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';

class AssetsTableWidget extends StatelessWidget {
  final List<Asset> assets;

  const AssetsTableWidget({
    super.key,
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    for (var asset in assets) {
      children.add(Row(
        children: [
          Expanded(child: Text(asset.name)),
          Expanded(child: Text('${asset.x.round()}')),
          Expanded(child: Text('${asset.y.round()}')),
          Expanded(child: Text('Zone')),
        ],
      ));
      children.add(const Divider());
    }

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
        rows: assets.map((e) {
          return DataRow(cells: [
            DataCell(Text(e.name)),
            DataCell(Text('${e.x.round()}')),
            DataCell(Text('${e.y.round()}')),
            DataCell(Text('Zone 1')),
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
