import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'my_change_notifier.dart';
import 'login.dart';
import 'home.dart';
import 'cadastrar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ijloowhtaogbktcuootq.supabase.co',
    anonKey: 'sb_publishable_SGgwsGBzUReNAMj7TywgCg_zWKjnGOG',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => MyChangeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Jogos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(), 
        '/home': (context) => const Home(), 
        '/cadastrar': (context) => const Cadastrar(), 
        
      },
    );
  }
}