import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_app/models/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final EdgeInsets padding;
  final void Function()? onClose;

  const MessageCard({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.only(top: 20),
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon;

    switch (message.type) {
      case MessageType.success:
        icon = const FaIcon(FontAwesomeIcons.solidCircleCheck, color: Colors.green);
        break;
      case MessageType.error:
        icon = const FaIcon(FontAwesomeIcons.solidCircleXmark, color: Colors.red);
        break;
    }

    Widget? trailing;

    if (onClose != null) {
      trailing = IconButton(
        onPressed: () => onClose!(),
        icon: const FaIcon(FontAwesomeIcons.xmark),
      );
    }

    return Padding(
      padding: padding,
      child: Card(
        child: ListTile(
          leading: icon,
          title: Text(message.value),
          trailing: trailing,
        ),
      ),
    );
  }
}
