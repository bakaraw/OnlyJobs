import 'package:flutter/material.dart';
import 'package:only_job/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:only_job/views/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:only_job/services/auth.dart';
import 'package:only_job/models/user.dart';


import 'chat/mainChatPage.dart';

void main() async {
  // code needed to connect to the firebase servers
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          home: AuthGate(),

        )
    );
  }
}
