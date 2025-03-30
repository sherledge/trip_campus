import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trip_campus/screens/add_package_screen.dart';
import 'package:trip_campus/screens/home_screen.dart';
import 'package:trip_campus/screens/intro_screen.dart';
import 'package:trip_campus/providers/shared_prefs_provider.dart';
import 'package:trip_campus/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final introSeenAsyncValue = ref.watch(introSeenProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tour Company",

      home: introSeenAsyncValue.when(
        data: (hasSeenIntro) => hasSeenIntro ? MainScreen() : IntroScreen(),
        loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => Scaffold(body: Center(child: Text("Error loading app"))),
      ),
    );
  }
}

