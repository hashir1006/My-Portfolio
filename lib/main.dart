import 'package:flutter/material.dart';
import 'app.dart';
import 'theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  runApp(HashirPortfolioApp(themeController: themeController));
}
