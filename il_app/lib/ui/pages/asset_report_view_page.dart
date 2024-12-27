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
        title: const Text('Report view'),
      ),
      //  drawer: const AppNavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: generator.buildWidget(context, data),
      ),
    );
  }
}
