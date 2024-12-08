import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_theme.dart';

class AssetsPainter extends CustomPainter {
  final FloorMap floorMap;
  final List<Asset> assets;
  final PictureInfo svg;

  AssetsPainter({required this.floorMap, required this.assets, required this.svg});

  @override
  void paint(Canvas canvas, Size size) {
    var offset = Offset(50, 50);
    var img = svg.picture.toImageSync((size.width - 2 * offset.dx).toInt(), (size.height - 2 * offset.dy).toInt());

    canvas.drawImage(img, offset, Paint());
    img.dispose();

    for (var asset in assets) {
      drawAsset(offset, asset, canvas);
    }
  }

  void drawAsset(Offset offset, Asset asset, Canvas canvas) {
    Paint p = Paint();
    p.color = AppColors.primaryBlueColor;
    p.style = PaintingStyle.fill;

    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: asset.name,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    textPainter.layout();

    var assetPosition = offset + Offset(asset.x, asset.y);
    canvas.drawCircle(assetPosition, 3, p);

    var labelPosition = assetPosition - Offset(textPainter.width / 2, textPainter.height + 8);
    var labelRectPosition = labelPosition - Offset(8, 0);
    var labelRectSize = Offset(textPainter.width + 16, textPainter.height);

    _drawRRect(labelRectPosition, labelRectSize, labelRectSize.dy / 2, canvas, p);
    textPainter.paint(canvas, labelPosition);
  }

  void _drawRRect(Offset pos, Offset size, double r, Canvas canvas, Paint paint) {
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(pos.dx, pos.dy, size.dx, size.dy), r, r), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
