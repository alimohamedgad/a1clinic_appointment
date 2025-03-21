import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_provider.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';
import 'pharmacies/providers/pharmacies_laravel_provider.dart';

//ahmed naji
Future<void> initServices() async {

  Get.log('starting services ...');
  await GetStorage.init();
  await Get.putAsync(() => GlobalService().init());
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LaravelApiClient().init());
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  await Get.putAsync(() => PharmaciesLaravelApiClient().init());
  await Get.putAsync(() => TranslationService().init());
  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await initServices();

  runApp(
    GetMaterialApp(
      title: Get.find<SettingsService>().setting.value.appName ?? '',
      initialRoute: Theme1AppPages.INITIAL,

      onReady: () async {
        await Get.putAsync(() => FireBaseMessagingService().init());
      },
      getPages: Theme1AppPages.routes,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: Get.find<TranslationService>().getLocale(),
      fallbackLocale: Get.find<TranslationService>().getLocale(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (Platform.isAndroid) {
      return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    }

    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "PROXY 192.168.1.7:8083";
      }
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}


