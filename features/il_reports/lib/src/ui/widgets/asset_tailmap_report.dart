import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_core/il_widgets.dart';
import 'package:il_reports/src/models/asset_tailmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_report_info.dart';
import 'package:il_reports/src/ui/widgets/asset_tailmap_painter.dart';

class AssetTailmapReportWidget extends StatefulWidget {
  final AssetTailmapData data;

  const AssetTailmapReportWidget({
    super.key,
    required this.data,
  });

  @override
  State<AssetTailmapReportWidget> createState() => _AssetTailmapReportWidgetState();
}

class _AssetTailmapReportWidgetState extends State<AssetTailmapReportWidget> {
  late AssetTailmapData data;

  bool paused = true;
  Timer? playTimer;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void updateCurrentPosition(int positionIndex) {
    if (positionIndex < 0) {
      positionIndex = 0;
    } else if (positionIndex >= data.positionHistory.length - 1) {
      positionIndex = data.positionHistory.length - 1;
    }

    setState(() {
      data.currentPositionIndex = positionIndex;
    });
  }

  void start() {
    playTimer?.cancel();

    if (data.currentPositionIndex == data.positionHistory.length - 1) {
      data.currentPositionIndex = 0;
    }

    playTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) => onPlayTimerTick(),
    );

    setState(() {
      paused = false;
    });
  }

  void pause() {
    playTimer?.cancel();
    playTimer = null;

    setState(() {
      paused = true;
    });
  }

  void onPlayTimerTick() {
    int index = data.currentPositionIndex;
    if (index == data.positionHistory.length - 1) {
      pause();
      return;
    }

    setState(() {
      data.currentPositionIndex = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetReportInfo(
            asset: data.asset,
            startDate: data.startDate,
            endDate: data.endDate,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _TailmapReportWidget(data),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (paused) {
                    start();
                  } else {
                    pause();
                  }
                },
                icon: paused ? const FaIcon(FontAwesomeIcons.play) : const FaIcon(FontAwesomeIcons.pause),
              ),
              const SizedBox(width: 10),
              Text(DateFormats.dateTime.format(data.currentDate), style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Slider(
            value: data.currentPositionIndex.toDouble(),
            min: 0,
            max: (data.positionHistory.length - 1).toDouble(),
            onChanged: (value) {
              if (!paused) {
                pause();
              }

              updateCurrentPosition(value.round());
            },
          ),
        ],
      ),
    );
  }
}

class _TailmapReportWidget extends StatelessWidget {
  final AssetTailmapData data;

  const _TailmapReportWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return FloorMapWidget(
      floorMap: data.floorMap,
      backgroundBuilder: (imageRenderer) {
        return CustomPaint(
          willChange: false,
          isComplex: true,
          size: data.floorMap.size,
          painter: AssetTailmapBackgroundPainter(
            data: data,
            imageRenderer: imageRenderer,
          ),
        );
      },
      foregroundBuilder: (size, transform) {
        return CustomPaint(
          willChange: true,
          size: size,
          painter: AssetTailmapForegroundPainter(
            transform: transform,
            data: data,
          ),
        );
      },
    );
  }
}
