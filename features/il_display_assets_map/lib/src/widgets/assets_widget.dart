import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_map/src/widgets/assets_painter.dart';

class AssetsWidget extends StatefulWidget {
  final FloorMap floorMap;
  final List<Asset> assets;

  const AssetsWidget({
    super.key,
    required this.floorMap,
    required this.assets,
  });

  @override
  State<AssetsWidget> createState() => _AssetsWidgetState();
}

class _AssetsWidgetState extends State<AssetsWidget> {
  late FloorMap floorMap;
  late List<Asset> assets;

  PictureInfo? svg;

  @override
  void initState() {
    super.initState();
    floorMap = widget.floorMap;
    assets = widget.assets;
    _loadSvg(floorMap.svgImage);
  }

  @override
  void didUpdateWidget(AssetsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    floorMap = widget.floorMap;
    assets = widget.assets;
  }

  @override
  Widget build(BuildContext context) {
    if (svg == null) return Container();

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: InteractiveViewer(
          constrained: false,
          minScale: 0.1,
          maxScale: 100,
          child: CustomPaint(
            willChange: true,
            size: svg!.size,
            painter: AssetsPainter(
              floorMap: floorMap,
              assets: assets,
              svg: svg!,
            ),
          ),
        ),
      );
    });
  }

  Future<void> _loadSvg(String svgText) async {
    var svg = await vg.loadPicture(SvgStringLoader(svgText), null);
    setState(() => this.svg = svg);
  }
}
