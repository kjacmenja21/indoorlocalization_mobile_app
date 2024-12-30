import 'package:flutter/material.dart';
import 'package:il_reports/src/models/asset_zone_retention_data.dart';
import 'package:il_reports/src/ui/widgets/asset_report_info.dart';
import 'package:il_reports/src/ui/widgets/asset_zone_retention_table.dart';

class AssetZoneRetentionReportWidget extends StatelessWidget {
  final AssetZoneRetentionReportData data;

  const AssetZoneRetentionReportWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssetReportInfo(
          asset: data.asset,
          startDate: data.startDate,
          endDate: data.endDate,
        ),
        const SizedBox(height: 20),
        AssetZoneRetentionTable(data: data),
      ],
    );
  }
}
