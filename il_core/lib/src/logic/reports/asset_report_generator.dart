import 'package:flutter/widgets.dart';

abstract class IAssetReportGenerator {
  Future<dynamic> generateData({
    required int assetId,
    required int floorMapId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Widget buildDisplayWidget({required VoidCallback onTap});
  Widget buildWidget(BuildContext context, dynamic data);
}
