class NotificationModel {
  final String text;

  NotificationModel(this.text);

  Map<String, dynamic> toJson() => {'text': text};
}
