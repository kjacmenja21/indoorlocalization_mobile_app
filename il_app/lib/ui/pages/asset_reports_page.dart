import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:il_app/logic/vm/asset_reports_page_view_model.dart';
import 'package:il_app/ui/widgets/message_card.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_app/ui/widgets/select_asset_dialog.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_widgets.dart';
import 'package:il_reports/il_reports.dart';
import 'package:il_ws/il_ws.dart';
import 'package:provider/provider.dart';

class AssetReportsPage extends StatelessWidget {
  late final int? initAssetId;

  AssetReportsPage({super.key, Object? extra}) {
    if (extra is Map) {
      initAssetId = extra['assetId'];
    } else {
      initAssetId = null;
    }
  }

  Future<void> openSelectAssetDialog(BuildContext context) async {
    var model = context.read<AssetReportsPageViewModel>();

    Asset? result = await showDialog<Asset>(
      context: context,
      builder: (context) => SelectAssetDialog(
        assets: model.assets,
        floorMaps: model.floorMaps,
      ),
    );

    if (result != null) {
      model.selectAsset(result);
    }
  }

  Future<void> openGenerateReport(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          body: Center(
            child: TextButton(onPressed: () => context.pop(), child: const Text('Back')),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetReportsPageViewModel(
        assetService: AssetService(),
        floorMapService: FloorMapService(),
        reportGenerators: [
          AssetHeatmapReportGenerator(
            positionHistoryService: AssetPositionHistoryService(),
          ),
          AssetTailmapReportGenerator(
            positionHistoryService: AssetPositionHistoryService(),
          ),
          AssetZoneRetentionTimeReportGenerator(
            positionHistoryService: AssetPositionHistoryService(),
            floorMapService: FloorMapService(),
          ),
        ],
        openReportViewPage: (generator, data) {
          var extra = {
            'generator': generator,
            'data': data,
          };

          context.push('/asset_report_view', extra: extra);
        },
        showExceptionPage: (e) => context.pushReplacement('/exception', extra: e),
        initAssetId: initAssetId,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Asset reports'),
        ),
        drawer: const AppNavigationDrawer(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<AssetReportsPageViewModel>(
      builder: (context, model, child) {
        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var titleTextStyle = Theme.of(context).textTheme.titleLarge;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                Text('Asset', style: titleTextStyle),
                buildSelectedAsset(context, model),
                const SizedBox(height: 20),

                Text('Start date', style: titleTextStyle),
                DateTimePicker(
                  value: model.startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  onUpdate: (value) => model.setStartDate(value),
                ),
                const SizedBox(height: 20),

                Text('End date', style: titleTextStyle),
                DateTimePicker(
                  value: model.endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  defaultTime: const TimeOfDay(hour: 23, minute: 59),
                  onUpdate: (value) => model.setEndDate(value),
                ),
                const SizedBox(height: 20),

                createPredefinedPeriodMenu(context, model),
                const SizedBox(height: 20),

                Text('Reports', style: titleTextStyle),

                if (model.message != null)
                  MessageCard(
                    message: model.message!,
                    onClose: () => model.clearMessage(),
                  ),

                const SizedBox(height: 10),

                ...model.reportGenerators.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: e.buildGenerateReportButton(
                      onTap: () => model.generateReport(e),
                    ),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSelectedAsset(BuildContext context, AssetReportsPageViewModel model) {
    Widget child;

    if (model.selectedAsset == null) {
      child = ListTile(
        leading: const FaIcon(FontAwesomeIcons.box),
        title: const Text('Select asset'),
        onTap: () => openSelectAssetDialog(context),
      );
    } else {
      child = ListTile(
        leading: const FaIcon(FontAwesomeIcons.box),
        title: Text(model.selectedAsset!.name),
        subtitle: Text(model.selectedAsset!.floorMap?.name ?? ''),
        onTap: () => openSelectAssetDialog(context),
      );
    }

    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: child,
      ),
    );
  }

  Widget createPredefinedPeriodMenu(BuildContext context, AssetReportsPageViewModel model) {
    return MenuAnchor(
      menuChildren: model.predefinedPeriods.map((e) {
        var (text, duration) = e;
        return MenuItemButton(
          onPressed: () => model.setPredefinedPeriod(duration),
          child: Text(text),
        );
      }).toList(),
      builder: (context, controller, child) {
        return OutlinedButton.icon(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const FaIcon(FontAwesomeIcons.clock),
          label: const Text('Use predefined period'),
        );
      },
    );
  }
}
