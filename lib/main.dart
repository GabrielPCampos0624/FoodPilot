import 'package:flutter/material.dart';
import 'shared/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();

  runApp(const FoodPilotApp());
}