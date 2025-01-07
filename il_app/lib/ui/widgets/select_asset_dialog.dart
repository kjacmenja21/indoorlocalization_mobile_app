import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:il_app/ui/widgets/fullscreen_dialog.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_widgets.dart';

class SelectAssetDialog extends StatefulWidget {
  final List<Asset> assets;
  final List<FloorMap> floorMaps;

  const SelectAssetDialog({
    super.key,
    required this.assets,
    required this.floorMaps,
  });

  @override
  State<SelectAssetDialog> createState() => _SelectAssetDialogState();
}

class _SelectAssetDialogState extends State<SelectAssetDialog> {
  final tcSearch = TextEditingController();

  List<Asset> allAssets = [];
  List<Asset> currentAssets = [];

  List<FloorMap> floorMaps = [];
  FloorMap? floorMapFilter;

  @override
  void initState() {
    super.initState();

    allAssets = widget.assets;
    currentAssets = allAssets;

    floorMaps = widget.floorMaps;

    tcSearch.addListener(() {
      showAssets();
    });

    showAssets();
  }

  void setFloorMapFilter(FloorMap? floorMap) {
    floorMapFilter = floorMap;
    showAssets();
  }

  void showAssets() {
    List<Asset> assets = allAssets;

    if (floorMapFilter != null) {
      var floorMapId = floorMapFilter!.id;
      assets = assets.where((e) => e.floorMapId == floorMapId).toList();
    }

    var search = tcSearch.text.trim().toLowerCase();
    assets = getSearchResult(search, assets);

    currentAssets = assets;
    setState(() {});
  }

  List<Asset> getSearchResult(String search, List<Asset> assets) {
    if (search.isEmpty) {
      return assets;
    }

    return assets.where((asset) {
      String name = asset.name.toLowerCase();

      if (name.contains(search)) {
        return true;
      }

      return false;
    }).toList();
  }

  void onSelect(Asset asset) {
    context.pop(asset);
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenDialog(
      title: 'Select asset',
      child: buildAssets(),
    );
  }

  Widget buildAssets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomSearchBar(
          controller: tcSearch,
        ),
        const SizedBox(height: 20),
        createFacilityMenu(),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: currentAssets.map((asset) {
                return ListTile(
                  onTap: () => onSelect(asset),
                  title: Text(asset.name),
                  subtitle: Text(asset.floorMap?.name ?? ''),
                  leading: const FaIcon(FontAwesomeIcons.box),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget createFacilityMenu() {
    return DropdownMenu<FloorMap?>(
      label: const Text('Facility'),
      width: 200,
      enableSearch: false,
      requestFocusOnTap: false,
      enableFilter: false,
      onSelected: (value) {
        setFloorMapFilter(value);
      },
      dropdownMenuEntries: [
        const DropdownMenuEntry(
          value: null,
          label: 'All facilities',
          leadingIcon: FaIcon(FontAwesomeIcons.building),
        ),
        ...floorMaps.map((e) {
          return DropdownMenuEntry(
            value: e,
            label: e.name,
            leadingIcon: const FaIcon(FontAwesomeIcons.building),
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    tcSearch.dispose();
    super.dispose();
  }
}
