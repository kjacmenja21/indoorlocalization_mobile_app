enum MessageType { success, error }

class Message {
  final MessageType type;
  final String value;

  Message(this.type, this.value);

  Message.success(this.value) : type = MessageType.success;
  Message.error(this.value) : type = MessageType.error;
}
