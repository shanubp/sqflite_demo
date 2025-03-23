import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await NotificationService.instance.setUpNotification();
  await NotificationService.instance.showNotification(message);
}

class NotificationService{
  NotificationService();
  static final NotificationService instance = NotificationService();

  final _messaging = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();
   bool _isNotificationInitialized = false;

   Future<void> initialize()async{

     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
     await requestPermission();
     await setUpMessageHandlers();

     /// get fcm token
     final token = await _messaging.getToken();
     print('FCM token: $token');

   }

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setUpNotification() async{
    if(_isNotificationInitialized){
      return;
    }

    /// for android

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
        'High Importance Notifications',
        description: 'This Channel is used for important notifications',
        importance: Importance.high
    );
    await _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
?.createNotificationChannel(channel);

    const settingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); /// default icon(flutter)

    const initializationSettings = InitializationSettings(
      android: settingsAndroid
    );

    await _localNotification.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (details) {

    },
    );
    _isNotificationInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message)async{
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if(notification != null && android != null){
   await _localNotification.show(
       notification.hashCode,
       notification.title,
       notification.body,
       const NotificationDetails(
         android: AndroidNotificationDetails(
             'high importance channel',
         'High Importance Notifications',
         channelDescription: 'This channel is used for important notifications.' ,
         importance: Importance.high,
         priority: Priority.high,
         icon: '@mipmap/ic_launcher',
         ),
       ),
     payload: message.data.toString()
   );
    }
  }

  void handleBackgroundMessage(RemoteMessage message){
    if(message.data['type'] == 'chat'){
      /// open chat screen
    }
  }
  
  Future<void> setUpMessageHandlers() async{
    /// foreground message
    FirebaseMessaging.onMessage.listen((event) {
      showNotification(event);
    },);
    
    /// background message
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);

    /// opened app
    final initialMessage = await _messaging.getInitialMessage();
    if(initialMessage !=null){
      handleBackgroundMessage(initialMessage);
    }
  }

}