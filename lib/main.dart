import 'package:budget_buddy/pages/login_page.dart';
import 'package:budget_buddy/translations/locale_string.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    translations: LocaleString(),
    locale: const Locale('nl',''),


    home: const LoginPage(),
  ));
}