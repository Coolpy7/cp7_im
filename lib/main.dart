import 'package:cp7_im/network/msgbus.dart';
import 'package:cp7_im/pages/home/fistPage.dart';
import 'package:cp7_im/pages/home/home.dart';
import 'package:cp7_im/pages/sign/signIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var flutterLocalNotificationsPlugin;

main() {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
  // change the default route of the app
  // var notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  return runApp(new MyWeChat());
}

class MyWeChat extends StatefulWidget {
  @override
  _MyWeChatState createState() => new _MyWeChatState();
}

class _MyWeChatState extends State<MyWeChat> {
  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    eventBus.on<LocalPushEvent>().listen(_showNotification);
  }

  Future _showNotification(LocalPushEvent data) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(data.cid, data.cname, data.cdesc, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    Future.delayed(new Duration(seconds: data.delay), () {
      flutterLocalNotificationsPlugin.show(
          data.id, data.title, data.body, platformChannelSpecifics, payload: data.payload);
    });
  }

  Future _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future _showNotificationWithUpdatedChannelDescription() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your updated channel description',
        importance: Importance.Max, priority: Priority.High,
        channelAction: AndroidNotificationChannelAction.Update);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'updated notification channel',
        'check settings to see updated channel description',
        platformChannelSpecifics, payload: 'item x');
  }

  Future onDidRecieveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter仿微信',
        theme: new ThemeData(
          primaryColorBrightness: Brightness.dark,
          primaryColor: const Color(0xFF64c223),
          hintColor: const Color(0xFFcfcfcf),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        home: new FirstPage(),
        routes: <String, WidgetBuilder>{
          '/home': (_) => new Home(),
          '/signIn': (_) => new SignIn()
        });
  }
}

class SecondScreen extends StatefulWidget {
  final String payload;
  SecondScreen(this.payload);
  @override
  State<StatefulWidget> createState() => new SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Second Screen with payload: " + _payload),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('Go back!'),
        ),
      ),
    );
  }
}