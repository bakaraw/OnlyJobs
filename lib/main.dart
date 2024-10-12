import 'package:flutter/material.dart';
import 'package:only_job/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:only_job/views/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/models/user.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:only_job/views/home/job_seeker_profileview.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // code needed to connect to the firebase servers
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
        value: AuthService().user,
        initialData: null,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthGate(),
        ));
  }
}
