import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grock/grock.dart';
import 'package:notification_app/firebase_process.dart';
import 'package:notification_app/service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(FirebaseNotificationService.backgroundMessage);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Grock.navigationKey,
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
      title: 'Flutter Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ICI Teknoloji'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _service = FirebaseNotificationService();

  var flp = FlutterLocalNotificationsPlugin();
  var refTest = FirebaseDatabase.instance.ref().child("Test");
  var refPeople = FirebaseDatabase.instance.ref().child("People");
  

  Future<void> addPeople() async {
    var data = HashMap<String, dynamic>();
    data["personName"] = "Alpay";
    data["personAge"] = 28;
    refPeople.push().set(data);
  }

  /*Future<void> removePeople() async {
    refPeople.child('-NBqXBeifSHewPX5YanL').remove();
  }*/

  /*Future<void> updatePeople() async {
    var data = HashMap<String, dynamic>();
    data["personName"] = "Alpay";
    data["personAge"] = 28;
    refPeople.child("-NBqXhOpbnXLLRAYHHHt").update(data);
  }*/

  Future<void> setup() async {
    var androidSetup = AndroidInitializationSettings("ester");
    var iosSetup = IOSInitializationSettings();
    var setupSetting = InitializationSettings(android: androidSetup, iOS: iosSetup);

    await flp.initialize(setupSetting, onSelectNotification: notificationClick);
  }

  Future<void> notificationClick(String? payLoad) async {
    if(payLoad != null){
      print('Bildirim Seçildi : $payLoad');
    }
  }

  Future<void> notificationShow() async {
    var androidNotificationDetail = AndroidNotificationDetails("Kanal ID", "Kanal İsmi",
      priority: Priority.high,
      importance: Importance.max,
    );

    var iosNotificationDetail = IOSNotificationDetails();
    var notificationDetail = NotificationDetails(android: androidNotificationDetail, iOS: iosNotificationDetail);
    
    await flp.show(0, 'Ester', 'Hesabınıza para geldi 💸', notificationDetail, payload: 'İşte Paranız');
  }

  Future<void> notificationShowWithTime() async {
    var androidNotificationDetail = AndroidNotificationDetails("Kanal ID", "Kanal İsmi", channelDescription: 'Kanal Açıklaması',
      priority: Priority.high,
      importance: Importance.max,
    );

    var iosNotificationDetail = IOSNotificationDetails();
    var notificationDetail = NotificationDetails(android: androidNotificationDetail, iOS: iosNotificationDetail);

    tz.initializeTimeZones();

    var late = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));

    await flp.zonedSchedule(0, 'Başlık', 'İçerik', late, notificationDetail, payload: 'PayLoad',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _service.connectNotification();
    setup();
    addPeople();
    //removePeople();
    //updatePeople();
    var info = HashMap<String,dynamic>();
    info["Mesaj"]="Merhaba";
    refTest.push().set(info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                notificationShow();
            },
              child:Text('Bildirim Oluştur'),
            ),
            ElevatedButton(
              onPressed: () {
                notificationShowWithTime();
              },
              child:Text('Bildirim Oluştur (Gecikmeli)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FirebaseProcess(),));
              },
              child:Text('Database İşlemleri'),
            ),
          ],
        ),
      ),
    );
  }
}


