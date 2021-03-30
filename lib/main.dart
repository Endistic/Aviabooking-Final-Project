import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prampracha_app/screens/auth.dart';
import 'package:flutter/services.dart';
import 'package:prampracha_app/screens/login.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/Login': (BuildContext context) => new LoginTo()
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('th', 'TH'), // Thai
      ],
      title: 'Prampacha Transport',
      home: new Landing(),
    );
  }
}
