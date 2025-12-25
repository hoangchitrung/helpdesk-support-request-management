import 'package:flutter/material.dart';

class SendRequestScreen extends StatefulWidget {
  const SendRequestScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SendRequestState();
  }
}

class _SendRequestState extends State<SendRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Send Request")));
  }
}
