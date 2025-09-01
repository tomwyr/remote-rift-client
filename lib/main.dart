import 'package:flutter/material.dart';
import 'package:remote_rift_client/models.dart';
import 'package:remote_rift_client/remote_rift_api.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final api = RemoteRiftApi.create(
    noSchemeBaseUrl: '192.168.50.252:8080',
    // proxy: 'PROXY 192.168.50.252:9090',
  );

  RemoteRiftState? _state;

  @override
  void initState() {
    super.initState();
    _listenData();
  }

  void _listenData() async {
    await for (var state in api.getCurrentStateStream()) {
      setState(() => _state = state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: switch (_state) {
          null => CircularProgressIndicator(),
          var value => Text(value.displayName),
        },
      ),
    );
  }
}
