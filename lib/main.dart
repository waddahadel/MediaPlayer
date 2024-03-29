import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quran/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.brown,
      ),



      home: Directionality( // use this
        textDirection: TextDirection.rtl, // set it to rtl
        child: HomePage(),
      ),
    );

  }
}
