import 'package:flutter/material.dart';
import 'login_signup/services/authentication.dart';
import 'login_signup/pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'TikTok Clone',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
