import 'package:discoverkorea/login_screen.dart';

import 'package:discoverkorea/providers/api_mengikuti.dart';
import 'package:discoverkorea/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discoverkorea/providers/api_unggahan.dart';
import 'package:discoverkorea/providers/api_notification.dart';
import 'package:discoverkorea/providers/api_user.dart';
import 'package:discoverkorea/providers/api_chat.dart';
import 'package:discoverkorea/providers/api_fanbase.dart';
import 'package:discoverkorea/providers/api_comments.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/login': (BuildContext context) => new HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiUnggahan>(
              create: (context) => ApiUnggahan()),
          ChangeNotifierProvider<ApiNotifikasi>(
              create: (context) => ApiNotifikasi()),
          ChangeNotifierProvider<ApiUser>(create: (context) => ApiUser()),
          ChangeNotifierProvider<ApiMengikuti>(create: (context) => ApiMengikuti()),
          ChangeNotifierProvider<ApiChat>(create: (context) => ApiChat()),
          ChangeNotifierProvider<ApiFanbase>(create: (context) => ApiFanbase()),
          ChangeNotifierProvider<ApiComments>(create: (context) => ApiComments()),
          // ChangeNotifierProvider(
          //   create: (_) => ApiProvider(),
          // ),
        ],
        child: MaterialApp(
          title: 'Discover Korea',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
          ),
          home: Scaffold(body: SplashScreen()),
          routes: routes,
        ));
  }
}
