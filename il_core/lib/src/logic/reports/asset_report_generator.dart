import 'package:flutter/widgets.dart';
import 'package:il_core/il_entities.dart';

abstract class IAssetReportGenerator {
  Future<dynamic> generateData({
    required Asset asset,
    required DateTime startDate,
    required DateTime endDate,
  });

  Widget buildGenerateReportButton({required VoidCallback onTap});
  Widget buildWidget(BuildContext context, dynamic data);
}
