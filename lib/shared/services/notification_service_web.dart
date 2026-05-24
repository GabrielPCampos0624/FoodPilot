import 'dart:html' as html;

class NotificationService {
  static Future<void> initialize() async {
    if (!html.Notification.supported) return;

    if (html.Notification.permission == 'default') {
      await html.Notification.requestPermission();
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (!html.Notification.supported) return;

    if (html.Notification.permission != 'granted') {
      final permission = await html.Notification.requestPermission();

      if (permission != 'granted') return;
    }

    html.Notification(
      title,
      body: body,
      icon: 'icons/Icon-192.png',
    );
  }
}