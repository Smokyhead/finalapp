import 'package:finalapp/constants.dart';
import 'package:flutter/material.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            title: const Text("Notifications"),
          ),
        ],
      ),
    );
  }
}
