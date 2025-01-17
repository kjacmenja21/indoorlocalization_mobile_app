import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';

class AssetDetailsDialog extends StatelessWidget {
  final AssetsChangeNotifier model;
  final Asset asset;

  const AssetDetailsDialog({
    super.key,
    required this.model,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: model,
      builder: (context, child) {
        return AlertDialog(
          title: Text(asset.name),
          content: _AssetDetails(
            asset: asset,
            floorMap: model.floorMap,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _AssetDetails extends StatefulWidget {
  final Asset asset;
  final FloorMap floorMap;

  const _AssetDetails({
    required this.asset,
    required this.floorMap,
  });

  @override
  State<_AssetDetails> createState() => _AssetDetailsState();
}

class _AssetDetailsState extends State<_AssetDetails> {
  late Asset asset;

  double x = 0;
  double y = 0;
  FloorMapZone? zone;

  @override
  void initState() {
    super.initState();
    asset = widget.asset;
    findZone();
  }

  @override
  void didUpdateWidget(_AssetDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    asset = widget.asset;
    findZone();
  }

  void findZone() {
    if (asset.x != x || asset.y != y) {
      FloorMapZone? zone = asset.getCurrentZone(widget.floorMap);

      setState(() {
        x = asset.x;
        y = asset.y;
        this.zone = zone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var titleTextStyle = Theme.of(context).textTheme.titleMedium;
    var bodyTextStyle = Theme.of(context).textTheme.bodyMedium;
    var zoneName = zone?.name ?? 'none';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Asset ID', style: titleTextStyle),
        Text('${asset.id}', style: bodyTextStyle),
        const SizedBox(height: 10),
        //
        Text('Location', style: titleTextStyle),
        Text('X: ${x.round()}', style: bodyTextStyle),
        Text('Y: ${y.round()}', style: bodyTextStyle),
        Text('Zone: $zoneName', style: bodyTextStyle),
        const SizedBox(height: 10),
        //
        Text('Last sync', style: titleTextStyle),
        Text(DateFormats.dateTimeSeconds.format(asset.lastSync), style: bodyTextStyle),
      ],
    );
  }
}
