import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_app/logic/vm/assets_page_view_model.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_ws/il_fake_services.dart';
import 'package:provider/provider.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetsPageViewModel(
        assetService: FakeAssetService(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assets'),
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
    return Consumer<AssetsPageViewModel>(
      builder: (context, model, child) {
        if (model.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var assets = model.assets;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  var asset = assets[index];
                  return ListTile(
                    onTap: () {},
                    title: Text(asset.name),
                    subtitle: Text(asset.floorMap?.name ?? ''),
                    leading: const FaIcon(FontAwesomeIcons.box),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
