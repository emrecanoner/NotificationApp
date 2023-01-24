import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:grock/grock.dart';

class FirebaseNotificationService{
  late final FirebaseMessaging messaging;

  void setNotification() async {
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void connectNotification() async{
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    setNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      Grock.snackBar(title: "${event.notification?.title}",
          description: "${event.notification?.body}",
          opacity: 0.5,position: SnackbarPosition.top,
          leading: "${event.notification?.android?.imageUrl}" == null ? null : Image.network("${event.notification?.android?.imageUrl}", width: 30,height: 30,)
      );
    });

    messaging.getToken().then((value) => log("Token: $value", name: "FCM Token"));
  }

  static Future<void> backgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }
}