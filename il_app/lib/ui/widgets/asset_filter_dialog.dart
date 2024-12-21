import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_entities.dart';

class AssetFilterDialog extends StatefulWidget {
  final List<Asset> assets;

  const AssetFilterDialog({
    super.key,
    required this.assets,
  });

  @override
  State<AssetFilterDialog> createState() => _AssetFilterDialogState();
}

class _AssetFilterDialogState extends State<AssetFilterDialog> {
  late List<Asset> assets;
  late List<bool> visibility;

  @override
  void initState() {
    super.initState();
    assets = widget.assets;
    visibility = assets.map((e) => e.visible).toList();
  }

  void changeVisibility(int index) {
    setState(() {
      visibility[index] = !visibility[index];
    });
  }

  void onApply() {
    for (var i = 0; i < assets.length; i++) {
      var asset = assets[i];
      var visible = visibility[i];

      asset.visible = visible;
    }

    Navigator.of(context).pop(true);
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter assets'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...buildAssetWidgets(assets),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => onCancel(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => onApply(),
          child: const Text('Ok'),
        ),
      ],
    );
  }

  List<Widget> buildAssetWidgets(List<Asset> assets) {
    var children = <Widget>[];

    for (var i = 0; i < assets.length; i++) {
      var asset = assets[i];
      var visible = visibility[i];

      children.add(ListTile(
        title: Text(asset.name),
        leading: const FaIcon(FontAwesomeIcons.box),
        trailing: IconButton(
          onPressed: () => changeVisibility(i),
          icon: getVisibilityIcon(visible),
        ),
      ));
    }

    return children;
  }

  Widget getVisibilityIcon(bool visible) {
    if (visible) {
      return const FaIcon(FontAwesomeIcons.eye);
    } else {
      return const FaIcon(FontAwesomeIcons.eyeSlash);
    }
  }
}
