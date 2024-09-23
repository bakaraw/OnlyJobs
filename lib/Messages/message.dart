import 'package:flutter/material.dart';

class messagePage extends StatefulWidget {
  const messagePage({super.key});

  @override
  State<messagePage> createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Messenger"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
              child: Text("User"),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text("Center"),
      ),
      bottomNavigationBar: ButtonBarTheme(data: data, child: child)
          );

  }
}
