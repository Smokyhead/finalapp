import 'package:finalapp/provider/dark_theme_prov.dart';
import 'package:finalapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkProvider themeChangeProv = DarkProvider();

  void getCurrentAppTheme() async {
    themeChangeProv.setDarkTheme =
        await themeChangeProv.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProv;
        }),
      ],
      child: Consumer<DarkProvider>(builder: (context, themeProvider, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Clin',
          home: SplashScreen(),
        );
      }),
    );
  }
}
