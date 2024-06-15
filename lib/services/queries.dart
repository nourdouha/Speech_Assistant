import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:android_intent_plus/android_intent.dart';

//making calls
Future<void> makePhoneCall(String number) async {
  final url = 'tel:$number';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//playing music
void openMusicApp() {
  final AndroidIntent intent = AndroidIntent(
    action: 'android.intent.action.MUSIC_PLAYER',
  );
  intent.launch();
}

//Checking Weather
void openWeatherApp() {
  final AndroidIntent intent = AndroidIntent(
    action: 'android.intent.action.MAIN',
    category: 'android.intent.category.APP_WEATHER',
  );
  intent.launch();
}

//open news app
Future<void> openNewsApp() async {
  final AndroidIntent intent = AndroidIntent(
    action: 'android.intent.action.MAIN',
    package: 'com.google.android.apps.magazines',
  );
  await intent.launch();
}

//sending messages
Future<void> composeSMS(String phoneNumber, String message) async {
  try {
    final url = 'sms:$phoneNumber?body=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (error) {
    throw 'Failed to compose SMS: $error';
  }
}

Future<void> openNoteTakingApp(String note) async {
  final AndroidIntent intent = AndroidIntent(
    action: 'action_view',
    data: Uri.encodeFull('evernote://'),
    arguments: {'note': note},
  );

  await intent.launch();
}
