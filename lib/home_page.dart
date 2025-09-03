import 'package:flutter/material.dart';
import 'package:remote_rift_client/models.dart';
import 'package:remote_rift_client/remote_rift_api.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              switch (_state) {
                null => CircularProgressIndicator(),
                var value => Text(value.displayName),
              },

              if (_state != null) SizedBox(height: 12),

              if (_state case Lobby(state: GameLobbyState.idle))
                ElevatedButton(onPressed: api.searchMatch, child: Text('Search')),

              if (_state case Lobby(state: GameLobbyState.searching))
                ElevatedButton(onPressed: api.stopMatchSearch, child: Text('Cancel')),

              if (_state case Found(state: GameFoundState.pending)) ...[
                ElevatedButton(onPressed: api.acceptMatch, child: Text('Accept')),
                SizedBox(height: 4),
                TextButton(onPressed: api.declineMatch, child: Text('Decline')),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
