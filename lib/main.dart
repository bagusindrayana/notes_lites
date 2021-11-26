import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_lite/screens/form_note.dart';
import 'package:notes_lite/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;
  ThemeData _light = ThemeData.light().copyWith(
    primaryColor: Colors.blueAccent,
  );
  ThemeData _dark = ThemeData.dark().copyWith(
    primaryColor: Colors.blueGrey,
  );

  void changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = !_isDark;
      prefs.setBool('isDark', _isDark);
    });
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: _dark,
      theme: _light,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => Home(changeTheme: changeTheme, isDark: _isDark),
        '/form-note': (context) => const FormNote(),
        // '/show-note': (context) => const ShowNote(),
      },
    );
  }
}
