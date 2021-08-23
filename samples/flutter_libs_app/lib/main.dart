import 'package:fair/fair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libs_app/package_info/package_info_delegate.dart';
import 'package:flutter_libs_app/url_launcher/url_launcher_delegate.dart';

import 'common_delegate.dart';
import 'convex_bottom_bar/fair_convex_bottom_bar.dart';
import 'device_info/device_info_delegate.dart';
import 'google_fonts/fair_google_fonts.dart';
import 'index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FairApp.runApplication(FairApp(
    delegate: {
      'device_info': (_, data) => DeviceInfoDelegate(),
      'url_launcher': (_, data) => UrlLauncherDelegate(),
      'google_fonts': (_, data) => CommonDelegate(),
      'package_info': (_, data) => PackageInfoDelegate(),
    },
    generated: SimpleGenerate(),
    child: MyApp(),
  ),plugins: {
    // 'FairNet': FairNet(),
    // 'WBPermission': WBPermission(),
    // 'FairPhotoSelector': FairPhotoSelector(),
  },);
}

class SimpleGenerate extends GeneratedModule {
  @override
  Map<String, dynamic> components() {
    return Map<String, dynamic>()
      ..addAll(convex_bottom_bar_component)
      ..addAll(google_fonts_component);
  }

  @override
  Map<String, bool> mapping() {
    return Map<String, bool>();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fair Libs Demo Home Page'),
    );
  }
}
