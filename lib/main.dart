import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:simple_mailer_app/theme/theme.dart';
import 'package:simple_mailer_app/views/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: MyTheme.lightTheme(lightColorScheme),
        darkTheme: MyTheme.darkTheme(darkColorScheme),
        initialRoute: "/",
        routes: {
          MailerPage.routeName: (context) => MailerPage(),
          AlreadyVerifiedPage.routeName: (context) => AlreadyVerifiedPage(),
        },
      );
    });
  }
}
