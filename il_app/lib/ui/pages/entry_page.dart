import 'package:flutter/material.dart';
import 'package:il_app/logic/entry_page_view_model.dart';
import 'package:il_app/ui/widgets/message_card.dart';
import 'package:provider/provider.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => EntryPageViewModel(),
        child: Consumer<EntryPageViewModel>(
          builder: (context, model, child) {
            if (model.message != null) {
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MessageCard(message: model.message!),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => model.runTasks(),
                        child: const Text("Try again"),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: SizedBox.square(
                dimension: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
