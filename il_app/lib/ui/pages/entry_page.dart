import 'package:flutter/material.dart';
import 'package:il_app/logic/entry_page_view_model.dart';
import 'package:provider/provider.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => EntryPageViewModel(),
        child: Consumer<EntryPageViewModel>(
          builder: (context, model, child) {
            return Placeholder();
          },
        ),
      ),
    );
  }
}
