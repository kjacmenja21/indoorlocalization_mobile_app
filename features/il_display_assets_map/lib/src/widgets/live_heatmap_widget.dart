import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_core/il_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_display_assets_map/src/logic/live_heatmap_change_notifier.dart';
import 'package:il_display_assets_map/src/widgets/asset_details_dialog.dart';
import 'package:il_display_assets_map/src/widgets/live_heatmap_painter.dart';

class LiveHeatmapWidget extends StatelessWidget {
  final LiveHeatmapChangeNotifier model;

  const LiveHeatmapWidget({
    super.key,
    required this.model,
  });

  void openAssetDetailsDialog(BuildContext context, Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AssetDetailsDialog(
        model: model,
        asset: asset,
      ),
    );
  }

  void onDoubleTapDown(BuildContext context, TapDownDetails details, Matrix4 transform) {
    var assets = model.assets;
    var scale = transform.getMaxScaleOnAxis();
    var translation = transform.getTranslation();

    var geometryHelper = GeometryHelper();
    var tapPosition = details.localPosition;

    for (var asset in assets) {
      double x = asset.x * scale + translation.x;
      double y = asset.y * scale + translation.y;
      var assetPosition = Offset(x, y);

      double distance = geometryHelper.distanceBetweenPoints(assetPosition, tapPosition);

      if (distance <= 30) {
        openAssetDetailsDialog(context, asset);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: model,
      builder: (context, child) {
        var floorMap = model.floorMap;
        var assets = model.assets;

        return FloorMapWidget(
            floorMap: floorMap,
            onDoubleTapDown: (details, transform) => onDoubleTapDown(context, details, transform),
            backgroundBuilder: (imageRenderer) {
              return CustomPaint(
                willChange: false,
                isComplex: true,
                size: floorMap.size,
                painter: LiveHeatmapBackgroundPainter(
                  floorMap: floorMap,
                  imageRenderer: imageRenderer,
                  heatmapData: model.heatmapData,
                ),
              );
            },
            foregroundBuilder: (size, transform) {
              return CustomPaint(
                willChange: true,
                size: size,
                painter: LiveHeatmapForegroundPainter(
                  transform: transform,
                  floorMap: floorMap,
                  assets: assets,
                  heatmapData: model.heatmapData,
                ),
              );
            },
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: IconButton.filled(
                  onPressed: () => model.resetHeatmap(),
                  icon: const FaIcon(FontAwesomeIcons.arrowRotateRight),
                ),
              ),
            ));
      },
    );
  }
}
