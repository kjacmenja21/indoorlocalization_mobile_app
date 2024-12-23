import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_app/logic/vm/asset_reports_page_view_model.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_app/ui/widgets/select_asset_dialog.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';
import 'package:provider/provider.dart';

class AssetReportsPage extends StatelessWidget {
  const AssetReportsPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetReportsPageViewModel(
        assetService: AssetService(),
        floorMapService: FloorMapService(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Asset reports'),
        ),
        drawer: const AppNavigationDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<AssetReportsPageViewModel>(
      builder: (context, model, child) {
        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSelectedAsset(context, model),
            const SizedBox(height: 20),
          ],
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
      child: child,
    );
  }
}
