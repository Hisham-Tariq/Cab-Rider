import 'app/customization/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/data/services/dependency_injection.dart';
import 'app/data/services/theme_service.dart';
import 'app/data/services/translations_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/ui/theme/themes.dart';
import 'app/data/services/messaging/fcm_configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  FirebaseMessaging.onMessage.listen(firebaseForegroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(firebaseOnMessageClicked);
  await GetStorage.init();
  DependecyInjection.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cab Rider',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      // theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeService().getThemeMode(),
      translations: Translation(),
      locale: Locale('en'),
      fallbackLocale: Locale('en'),
      initialRoute: AppRoutes.SPLASH,
      unknownRoute: AppPages.unknownRoutePage,
      getPages: AppPages.pages,
    );
  }
}
