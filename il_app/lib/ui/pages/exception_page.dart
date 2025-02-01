import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:il_app/models/message.dart';
import 'package:il_app/ui/widgets/message_card.dart';
import 'package:il_core/il_exceptions.dart';

class ExceptionPage extends StatefulWidget {
  final Object exception;

  const ExceptionPage({
    super.key,
    required this.exception,
  });

  @override
  State<ExceptionPage> createState() => _ExceptionPageState();
}

class _ExceptionPageState extends State<ExceptionPage> {
  late Message errorMessage;

  @override
  void initState() {
    super.initState();
    getErrorMessage();
  }

  @override
  void didUpdateWidget(ExceptionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    getErrorMessage();
  }

  void getErrorMessage() {
    var appException = AppException.from(widget.exception);
    errorMessage = Message.error(appException.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exception'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              MessageCard(
                message: errorMessage,
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.pushReplacement('/home');
                },
                child: const Text('Home page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
