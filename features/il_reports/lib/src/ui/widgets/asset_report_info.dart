import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';

class AssetReportInfo extends StatelessWidget {
  final Asset asset;
  final DateTime startDate;
  final DateTime endDate;

  const AssetReportInfo({
    super.key,
    required this.asset,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    var bodyTextStyle = Theme.of(context).textTheme.bodyLarge;

    var startDate = DateFormats.dateTime.format(this.startDate);
    var endDate = DateFormats.dateTime.format(this.endDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(asset.name, style: Theme.of(context).textTheme.titleLarge),
        Text('Start date: $startDate', style: bodyTextStyle),
        Text('End date: $endDate', style: bodyTextStyle),
      ],
    );
  }
}
