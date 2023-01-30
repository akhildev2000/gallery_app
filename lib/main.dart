import 'package:flutter/material.dart';
import 'package:gallery/Screen/home_screen.dart';
import 'package:gallery/database/dbmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Gallery>(GalleryAdapter());
  await Hive.openBox<Gallery>('gallery');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const Scaffold(body: HomeScreen()),
    );
  }
}
