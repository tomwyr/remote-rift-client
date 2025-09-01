import 'package:flutter/material.dart';
import 'package:remote_rift_client/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Remote Rift', home: const HomePage());
  }
}
