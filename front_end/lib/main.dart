
import 'package:flutter/material.dart';
import 'package:front_end/views/sessionView.dart';
import 'package:front_end/views/mapView.dart';
import 'package:front_end/views/exception/Page404.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 96, 194, 158)),
        useMaterial3: true,
      ),
      home: const Sessionview(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Sessionview(),
        '/mapa': (context) => const MapView(),

      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const Page404());
      },
    );
  }
}
