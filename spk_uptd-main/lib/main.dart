import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/constants.dart';
import 'controllers/AppControllers.dart';
import 'screens/mainScreen.dart';

void main() async {
  //needed to ensure binding was initialized
  WidgetsFlutterBinding.ensureInitialized();

  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('UPTD PSBGHI');
  });
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppControllers(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PSBGHI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MainScreen(),
    );
  }
}
