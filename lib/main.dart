import 'package:flutter/material.dart';
import 'package:commit_me/page/home.dart';
import 'package:commit_me/page/info.dart';
import 'package:commit_me/page/chatbotPage.dart';
import 'package:provider/provider.dart';
import 'package:commit_me/userProvider.dart';
import 'package:commit_me/infoProvider.dart';
import 'package:commit_me/sessionProvider.dart';
import 'package:commit_me/messageProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => InfoProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(),
    );
  }
}