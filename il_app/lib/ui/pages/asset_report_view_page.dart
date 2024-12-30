import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';

class AssetReportViewPage extends StatelessWidget {
  late final IAssetReportGenerator generator;
  late final dynamic data;

  AssetReportViewPage({
    super.key,
    Object? extra,
  }) {
    if (extra is Map) {
      generator = extra['generator'];
      data = extra['data'];
    } else {
      throw ArgumentError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(generator.getReportName()),
      ),
      //  drawer: const AppNavigationDrawer(),
      body: generator.buildWidget(context, data),
    );
  }
}
