import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:il_app/logic/vm/home_page_view_model.dart';
import 'package:il_app/ui/widgets/app_logo.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const AppNavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ChangeNotifierProvider(
            create: (context) => HomePageViewModel(
              floorMapService: FloorMapService(),
            ),
            child: buildBody(),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<HomePageViewModel>(
      builder: (context, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppLogoWidget(),
            ),
            const SizedBox(height: 40),
            if (model.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (!model.isLoading) _Facilities(facilities: model.floorMaps),
          ],
        );
      },
    );
  }
}

class _Facilities extends StatelessWidget {
  final List<FloorMap> facilities;
  const _Facilities({required this.facilities});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Facilities', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        ...facilities.map((e) {
          return ListTile(
            title: Text(e.name),
            leading: const FaIcon(FontAwesomeIcons.building),
            onTap: () {
              var extra = {'floorMapId': e.id};
              context.go('/asset_dashboard', extra: extra);
            },
          );
        }),
      ],
    );
  }
}
