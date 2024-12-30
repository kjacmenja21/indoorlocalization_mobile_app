import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_reports/src/logic/asset_zone_retention_data_generator.dart';
import 'package:il_reports/src/ui/widgets/asset_zone_retention_report.dart';
import 'package:il_ws/il_ws.dart';

class AssetZoneRetentionTimeReportGenerator implements IAssetReportGenerator {
  final IAssetPositionHistoryService positionHistoryService;
  final IFloorMapService floorMapService;

  AssetZoneRetentionTimeReportGenerator({
    required this.positionHistoryService,
    required this.floorMapService,
  });

  @override
  String getReportName() {
    return 'Zone retention report';
  }

  @override
  Widget buildGenerateReportButton({required VoidCallback onTap}) {
    return OutlinedButton.icon(
      onPressed: () => onTap(),
      icon: const FaIcon(FontAwesomeIcons.chartPie),
      label: const Text('Generate zone retention report'),
    );
  }

  @override
  Widget buildWidget(BuildContext context, data) {
    return AssetZoneRetentionReportWidget(data: data);
  }

  @override
  Future generateData({required Asset asset, required DateTime startDate, required DateTime endDate}) async {
    var getZoneHistory = positionHistoryService.getZoneHistory(
      assetId: asset.id,
      floorMapId: asset.floorMap!.id,
      startDate: startDate,
      endDate: endDate,
    );

    var getZones = floorMapService.getFloorMapZones(asset.floorMapId);

    var results = await Future.wait([
      getZoneHistory,
      getZones,
    ]);

    var dataGenerator = AssetZoneRetentionDataGenerator(asset: asset);
    dataGenerator.zoneHistoryData = results[0] as List<AssetZoneHistory>;
    dataGenerator.zones = results[1] as List<FloorMapZone>;

    return dataGenerator.generate();
  }
}
