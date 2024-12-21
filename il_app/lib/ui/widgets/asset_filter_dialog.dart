import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_widgets.dart';

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
  final tcSearch = TextEditingController();

  late List<Asset> assets;

  @override
  void initState() {
    super.initState();
    assets = widget.assets.map((e) => e.copy()).toList();
  }

  void changeVisibility(Asset asset) {
    setState(() {
      asset.visible = !asset.visible;
    });
  }

  void onHideAll() {
    setState(() {
      for (var e in assets) {
        e.visible = false;
      }
    });
  }

  void onShowAll() {
    setState(() {
      for (var e in assets) {
        e.visible = true;
      }
    });
  }

  void onApply() {
    List<bool> visibility = assets.map((e) => e.visible).toList();
    Navigator.of(context).pop(visibility);
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter assets'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchBar(controller: tcSearch),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: assets.map((asset) {
                  return ListTile(
                    title: Text(asset.name),
                    leading: const FaIcon(FontAwesomeIcons.box),
                    trailing: IconButton(
                      onPressed: () => changeVisibility(asset),
                      icon: getVisibilityIcon(asset.visible),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => onHideAll(),
                child: const Text('Hide all'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => onShowAll(),
                child: const Text('Show all'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => onCancel(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => onApply(),
          child: const Text('Ok'),
        ),
      ],
    );
  }

  Widget getVisibilityIcon(bool visible) {
    if (visible) {
      return const FaIcon(FontAwesomeIcons.eye);
    } else {
      return const FaIcon(FontAwesomeIcons.eyeSlash);
    }
  }

  @override
  void dispose() {
    tcSearch.dispose();
    super.dispose();
  }
}
