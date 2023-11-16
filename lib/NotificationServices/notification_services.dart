


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {


  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission()async{

    NotificationSettings setting = await messaging.requestPermission(
      badge: true,
      alert: true,
      sound: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );

    if(setting.authorizationStatus == AuthorizationStatus.authorized)
      {
        print("granted");
      }
    else
      {
        print("denied");
      }


  }

  void initLocalNotification(RemoteMessage message, BuildContext context)
  {
    final androidInitializationSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
    );

    flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
      onDidReceiveBackgroundNotificationResponse: (payload){

      },
    );
  }

  void firebaseInit()
  {
    FirebaseMessaging.onMessage.listen((event){
      print(event.notification!.title.toString());

      showNotification(event);
    });
  }

  Future<void> showNotification(RemoteMessage message)async
  {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        //Random.secure().nextInt(10000).toString(),
        "your high importance channel",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      importance: Importance.high,
      channelDescription: "Your channel description",
      playSound: true,
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      ticker: "ticker"
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
            (){
              flutterLocalNotificationsPlugin.show(
                  0,
                  message.notification!.title,
                  message.notification!.body,
                  notificationDetails
              );
            }
    );

  }

  Future<String> getToken()async{
    String? token = await messaging.getToken();
    return token!;
  }


  void isTokenRefresh()
  {
    messaging.onTokenRefresh.listen((event){
      event.toString();
    });
  }



}