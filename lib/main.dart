import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hunarmand_app/screens/home_screen.dart';
import 'package:hunarmand_app/screens/login_screen.dart';
import 'package:hunarmand_app/screens/sign_up_screen.dart';
import 'package:hunarmand_app/screens/splash_sceen.dart';
import 'package:hunarmand_app/screens/wl_screen.dart';
import 'package:hunarmand_app/screens/worker_request_screen.dart';

@pragma('vm entry-point')
Future<void> onBackgroundMessage(RemoteMessage message)async
{
  await Firebase.initializeApp();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  MaterialColor myColor = MaterialColor(
    0xFF26A69A, // primary color value
    <int, Color>{
      50: Color(0xFFB2DFDB), // lightest shade
      100: Color(0xFF80CBC4),
      200: Color(0xFF4DB6AC),
      300: Color(0xFF26A69A),
      400: Color(0xFF009688),
      500: Color(0xFF00897B), // primary color value
      600: Color(0xFF00796B),
      700: Color(0xFF00695C),
      800: Color(0xFF004D40),

    },
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: myColor,
      ),
      getPages: [
        GetPage(name: "/", page: () => WlScreen()),
      ],
    );
  }
}





