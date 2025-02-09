import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_reports/src/models/asset_tailmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_tailmap_report.dart';
import 'package:il_ws/il_ws.dart';

class AssetTailmapReportGenerator implements IAssetReportGenerator {
  final IAssetPositionHistoryService positionHistoryService;

  AssetTailmapReportGenerator({
    required this.positionHistoryService,
  });

  @override
  String getReportName() {
    return 'Tailmap report';
  }

  @override
  Widget buildGenerateReportButton({required VoidCallback onTap}) {
    return OutlinedButton.icon(
      onPressed: () => onTap(),
      icon: const FaIcon(FontAwesomeIcons.mapLocationDot),
      label: const Text('Generate tailmap report'),
    );
  }

  @override
  Widget buildWidget(BuildContext context, data) {
    return AssetTailmapReportWidget(data: data);
  }

  @override
  Future generateData({
    required Asset asset,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    var positionHistory = await positionHistoryService.getPositionHistory(
      assetId: asset.id,
      floorMapId: asset.floorMap!.id,
      startDate: startDate,
      endDate: endDate,
    );

    if (positionHistory.isEmpty) {
      throw AppException('Cannot generate tailmap report because there is no available data.');
    }

    positionHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return AssetTailmapData(
      asset: asset,
      startDate: positionHistory.first.timestamp,
      endDate: positionHistory.last.timestamp,
      positionHistory: positionHistory,
    );
  }
}
