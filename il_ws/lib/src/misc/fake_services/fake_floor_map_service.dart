import 'dart:ui';

import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class FakeFloorMapService implements IFloorMapService {
  final _testSvg = '''
  
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->

<svg
   width="3000"
   height="2000"
   viewBox="0 0 3000 2000"
   version="1.1"
   id="svg1"
   inkscape:version="1.4 (86a8ad7, 2024-10-11)"
   sodipodi:docname="Floor map 1.svg"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <sodipodi:namedview
     id="namedview1"
     pagecolor="#ffffff"
     bordercolor="#000000"
     borderopacity="0.25"
     inkscape:showpageshadow="2"
     inkscape:pageopacity="0.0"
     inkscape:pagecheckerboard="0"
     inkscape:deskcolor="#d1d1d1"
     inkscape:document-units="px"
     inkscape:zoom="0.26418296"
     inkscape:cx="1366.4773"
     inkscape:cy="800.58155"
     inkscape:window-width="1920"
     inkscape:window-height="1009"
     inkscape:window-x="-8"
     inkscape:window-y="-8"
     inkscape:window-maximized="1"
     inkscape:current-layer="layer1" />
  <defs
     id="defs1" />
  <g
     inkscape:label="Sloj 1"
     inkscape:groupmode="layer"
     id="layer1">
    <rect
       id="rect1"
       width="360.36414"
       height="1435.9603"
       x="298.23459"
       y="244.16727"
       fill="none"
       stroke="#000000"
       stroke-width="4.76403"
       style="stroke-width:5;stroke-dasharray:none" />
    <rect
       id="rect3"
       width="1140.4351"
       height="158.79727"
       x="1486.8434"
       y="290.46524"
       fill="none"
       stroke="#000000"
       stroke-width="3.56492"
       style="stroke-width:5;stroke-dasharray:none" />
    <rect
       id="rect3-8"
       width="1140.4351"
       height="158.79727"
       x="1485.3204"
       y="575.16656"
       fill="none"
       stroke="#000000"
       stroke-width="3.56492"
       style="stroke-width:5;stroke-dasharray:none" />
    <rect
       id="rect3-5"
       width="1140.4351"
       height="158.79727"
       x="1485.3669"
       y="874.55597"
       fill="none"
       stroke="#000000"
       stroke-width="3.56492"
       style="stroke-width:5;stroke-dasharray:none" />
    <rect
       style="display:none;opacity:0.161512;fill:#ff8e00;fill-opacity:1;stroke-width:4.87985;stroke-dasharray:none"
       id="rect2"
       width="1367.004"
       height="1036.6434"
       x="1384.0608"
       y="177.19229"
       inkscape:label="zone2" />
    <rect
       style="display:none;opacity:0.161512;fill:#7dff00;fill-opacity:1;stroke-width:5;stroke-dasharray:none"
       id="rect4"
       width="958.21558"
       height="1632.7137"
       x="182.00743"
       y="152.56505"
       inkscape:label="zone1" />
  </g>
</svg>


  ''';

  @override
  Future<List<FloorMap>> getAllFloorMaps() async {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [
        FloorMap(
          id: 1,
          name: 'Floor map 1',
          trackingArea: Rect.fromLTWH(0, 0, 3000, 2000),
          size: Size(3000, 2000),
          svgImage: _testSvg,
        ),
        FloorMap(
          id: 2,
          name: 'Floor map 2',
          trackingArea: Rect.fromLTWH(0, 0, 3000, 2000),
          size: Size(3000, 2000),
          svgImage: _testSvg,
        ),
      ];
    });
  }

  @override
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId) async {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [
        FloorMapZone(
          id: 1,
          name: 'Zone 1',
          color: Color.fromARGB(255, 255, 167, 38),
          points: _getRectPoints(182.01, 152.57, 958.22, 1632.71),
          floorMapId: floorMapId,
        ),
        FloorMapZone(
          id: 2,
          name: 'Zone 2',
          color: Color.fromARGB(255, 255, 222, 38),
          points: _getRectPoints(1384.06, 177.19, 1367, 1036.64),
          floorMapId: floorMapId,
        ),
      ];
    });
  }

  List<Offset> _getRectPoints(double x, double y, double w, double h) {
    return [
      Offset(x, y),
      Offset(x + w, y),
      Offset(x + w, y + h),
      Offset(x, y + h),
    ];
  }
}
